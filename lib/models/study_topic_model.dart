class StudyTopicModel {
  const StudyTopicModel({
    required this.id,
    required this.topicEn,
    required this.topicCore,
  });

  final String id;
  final String topicEn;
  final String topicCore;

  String get label => topicCore.trim().isNotEmpty ? topicCore : topicEn;

  factory StudyTopicModel.fromJson(Map<String, dynamic> json) {
    return StudyTopicModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      topicEn: (json['topic_en'] ?? '').toString(),
      topicCore: (json['topic_core'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'topic_en': topicEn, 'topic_core': topicCore};
  }
}
