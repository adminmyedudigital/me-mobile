class QuizData {
  const QuizData({
    required this.title,
    required this.options,
    required this.hint,
    required this.correctOptionIndex,
  });

  final String title;
  final List<String> options;
  final String hint;
  final int correctOptionIndex;

  String get correctAnswer => options[correctOptionIndex];
}
