import 'package:me_mobile/enums/enums.dart';

class AddExamPayloadModel {
  const AddExamPayloadModel({
    required this.subjectId,
    required this.subjectTopicIds,
    required this.examDate,
    required this.examType,
    required this.examMarks,
    required this.achievedMarks,
  });

  final String subjectId;
  final List<String> subjectTopicIds;
  final DateTime examDate;
  final ExamType examType;
  final int examMarks;
  final int achievedMarks;

  Map<String, dynamic> toJson() {
    final utcExamDate = DateTime.utc(
      examDate.year,
      examDate.month,
      examDate.day,
    );

    return {
      'subject': subjectId,
      'subject_topics': subjectTopicIds,
      'exam_date': utcExamDate.toIso8601String(),
      'exam_type': examType.name,
      'exam_marks': examMarks,
      'achieved_marks': achievedMarks,
    };
  }
}
