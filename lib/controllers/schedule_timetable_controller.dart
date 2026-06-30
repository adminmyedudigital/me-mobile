import 'package:get/get.dart';

import 'package:me_mobile/controllers/dashboard_controller.dart';

class ScheduleTimetableItem {
  const ScheduleTimetableItem({
    required this.id,
    required this.subjectName,
    required this.topicName,
    required this.studyDate,
    required this.startHour,
    required this.studyHours,
    required this.kind,
    required this.suggestion,
    this.isSystemGenerated = true,
  });

  final int id;
  final String subjectName;
  final String topicName;
  final DateTime studyDate;
  final double startHour;
  final double studyHours;
  final String kind;
  final String suggestion;
  final bool isSystemGenerated;

  ScheduleTimetableItem copyWith({
    int? id,
    String? subjectName,
    String? topicName,
    DateTime? studyDate,
    double? startHour,
    double? studyHours,
    String? kind,
    String? suggestion,
    bool? isSystemGenerated,
  }) {
    return ScheduleTimetableItem(
      id: id ?? this.id,
      subjectName: subjectName ?? this.subjectName,
      topicName: topicName ?? this.topicName,
      studyDate: studyDate ?? this.studyDate,
      startHour: startHour ?? this.startHour,
      studyHours: studyHours ?? this.studyHours,
      kind: kind ?? this.kind,
      suggestion: suggestion ?? this.suggestion,
      isSystemGenerated: isSystemGenerated ?? this.isSystemGenerated,
    );
  }
}

class ScheduleTimetableController extends GetxController {
  late final DateTime today = DashboardDateUtils.dateOnly(DateTime.now());
  late final DateTime firstScheduleWeekStart = DashboardDateUtils.startOfWeek(
    today,
  );
  late final DateTime lastScheduleWeekStart = firstScheduleWeekStart.add(
    const Duration(days: 49),
  );
  late final DateTime lastScheduleDate = lastScheduleWeekStart.add(
    const Duration(days: 6),
  );

  late final Rx<DateTime> weekStart = firstScheduleWeekStart.obs;
  final RxList<ScheduleTimetableItem> items = <ScheduleTimetableItem>[].obs;

  int _nextId = 1;

  @override
  void onInit() {
    super.onInit();
    loadGeneratedTimetable();
  }

  List<DateTime> get weekDays {
    return List.generate(
      7,
      (index) => weekStart.value.add(Duration(days: index)),
    );
  }

  bool get canMovePrevious {
    return weekStart.value.isAfter(firstScheduleWeekStart);
  }

  bool get canMoveNext {
    return weekStart.value.isBefore(lastScheduleWeekStart);
  }

  bool canScheduleDate(DateTime date) {
    final selectedDate = DashboardDateUtils.dateOnly(date);
    return !selectedDate.isBefore(today) &&
        !selectedDate.isAfter(lastScheduleDate);
  }

  List<ScheduleTimetableItem> itemsForDate(DateTime date) {
    return items
        .where((item) => DashboardDateUtils.isSameDate(item.studyDate, date))
        .toList()
      ..sort((first, second) => first.startHour.compareTo(second.startHour));
  }

  double get totalStudyHours {
    return items.fold<double>(0, (total, item) => total + item.studyHours);
  }

  int get revisionCount {
    return items.where((item) => item.kind == 'Revision').length;
  }

  int get examPrepCount {
    return items.where((item) => item.kind == 'Exam paper').length;
  }

  Map<String, List<String>> get subjectTopics {
    return const {
      'Mathematics': [
        'Algebra equations',
        'Geometry basics',
        'Previous exam paper',
      ],
      'Science': [
        'Light and reflection',
        'Chemical reactions',
        'Human body systems',
      ],
      'English': [
        'Grammar worksheet',
        'Essay writing',
        'Reading comprehension',
      ],
      'Social Science': [
        'History chapter recap',
        'Geography map practice',
        'Civics short answers',
      ],
    };
  }

  List<String> get subjects {
    return subjectTopics.keys.toList();
  }

  List<String> topicsForSubject(String subject) {
    return subjectTopics[subject] ?? const [];
  }

  String dateLabel(DateTime date) {
    final month = DashboardDateUtils.monthNames[date.month - 1].substring(0, 3);
    return '${date.day} $month';
  }

  String weekRangeLabel(DateTime start, DateTime end) {
    return '${dateLabel(start)} - ${dateLabel(end)}, ${end.year}';
  }

  String timeLabel(double hour) => DashboardDateUtils.timeLabel(hour);

  String durationLabel(double hours) {
    if (hours == hours.roundToDouble()) {
      return '${hours.toInt()}h';
    }

    return '${hours.toStringAsFixed(1)}h';
  }

  void loadGeneratedTimetable() {
    final start = weekStart.value;

    items.assignAll([
      _generated(
        subjectName: 'Mathematics',
        topicName: 'Algebra equations',
        studyDate: start,
        startHour: 7,
        studyHours: 1.5,
        kind: 'Practice',
        suggestion:
            'Solve weak-area examples first, then retry marked mistakes.',
      ),
      _generated(
        subjectName: 'Science',
        topicName: 'Light and reflection',
        studyDate: start.add(const Duration(days: 1)),
        startHour: 17,
        studyHours: 1,
        kind: 'Revision',
        suggestion: 'Revise diagrams and write short definitions from memory.',
      ),
      _generated(
        subjectName: 'English',
        topicName: 'Grammar worksheet',
        studyDate: start.add(const Duration(days: 2)),
        startHour: 18,
        studyHours: 1,
        kind: 'Practice',
        suggestion: 'Focus on sentence correction and punctuation errors.',
      ),
      _generated(
        subjectName: 'Mathematics',
        topicName: 'Previous exam paper',
        studyDate: start.add(const Duration(days: 3)),
        startHour: 16,
        studyHours: 2,
        kind: 'Exam paper',
        suggestion:
            'Attempt the paper with a timer, then review wrong answers.',
      ),
      _generated(
        subjectName: 'Social Science',
        topicName: 'History chapter recap',
        studyDate: start.add(const Duration(days: 4)),
        startHour: 19,
        studyHours: 1,
        kind: 'Revision',
        suggestion: 'Create a short timeline and revise key dates.',
      ),
    ]);
  }

  void addItem(ScheduleTimetableItem item) {
    if (!canScheduleDate(item.studyDate)) return;
    items.add(item.copyWith(id: _nextId++, isSystemGenerated: false));
  }

  void updateItem(ScheduleTimetableItem item) {
    if (!canScheduleDate(item.studyDate)) return;
    final index = items.indexWhere((entry) => entry.id == item.id);
    if (index == -1) return;
    items[index] = item.copyWith(isSystemGenerated: false);
  }

  void deleteItem(int id) {
    items.removeWhere((item) => item.id == id);
  }

  void moveWeek(int direction) {
    final nextWeek = weekStart.value.add(Duration(days: direction * 7));
    if (nextWeek.isBefore(firstScheduleWeekStart) ||
        nextWeek.isAfter(lastScheduleWeekStart)) {
      return;
    }

    weekStart.value = nextWeek;
    loadGeneratedTimetable();
  }

  ScheduleTimetableItem _generated({
    required String subjectName,
    required String topicName,
    required DateTime studyDate,
    required double startHour,
    required double studyHours,
    required String kind,
    required String suggestion,
  }) {
    return ScheduleTimetableItem(
      id: _nextId++,
      subjectName: subjectName,
      topicName: topicName,
      studyDate: studyDate,
      startHour: startHour,
      studyHours: studyHours,
      kind: kind,
      suggestion: suggestion,
    );
  }
}
