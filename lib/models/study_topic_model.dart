import 'package:me_mobile/models/study_sub_topic_model.dart';

class StudyTopicModel {
  const StudyTopicModel({
    required this.topicEn,
    required this.topicCore,
    required this.index,
    required this.academicYear,
    required this.subTopics,
  });

  final String topicEn;
  final String topicCore;
  final int index;
  final int academicYear;
  final List<StudySubTopicModel> subTopics;

  String get label => topicCore.trim().isNotEmpty ? topicCore : topicEn;

  String get selectionKey => '$academicYear:$index:$topicEn';

  factory StudyTopicModel.fromJson(Map<String, dynamic> json) {
    final rawSubTopics = json['sub_topics'];

    return StudyTopicModel(
      topicEn: (json['topic_en'] ?? '').toString(),
      topicCore: (json['topic_core'] ?? '').toString(),
      index: _readInt(json['index']),
      academicYear: _readInt(json['academic_year']),
      subTopics: rawSubTopics is List
          ? rawSubTopics
                .whereType<Map>()
                .map(
                  (subTopic) => StudySubTopicModel.fromJson(
                    Map<String, dynamic>.from(subTopic),
                  ),
                )
                .where((subTopic) => subTopic.id.isNotEmpty)
                .toList(growable: false)
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic_en': topicEn,
      'topic_core': topicCore,
      'index': index,
      'academic_year': academicYear,
      'sub_topics': subTopics
          .map((subTopic) => subTopic.toJson())
          .toList(growable: false),
    };
  }
}

int _readInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}
