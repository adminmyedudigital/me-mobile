class FlashCardData {
  const FlashCardData({
    required this.id,
    required this.difficultyLevel,
    required this.questionCore,
    required this.answerCore,
    required this.hintCore,
    required this.summaryCore,
  });

  final String id;
  final String difficultyLevel;
  final String questionCore;
  final String answerCore;
  final String hintCore;
  final String summaryCore;

  factory FlashCardData.fromJson(Map<String, dynamic> json) {
    return FlashCardData(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      difficultyLevel: (json['defiantly_level'] ?? '').toString(),
      questionCore: (json['question_core'] ?? '').toString(),
      answerCore: (json['answer_core'] ?? '').toString(),
      hintCore: (json['hint_core'] ?? '').toString(),
      summaryCore: (json['summary_core'] ?? '').toString(),
    );
  }
}
