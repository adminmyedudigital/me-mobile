class StudySubTopicModel {
  const StudySubTopicModel({
    required this.id,
    required this.index,
    required this.subTopicEn,
    required this.subTopicCore,
  });

  final String id;
  final int index;
  final String subTopicEn;
  final String subTopicCore;

  String get label =>
      subTopicCore.trim().isNotEmpty ? subTopicCore : subTopicEn;

  factory StudySubTopicModel.fromJson(Map<String, dynamic> json) {
    return StudySubTopicModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      index: _readInt(json['index']),
      subTopicEn: (json['sub_topic_en'] ?? '').toString(),
      subTopicCore: (json['sub_topic_core'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'sub_topic_en': subTopicEn,
      'sub_topic_core': subTopicCore,
    };
  }
}

int _readInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}
