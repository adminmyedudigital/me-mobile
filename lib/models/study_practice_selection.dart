class StudyPracticeSelection {
  const StudyPracticeSelection({
    required this.subjectId,
    required this.subject,
    required this.topic,
    required this.topicEn,
    required this.subTopicId,
    required this.subTopic,
    required this.subTopicEn,
  });

  final String subjectId;
  final String subject;
  final String topic;
  final String topicEn;
  final String subTopicId;
  final String subTopic;
  final String subTopicEn;

  String get topicId => subTopicId;

  String get title => '$subject - $topic - $subTopic';
}
