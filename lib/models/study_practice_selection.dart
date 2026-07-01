class StudyPracticeSelection {
  const StudyPracticeSelection({required this.subject, required this.topic});

  final String subject;
  final String topic;

  String get title => '$subject - $topic';
}
