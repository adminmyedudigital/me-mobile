class StudyPracticeSelection {
  const StudyPracticeSelection({
    required this.subjectId,
    required this.subject,
    required this.topicId,
    required this.topic,
  });

  final String subjectId;
  final String subject;
  final String topicId;
  final String topic;

  String get title => '$subject - $topic';
}
