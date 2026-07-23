class ExamTopicModel {
  const ExamTopicModel({
    required this.id,
    required this.subjectId,
    required this.topicEn,
    required this.topicCore,
    required this.subTopicEn,
    required this.subTopicCore,
  });

  final String id;
  final String subjectId;
  final String topicEn;
  final String topicCore;
  final String subTopicEn;
  final String subTopicCore;

  String get label => topicCore.trim().isNotEmpty ? topicCore : topicEn;

  factory ExamTopicModel.fromJson(Map<String, dynamic> json) {
    return ExamTopicModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      subjectId: _readReferenceId(json['subject']),
      topicEn: (json['topic_en'] ?? '').toString(),
      topicCore: (json['topic_core'] ?? '').toString(),
      subTopicEn: (json['sub_topic_en'] ?? '').toString(),
      subTopicCore: (json['sub_topic_core'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'subject': subjectId,
      'topic_en': topicEn,
      'topic_core': topicCore,
      'sub_topic_en': subTopicEn,
      'sub_topic_core': subTopicCore,
    };
  }
}

String _readReferenceId(dynamic value) {
  if (value is Map) {
    final map = Map<String, dynamic>.from(value);
    return (map['_id'] ?? map['id'] ?? '').toString();
  }

  return (value ?? '').toString();
}
