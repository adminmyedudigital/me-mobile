import 'package:get/get.dart';

enum ExamType {
  school('School'),
  tuition('Tuition');

  const ExamType(this.label);

  final String label;
}

class ExamItem {
  const ExamItem({
    required this.subjectName,
    required this.examDate,
    required this.type,
    required this.totalMarks,
    required this.achievedMarks,
  });

  final String subjectName;
  final DateTime examDate;
  final ExamType type;
  final int totalMarks;
  final int achievedMarks;

  int get scorePercent => ((achievedMarks / totalMarks) * 100).round();
}

class ExamsController extends GetxController {
  final List<String> subjects = const [
    'English',
    'Mathematics',
    'Science',
    'Social Studies',
  ];

  final RxList<ExamItem> exams = <ExamItem>[
    ExamItem(
      subjectName: 'English',
      examDate: DateTime(2026, 7, 4),
      type: ExamType.school,
      totalMarks: 100,
      achievedMarks: 86,
    ),
    ExamItem(
      subjectName: 'Mathematics',
      examDate: DateTime(2026, 7, 2),
      type: ExamType.tuition,
      totalMarks: 80,
      achievedMarks: 72,
    ),
    ExamItem(
      subjectName: 'Science',
      examDate: DateTime(2026, 6, 29),
      type: ExamType.school,
      totalMarks: 100,
      achievedMarks: 91,
    ),
    ExamItem(
      subjectName: 'Social Studies',
      examDate: DateTime(2026, 6, 24),
      type: ExamType.tuition,
      totalMarks: 50,
      achievedMarks: 41,
    ),
  ].obs;

  List<ExamItem> get sortedExams {
    return List<ExamItem>.of(exams)
      ..sort((first, second) => second.examDate.compareTo(first.examDate));
  }

  void addExamResult({
    required String subjectName,
    required ExamType type,
    required int totalMarks,
    required int achievedMarks,
  }) {
    exams.add(
      ExamItem(
        subjectName: subjectName,
        examDate: DateTime.now(),
        type: type,
        totalMarks: totalMarks,
        achievedMarks: achievedMarks,
      ),
    );
  }

  String formatDate(DateTime date) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }
}
