import 'package:get/get.dart';

import 'package:me_mobile/controllers/dashboard_controller.dart';
import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/models/models.dart';

class FlashCardController extends GetxController {
  final Rxn<DashboardEvent> event = Rxn<DashboardEvent>();
  final RxList<FlashCardData> cards = <FlashCardData>[].obs;
  final RxMap<int, FlashCardFeedback> feedbackByCard =
      <int, FlashCardFeedback>{}.obs;
  final RxInt currentIndex = 0.obs;
  final RxBool showAnswer = false.obs;

  String get title => event.value?.title ?? 'Flashcards';

  FlashCardData get currentCard => cards[currentIndex.value];

  bool get canGoPrevious => currentIndex.value > 0;

  bool get canGoNext => currentIndex.value < cards.length - 1;

  FlashCardFeedback? get selectedFeedback => feedbackByCard[currentIndex.value];

  void loadFromArgument(Object? argument) {
    final dashboardEvent = argument is DashboardEvent ? argument : null;

    event.value = dashboardEvent;
    cards.assignAll(_buildCards(dashboardEvent));
    feedbackByCard.clear();
    currentIndex.value = 0;
    showAnswer.value = false;
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

  List<FlashCardData> _buildCards(DashboardEvent? event) {
    final topic = event?.title ?? 'this topic';

    return [
      FlashCardData(
        question:
            'What is the best way to remember $topic?What is the best way to remember $topic?What is the best way to remember $topic?What is the best way to remember $topic?What is the best way to remember $topic?What is the best way to remember $topic?What is the best way to remember $topic?What is the best way to remember $topic?',
        hint: 'Think through the answer first, then tap below to check it.',
        answer: 'Use active recall before checking notes.',
        explanation:
            'Active recall means trying to remember the answer before checking it. This strengthens memory more than rereading notes.',
      ),
      const FlashCardData(
        question: 'Why should study sessions be reviewed soon after learning?',
        hint: 'Focus on how memory fades over time.',
        answer: 'Reviewing early slows forgetting.',
        explanation:
            'A quick review after learning helps stabilize the idea, making later revision faster and more effective.',
      ),
      const FlashCardData(
        question: 'What should you do when an answer feels uncertain?',
        hint: 'Think about marking weak areas.',
        answer: 'Flag it and revisit it deliberately.',
        explanation:
            'Uncertain answers show where practice is most useful. Marking them helps prioritize the next study pass.',
      ),
      FlashCardData(
        question: 'How can you check if you truly understand $topic?',
        hint: 'Try explaining it simply.',
        answer: 'Explain it without looking at notes.',
        explanation:
            'If you can explain the idea clearly in your own words, you probably understand it well enough to apply it.',
      ),
    ];
  }
}
