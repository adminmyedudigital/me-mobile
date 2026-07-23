import 'package:me_mobile/models/exam/exam_topic_model.dart';

class ExamSubjectModel {
  const ExamSubjectModel({
    required this.id,
    required this.subject,
    this.educationBoardId = '',
    this.academicClassId = '',
    this.topics = const [],
  });

  final String id;
  final String subject;
  final String educationBoardId;
  final String academicClassId;
  final List<ExamTopicModel> topics;

  String get label => _formatLabel(subject);

  factory ExamSubjectModel.fromJson(Map<String, dynamic> json) {
    final rawTopics = json['topics'];

    return ExamSubjectModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      subject: (json['subject'] ?? '').toString(),
      educationBoardId: _readReferenceId(json['education_board']),
      academicClassId: _readReferenceId(json['academic_class']),
      topics: rawTopics is List
          ? rawTopics
                .whereType<Map>()
                .map(
                  (topic) =>
                      ExamTopicModel.fromJson(Map<String, dynamic>.from(topic)),
                )
                .where((topic) => topic.id.isNotEmpty)
                .toList(growable: false)
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'education_board': educationBoardId,
      'academic_class': academicClassId,
      'subject': subject,
      'topics': topics.map((topic) => topic.toJson()).toList(),
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

String _formatLabel(String value) {
  final words = value
      .trim()
      .replaceAll(RegExp(r'[_-]+'), ' ')
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty);

  return words
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}
