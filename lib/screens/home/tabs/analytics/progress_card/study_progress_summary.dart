import 'dart:math' as math;

class StudyProgressSummary {
  const StudyProgressSummary({
    required this.studyProgress,
    required this.examProgress,
    required this.title,
    required this.currentWeekStudyProgress,
    required this.currentWeekExamProgress,
    required this.currentMonthStudyProgress,
    required this.currentMonthExamProgress,
  });

  factory StudyProgressSummary.fromJson(Map<String, dynamic> json) {
    int readInt(String key) => (json[key] as num? ?? 0).round();

    return StudyProgressSummary(
      studyProgress: readInt('studyProgress'),
      examProgress: readInt('examProgress'),
      title: json['title'] as String? ?? '',
      currentWeekStudyProgress: readInt('currentWeekStudyProgress'),
      currentWeekExamProgress: readInt('currentWeekExamProgress'),
      currentMonthStudyProgress: readInt('currentMonthStudyProgress'),
      currentMonthExamProgress: readInt('currentMonthExamProgress'),
    );
  }

  final int studyProgress;
  final int examProgress;
  final String title;
  final int currentWeekStudyProgress;
  final int currentWeekExamProgress;
  final int currentMonthStudyProgress;
  final int currentMonthExamProgress;

  double get studyValue => _percentValue(studyProgress);
  double get examValue => _percentValue(examProgress);
  int get combinedProgress => ((studyProgress + examProgress) / 2).round();

  String get displayTitle => title.trim().isEmpty ? 'Progress' : title.trim();

  static double _percentValue(int value) =>
      math.min(math.max(value, 0), 100) / 100;
}
