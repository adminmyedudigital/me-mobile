import 'package:get/get.dart';

import 'package:me_mobile/controllers/api_controller_mixin.dart';
import 'package:me_mobile/controllers/auth_controller.dart';
import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/services/services.dart';

class QuizController extends GetxController with ApiControllerMixin {
  final Rxn<StudyPracticeSelection> selection = Rxn<StudyPracticeSelection>();
  final RxList<QuizData> questions = <QuizData>[].obs;
  final RxMap<int, int> selectedOptionByQuestion = <int, int>{}.obs;
  final RxSet<int> revealedQuestionIndexes = <int>{}.obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxBool showResult = false.obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  String get title => selection.value?.title ?? 'Quiz';

  QuizData get currentQuestion => questions[currentQuestionIndex.value];

  int? get selectedOptionIndex =>
      selectedOptionByQuestion[currentQuestionIndex.value];

  bool get showCorrectAnswer =>
      revealedQuestionIndexes.contains(currentQuestionIndex.value);

  bool get isCurrentAnswerCorrect =>
      selectedOptionIndex != null &&
      selectedOptionIndex == currentQuestion.correctOptionIndex;

  bool get canGoPrevious => currentQuestionIndex.value > 0;

  bool get canGoNext => currentQuestionIndex.value < questions.length - 1;

  bool get isLastQuestion => currentQuestionIndex.value == questions.length - 1;

  int get correctAnswerCount {
    var count = 0;

    for (var index = 0; index < questions.length; index += 1) {
      if (selectedOptionByQuestion[index] ==
          questions[index].correctOptionIndex) {
        count += 1;
      }
    }

    return count;
  }

  int get wrongAnswerCount => questions.length - correctAnswerCount;

  double get progressPercent {
    if (questions.isEmpty) return 0;

    return (correctAnswerCount / questions.length) * 100;
  }

  Future<void> loadFromArgument(Object? argument) async {
    selection.value = argument is StudyPracticeSelection ? argument : null;
    questions.clear();
    selectedOptionByQuestion.clear();
    revealedQuestionIndexes.clear();
    currentQuestionIndex.value = 0;
    showResult.value = false;
    errorMessage.value = null;

    if (selection.value == null) {
      errorMessage.value = 'Select a subject and topic to load a quiz.';
      return;
    }

    await loadQuizzes();
  }

  Future<void> loadQuizzes() async {
    final selectedPractice = selection.value;
    if (selectedPractice == null || isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final authController = Get.find<AuthController>();
      final response = await api.get<QuizData>(
        ApiRoutes.quizzes(selectedPractice.subjectId, selectedPractice.topicEn),
        headers: {'Authorization': 'Bearer ${authController.authToken}'},
        fromJson: (value) =>
            QuizData.fromJson(Map<String, dynamic>.from(value as Map)),
      );

      if (!response.isSuccess) {
        errorMessage.value = response.message.trim().isEmpty
            ? 'Unable to load the quiz.'
            : response.message;
        return;
      }

      questions.assignAll(response.data.where((question) => question.isValid));
      if (questions.isEmpty) {
        errorMessage.value = 'No quiz questions are available for this topic.';
      }
    } finally {
      isLoading.value = false;
    }
  }

  void selectOption(int index) {
    if (selectedOptionIndex != null) return;

    selectedOptionByQuestion[currentQuestionIndex.value] = index;
    revealedQuestionIndexes.add(currentQuestionIndex.value);
  }

  bool goToQuestion(int direction) {
    final nextIndex = currentQuestionIndex.value + direction;
    if (nextIndex < 0 || nextIndex >= questions.length) return false;

    currentQuestionIndex.value = nextIndex;
    return true;
  }

  void submitQuiz() {
    showResult.value = true;
  }

  QuizAnswerState answerStateForOption(int optionIndex) {
    final selectedIndex = selectedOptionIndex;

    if (showCorrectAnswer &&
        optionIndex == currentQuestion.correctOptionIndex) {
      return QuizAnswerState.correct;
    }

    if (showCorrectAnswer &&
        selectedIndex == optionIndex &&
        optionIndex != currentQuestion.correctOptionIndex) {
      return QuizAnswerState.wrong;
    }

    if (selectedIndex == optionIndex) {
      return QuizAnswerState.selected;
    }

    return QuizAnswerState.idle;
  }
}
