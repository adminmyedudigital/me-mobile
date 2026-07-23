import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/models/models.dart';

class ExamModel {
  const ExamModel({
    required this.id,
    required this.userId,
    required this.subject,
    required this.subjectTopics,
    required this.examDate,
    required this.examType,
    required this.examMarks,
    required this.achievedMarks,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final ExamSubjectModel subject;
  final List<ExamTopicModel> subjectTopics;
  final DateTime examDate;
  final ExamType examType;
  final int examMarks;
  final int achievedMarks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get subjectName => subject.label;
  List<String> get topicNames =>
      subjectTopics.map((topic) => topic.label).toList(growable: false);
  int get scorePercent =>
      examMarks == 0 ? 0 : ((achievedMarks / examMarks) * 100).round();

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    final rawSubject = json['subject'];
    final rawTopics = json['subject_topics'];

    return ExamModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      userId: _readReferenceId(json['user']),
      subject: rawSubject is Map
          ? ExamSubjectModel.fromJson(Map<String, dynamic>.from(rawSubject))
          : ExamSubjectModel(id: rawSubject?.toString() ?? '', subject: ''),
      subjectTopics: rawTopics is List
          ? rawTopics
                .whereType<Map>()
                .map(
                  (topic) =>
                      ExamTopicModel.fromJson(Map<String, dynamic>.from(topic)),
                )
                .toList(growable: false)
          : const [],
      examDate:
          DateTime.tryParse((json['exam_date'] ?? '').toString())?.toLocal() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      examType: _examTypeFrom(json['exam_type']),
      examMarks: _readInt(json['exam_marks']),
      achievedMarks: _readInt(json['achieved_marks']),
      createdAt: DateTime.tryParse(
        (json['created_at'] ?? '').toString(),
      )?.toLocal(),
      updatedAt: DateTime.tryParse(
        (json['updated_at'] ?? '').toString(),
      )?.toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'subject': subject.toJson(),
      'subject_topics': subjectTopics.map((topic) => topic.toJson()).toList(),
      'exam_date': examDate.toUtc().toIso8601String(),
      'exam_type': examType.name,
      'exam_marks': examMarks,
      'achieved_marks': achievedMarks,
      'created_at': createdAt?.toUtc().toIso8601String(),
      'updated_at': updatedAt?.toUtc().toIso8601String(),
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

int _readInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse((value ?? '').toString()) ?? 0;
}

ExamType _examTypeFrom(dynamic value) {
  return switch ((value ?? '').toString().trim().toLowerCase()) {
    'tuition' => ExamType.tuition,
    _ => ExamType.school,
  };
}
