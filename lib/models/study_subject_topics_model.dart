import 'package:me_mobile/models/study_topic_model.dart';

class StudySubjectTopicsModel {
  const StudySubjectTopicsModel({
    required this.id,
    required this.educationBoardId,
    required this.academicClassId,
    required this.subject,
    required this.topics,
  });

  final String id;
  final String educationBoardId;
  final String academicClassId;
  final String subject;
  final List<StudyTopicModel> topics;

  String get subjectLabel {
    final words = subject
        .trim()
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty);
    if (words.isEmpty) {
      return '';
    }

    return words
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  factory StudySubjectTopicsModel.fromJson(Map<String, dynamic> json) {
    final rawTopics = json['topics'];

    return StudySubjectTopicsModel(
      id: _readId(json),
      educationBoardId: _readReferenceId(json['education_board']),
      academicClassId: _readReferenceId(json['academic_class']),
      subject: (json['subject'] ?? '').toString(),
      topics: rawTopics is List
          ? rawTopics
                .whereType<Map>()
                .map(
                  (topic) => StudyTopicModel.fromJson(
                    Map<String, dynamic>.from(topic),
                  ),
                )
                .where((topic) => topic.id.isNotEmpty)
                .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'education_board': educationBoardId,
      'academic_class': academicClassId,
      'subject': subject,
      'topics': topics.map((topic) => topic.toJson()).toList(),
    };
  }
}

String _readId(Map<String, dynamic> json) {
  return (json['id'] ?? json['_id'] ?? '').toString();
}

String _readReferenceId(dynamic value) {
  if (value is Map) {
    return _readId(Map<String, dynamic>.from(value));
  }

  return (value ?? '').toString();
}
