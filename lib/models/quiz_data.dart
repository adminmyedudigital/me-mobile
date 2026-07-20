class QuizData {
  const QuizData({
    required this.id,
    required this.difficultyLevel,
    required this.questionCore,
    required this.optionsCore,
    required this.answerCore,
    required this.hintCore,
    required this.summaryCore,
    required this.correctOptionIndex,
  });

  final String id;
  final String difficultyLevel;
  final String questionCore;
  final List<String> optionsCore;
  final String answerCore;
  final String hintCore;
  final String summaryCore;
  final int correctOptionIndex;

  String get title => questionCore;

  List<String> get options => optionsCore;

  String get hint => hintCore;

  String get correctAnswer =>
      correctOptionIndex >= 0 && correctOptionIndex < optionsCore.length
      ? optionsCore[correctOptionIndex]
      : answerCore;

  bool get isValid =>
      questionCore.trim().isNotEmpty &&
      optionsCore.length >= 2 &&
      correctOptionIndex >= 0 &&
      correctOptionIndex < optionsCore.length;

  factory QuizData.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options_core'] ?? json['options'];
    final optionValues = rawOptions is List
        ? rawOptions
        : [
            json['option_a_core'] ?? json['option_a'],
            json['option_b_core'] ?? json['option_b'],
            json['option_c_core'] ?? json['option_c'],
            json['option_d_core'] ?? json['option_d'],
          ];
    final options = optionValues
        .map(_optionText)
        .where((option) => option.trim().isNotEmpty)
        .toList(growable: false);
    final answer =
        (json['answer_core'] ??
                json['correct_answer_core'] ??
                json['correct_answer'] ??
                '')
            .toString();

    return QuizData(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      difficultyLevel:
          (json['defiantly_level'] ?? json['difficulty_level'] ?? '')
              .toString(),
      questionCore: (json['question_core'] ?? json['question'] ?? '')
          .toString(),
      optionsCore: options,
      answerCore: answer,
      hintCore: (json['hint_core'] ?? json['hint'] ?? '').toString(),
      summaryCore: (json['summary_core'] ?? json['summary'] ?? '').toString(),
      correctOptionIndex: _correctOptionIndex(
        json,
        optionValues,
        options,
        answer,
      ),
    );
  }

  static String _optionText(dynamic value) {
    if (value is Map) {
      return (value['option_core'] ??
              value['text'] ??
              value['label'] ??
              value['value'] ??
              '')
          .toString();
    }

    return value?.toString() ?? '';
  }

  static int _correctOptionIndex(
    Map<String, dynamic> json,
    List<dynamic> rawOptions,
    List<String> options,
    String answer,
  ) {
    final flaggedIndex = rawOptions.indexWhere(
      (option) =>
          option is Map &&
          (option['is_correct'] == true || option['correct'] == true),
    );
    if (flaggedIndex >= 0) return flaggedIndex;

    final rawIndex = json['correct_option_index'] ?? json['answer_index'];
    final parsedIndex = rawIndex is int
        ? rawIndex
        : int.tryParse(rawIndex?.toString() ?? '');
    if (parsedIndex != null &&
        parsedIndex >= 0 &&
        parsedIndex < options.length) {
      return parsedIndex;
    }

    final normalizedAnswer = answer.trim().toLowerCase();
    return options.indexWhere(
      (option) => option.trim().toLowerCase() == normalizedAnswer,
    );
  }
}
