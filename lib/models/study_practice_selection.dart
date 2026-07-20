class StudyPracticeSelection {
  const StudyPracticeSelection({
    required this.subjectId,
    required this.subject,
    required this.topicId,
    required this.topic,
    required this.topicEn,
  });

  final String subjectId;
  final String subject;
  final String topicId;
  final String topic;
  final String topicEn;

  String get title => '$subject - $topic';
}
