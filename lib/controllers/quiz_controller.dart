import 'package:get/get.dart';

import 'package:me_mobile/controllers/dashboard_controller.dart';
import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/models/models.dart';

class QuizController extends GetxController {
  final Rxn<DashboardEvent> event = Rxn<DashboardEvent>();
  final RxList<QuizData> questions = <QuizData>[].obs;
  final RxMap<int, int> selectedOptionByQuestion = <int, int>{}.obs;
  final RxSet<int> revealedQuestionIndexes = <int>{}.obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxBool showResult = false.obs;

  String get title => event.value?.title ?? 'Quiz';

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

  void loadFromArgument(Object? argument) {
    final dashboardEvent = argument is DashboardEvent ? argument : null;

    event.value = dashboardEvent;
    questions.assignAll(_buildQuestions(dashboardEvent));
    selectedOptionByQuestion.clear();
    revealedQuestionIndexes.clear();
    currentQuestionIndex.value = 0;
    showResult.value = false;
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

  List<QuizData> _buildQuestions(DashboardEvent? event) {
    final topic = event?.title ?? 'this topic';

    return [
      QuizData(
        title: 'Which practice method works best for remembering $topic?',
        options: const [
          'Reread the notes many times',
          'Use active recall before checking notes',
          'Highlight every important sentence',
          'Study only the easiest parts first',
        ],
        hint:
            'Think about the method that asks your brain to retrieve the idea.',
        correctOptionIndex: 1,
      ),
      QuizData(
        title: 'When should you review $topic after first learning it?',
        options: const [
          'Only before the final exam',
          'Soon after learning, then again later',
          'After forgetting everything',
          'Only when the topic feels easy',
        ],
        hint: 'Memory is stronger when review happens before it fully fades.',
        correctOptionIndex: 1,
      ),
      const QuizData(
        title: 'What does an uncertain answer usually tell you?',
        options: [
          'The topic should be skipped',
          'The answer is definitely wrong',
          'That area needs deliberate practice',
          'The notes are no longer useful',
        ],
        hint: 'Uncertainty is useful feedback for planning your next revision.',
        correctOptionIndex: 2,
      ),
      QuizData(
        title: 'How can you check whether you really understand $topic?',
        options: const [
          'Count how many pages you read',
          'Explain it clearly without notes',
          'Copy the definition five times',
          'Avoid questions until later',
        ],
        hint: 'Understanding shows up when you can explain the idea simply.',
        correctOptionIndex: 1,
      ),
    ];
  }
}
