import 'package:get/get.dart';

import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/services/services.dart';
import 'package:me_mobile/controllers/auth_controller.dart';
import 'package:me_mobile/controllers/api_controller_mixin.dart';

class FlashCardController extends GetxController with ApiControllerMixin {
  final Rxn<StudyPracticeSelection> selection = Rxn<StudyPracticeSelection>();
  final RxList<FlashCardData> cards = <FlashCardData>[].obs;
  final RxMap<int, FlashCardFeedback> feedbackByCard =
      <int, FlashCardFeedback>{}.obs;
  final RxInt currentIndex = 0.obs;
  final RxBool showAnswer = false.obs;
  final RxBool showResult = false.obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  String get title => selection.value?.title ?? 'Flashcards';

  FlashCardData get currentCard => cards[currentIndex.value];

  bool get canGoPrevious => currentIndex.value > 0;

  bool get canGoNext => currentIndex.value < cards.length - 1;

  bool get isLastCard => currentIndex.value == cards.length - 1;

  FlashCardFeedback? get selectedFeedback => feedbackByCard[currentIndex.value];

  int get correctCount => feedbackByCard.values
      .where((feedback) => feedback == FlashCardFeedback.known)
      .length;

  int get wrongCount => feedbackByCard.values
      .where((feedback) => feedback == FlashCardFeedback.review)
      .length;

  int get skipCount => cards.length - feedbackByCard.length;

  double get progressPercent {
    if (cards.isEmpty) return 0;

    return (correctCount / cards.length) * 100;
  }

  Future<void> loadFromArgument(Object? argument) async {
    selection.value = argument is StudyPracticeSelection ? argument : null;
    feedbackByCard.clear();
    currentIndex.value = 0;
    showAnswer.value = false;
    showResult.value = false;
    cards.clear();
    errorMessage.value = null;

    final selectedPractice = selection.value;
    if (selectedPractice == null) {
      errorMessage.value = 'Select a subject and topic to load flash cards.';
      return;
    }

    await loadFlashCards();
  }

  Future<void> loadFlashCards() async {
    final selectedPractice = selection.value;
    if (selectedPractice == null || isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final authController = Get.find<AuthController>();
      final endpoint = ApiRoutes.flashCards(
        selectedPractice.subjectId,
        selectedPractice.topicEn,
      );
      final response = await api.get<FlashCardData>(
        endpoint,
        headers: {'Authorization': 'Bearer ${authController.authToken}'},
        fromJson: (value) =>
            FlashCardData.fromJson(Map<String, dynamic>.from(value as Map)),
      );

      if (!response.isSuccess) {
        errorMessage.value = response.message.trim().isEmpty
            ? 'Unable to load flash cards.'
            : response.message;
        return;
      }

      cards.assignAll(
        response.data.where((card) => card.questionCore.trim().isNotEmpty),
      );
      if (cards.isEmpty) {
        errorMessage.value = 'No flash cards are available for this topic.';
      }
    } finally {
      isLoading.value = false;
    }
  }

  void toggleAnswer() {
    showAnswer.value = !showAnswer.value;
  }

  bool goToCard(int direction) {
    final nextIndex = currentIndex.value + direction;
    if (nextIndex < 0 || nextIndex >= cards.length) return false;

    currentIndex.value = nextIndex;
    showAnswer.value = false;
    return true;
  }

  bool setFeedback(FlashCardFeedback feedback) {
    feedbackByCard[currentIndex.value] = feedback;

    if (!canGoNext) return false;

    currentIndex.value += 1;
    showAnswer.value = false;
    return true;
  }

  void setFeedbackAndSubmit(FlashCardFeedback feedback) {
    feedbackByCard[currentIndex.value] = feedback;
    submitResult();
  }

  void submitResult() {
    showResult.value = true;
  }
}
