import 'dart:math' as math;

class StudyProgressSummary {
  const StudyProgressSummary({
    required this.title,
    required this.subTitle,
    required this.totalProgress,
    required this.studyProgress,
    required this.examProgress,
    required this.weeklyStudyProgress,
    required this.weeklyExamProgress,
    required this.monthlyStudyProgress,
    required this.monthlyExamProgress,
    required this.barChartTitle,
    required this.barChartData,
  });

  factory StudyProgressSummary.fromJson(Map<String, dynamic> json) {
    int readInt(String key) => (json[key] as num? ?? 0).round();
    String readString(String key) => json[key] as String? ?? '';

    return StudyProgressSummary(
      title: readString('title'),
      subTitle: readString('subTitle'),
      totalProgress: readInt('totalProgress'),
      studyProgress: readInt('studyProgress'),
      examProgress: readInt('examProgress'),
      weeklyStudyProgress: readInt('weeklyStudyProgress'),
      weeklyExamProgress: readInt('weeklyExamProgress'),
      monthlyStudyProgress: readInt('monthlyStudyProgress'),
      monthlyExamProgress: readInt('monthlyExamProgress'),
      barChartTitle: readString('barChartTitle'),
      barChartData: [
        for (final item in json['barChartData'] as List<dynamic>? ?? const [])
          if (item is Map<String, dynamic>) ProgressBarChartData.fromJson(item),
      ],
    );
  }

  final String title;
  final String subTitle;
  final int totalProgress;
  final int studyProgress;
  final int examProgress;
  final int weeklyStudyProgress;
  final int weeklyExamProgress;
  final int monthlyStudyProgress;
  final int monthlyExamProgress;
  final String barChartTitle;
  final List<ProgressBarChartData> barChartData;

  double get studyValue => _percentValue(studyProgress);
  double get examValue => _percentValue(examProgress);

  String get displayTitle => title.trim().isEmpty ? 'Progress' : title.trim();
  String get displaySubTitle =>
      subTitle.trim().isEmpty ? 'Over all progress' : subTitle.trim();
  String get displayBarChartTitle => barChartTitle.trim().isEmpty
      ? 'Progress breakdown'
      : barChartTitle.trim();

  static double _percentValue(int value) =>
      math.min(math.max(value, 0), 100) / 100;
}

class ProgressBarChartData {
  const ProgressBarChartData({required this.label, required this.data});

  factory ProgressBarChartData.fromJson(Map<String, dynamic> json) {
    return ProgressBarChartData(
      label: json['label'] as String? ?? '',
      data: (json['data'] as num? ?? 0).round(),
    );
  }

  final String label;
  final int data;

  String get displayLabel => label.trim().isEmpty ? 'Untitled' : label.trim();
}
