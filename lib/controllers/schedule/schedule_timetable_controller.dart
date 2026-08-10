import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';

import 'package:me_mobile/utils/utils.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/services/services.dart';
import 'package:me_mobile/controllers/auth_controller.dart';
import 'package:me_mobile/controllers/api_controller_mixin.dart';
import 'package:me_mobile/controllers/dashboard_controller.dart';

export 'package:me_mobile/models/schedule/schedule_timetable_item.dart';

class ScheduleTimetableController extends GetxController
    with ApiControllerMixin {
  final Rx<DateTime> weekStart = DashboardDateUtils.startOfWeek(
    DashboardDateUtils.dateOnly(DateTime.now()),
  ).obs;
  final RxList<StudyPlannerWeekModel> plannerWeeks =
      <StudyPlannerWeekModel>[].obs;
  final RxList<ScheduleTimetableItem> items = <ScheduleTimetableItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  int _nextId = 1;

  DateTime get today => DashboardDateUtils.dateOnly(DateTime.now());

  DateTime get firstScheduleWeekStart => plannerWeeks.isEmpty
      ? DashboardDateUtils.startOfWeek(today)
      : plannerWeeks.first.startDate;

  DateTime get lastScheduleDate => plannerWeeks.isEmpty
      ? firstScheduleWeekStart.add(const Duration(days: 6))
      : plannerWeeks.last.endDate;

  DateTime get lastScheduleWeekStart =>
      DashboardDateUtils.startOfWeek(lastScheduleDate);

  List<DateTime> get weekDays {
    return List.generate(
      7,
      (index) => weekStart.value.add(Duration(days: index)),
    );
  }

  bool get canMovePrevious => weekStart.value.isAfter(firstScheduleWeekStart);

  bool get canMoveNext => weekStart.value.isBefore(lastScheduleWeekStart);

  bool canScheduleDate(DateTime date) {
    final selectedDate = DashboardDateUtils.dateOnly(date);
    return !selectedDate.isBefore(today) &&
        !selectedDate.isBefore(firstScheduleWeekStart) &&
        !selectedDate.isAfter(lastScheduleDate);
  }

  List<ScheduleTimetableItem> itemsForDate(DateTime date) {
    return items
        .where((item) => DashboardDateUtils.isSameDate(item.studyDate, date))
        .toList()
      ..sort((first, second) => first.startHour.compareTo(second.startHour));
  }

  List<ScheduleTimetableItem> get currentWeekItems {
    final end = weekStart.value.add(const Duration(days: 6));
    return items
        .where((item) {
          final date = DashboardDateUtils.dateOnly(item.studyDate);
          return !date.isBefore(weekStart.value) && !date.isAfter(end);
        })
        .toList(growable: false);
  }

  double get totalStudyHours {
    return currentWeekItems.fold<double>(
      0,
      (total, item) => total + item.studyHours,
    );
  }

  int get revisionCount {
    return currentWeekItems.where((item) => item.kind == 'Revision').length;
  }

  int get examPrepCount {
    return currentWeekItems
        .where(
          (item) =>
              item.kind == 'Exam Preparation' || item.kind == 'Exam paper',
        )
        .length;
  }

  Map<String, Map<String, List<String>>> get subjectTopicSubTopics {
    final values = <String, Map<String, Set<String>>>{};

    for (final week in plannerWeeks) {
      for (final plan in week.plans) {
        final subjectName = _capitalizeWords(plan.subject.subject);
        if (subjectName.isEmpty) continue;
        final topics = values.putIfAbsent(
          subjectName,
          () => <String, Set<String>>{},
        );

        for (final topic in plan.subject.topics) {
          if (topic.topicCore.isEmpty) continue;
          final subTopics = topics.putIfAbsent(
            topic.topicCore,
            () => <String>{},
          );
          if (topic.subTopicCore.isNotEmpty) {
            subTopics.add(topic.subTopicCore);
          }
        }
      }
    }

    return values.map(
      (subject, topics) => MapEntry(
        subject,
        topics.map(
          (topic, subTopics) =>
              MapEntry(topic, subTopics.toList(growable: false)),
        ),
      ),
    );
  }

  List<String> get subjects =>
      subjectTopicSubTopics.keys.toList(growable: false);

  List<String> topicsForSubject(String subject) {
    return subjectTopicSubTopics[subject]?.keys.toList(growable: false) ??
        const [];
  }

  List<String> subTopicsForSubjectTopic(String subject, String topic) {
    return subjectTopicSubTopics[subject]?[topic] ?? const [];
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

  String? validateRequiredSelection(Object? value) {
    if (value == null || value.toString().trim().isEmpty) {
      return 'Required';
    }

    return null;
  }

  String? validateStudyDate(
    DateTime? value, {
    required DateTime firstSelectableDate,
    required DateTime weekEnd,
  }) {
    if (value == null) {
      return 'Required';
    }

    if (value.isBefore(today)) {
      return 'Past dates are not allowed';
    }

    if (value.isBefore(firstSelectableDate) || value.isAfter(weekEnd)) {
      return 'Select a date from this week';
    }

    return null;
  }

  String? validateStudyTime(Object? value) {
    return value == null ? 'Required' : null;
  }

  String? validateStudyHours(String? value) {
    final hours = double.tryParse(value ?? '');
    if (hours == null || hours <= 0) {
      return 'Enter hours greater than 0';
    }

    if (hours > 8) {
      return 'Max 8 hours';
    }

    return null;
  }

  String? validateSuggestion(String? value) {
    final suggestion = value?.trim() ?? '';
    if (suggestion.isEmpty) {
      return null;
    }

    if (suggestion.length < 10) {
      return 'Minimum 10 characters';
    }

    if (suggestion.length > 200) {
      return 'Maximum 200 characters';
    }

    return null;
  }

  void showFormValidationError() {
    _showPlanError('Review the highlighted fields and try again.');
  }

  Future<bool> loadStudyPlanner() async {
    if (isLoading.value) return false;

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final authController = Get.find<AuthController>();
      const requestPayload = <String, dynamic>{};
      final requestLog = {
        'method': 'GET',
        'endpoint': ApiRoutes.studyPlanner,
        'headers': {'Authorization': 'Bearer ${authController.authToken}'},
        'payload': requestPayload,
      };

      if (kDebugMode) {
        debugPrint('Study planner API request: ${jsonEncode(requestLog)}');
      }

      final response = await api.get<StudyPlannerWeekModel>(
        ApiRoutes.studyPlanner,
        headers: {'Authorization': 'Bearer ${authController.authToken}'},
        fromJson: (value) => StudyPlannerWeekModel.fromJson(
          Map<String, dynamic>.from(value as Map),
        ),
      );

      final responseLog = {
        'data': response.data
            .map((plannerWeek) => plannerWeek.toJson())
            .toList(growable: false),
        'message': response.message,
        'status': response.status,
      };
      if (kDebugMode) {
        debugPrint('Study planner API response: ${jsonEncode(responseLog)}');
      }

      if (!response.isSuccess) {
        errorMessage.value = response.message.trim().isEmpty
            ? 'Unable to load the study planner.'
            : response.message;
        AppSnackBar.showError(
          title: 'Unable to load study planner',
          message: response.message,
          fallbackMessage: 'Please try again.',
        );
        return false;
      }

      plannerWeeks.assignAll(response.data);
      _setItemsFromPlanner(response.data);
      weekStart.value = response.data.isEmpty
          ? DashboardDateUtils.startOfWeek(today)
          : response.data.first.startDate;
      return true;
    } on Object catch (error) {
      errorMessage.value = error.toString();
      AppSnackBar.showError(
        title: 'Unable to load study planner',
        message: error.toString(),
        fallbackMessage: 'Please try again.',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  bool addItem(ScheduleTimetableItem item) {
    if (!_validateItemForSubmission(item)) return false;
    if (_rejectDuplicate(item)) return false;

    items.add(item.copyWith(id: _nextId++, isSystemGenerated: false));
    return true;
  }

  bool updateItem(ScheduleTimetableItem item) {
    final index = items.indexWhere((entry) => entry.id == item.id);
    if (index == -1) {
      _showPlanError('The selected study plan is no longer available.');
      return false;
    }
    if (!_validateItemForSubmission(item)) return false;
    if (_rejectDuplicate(item, ignoredItemId: item.id)) return false;

    items[index] = item.copyWith(isSystemGenerated: false);
    return true;
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
  }

  void _setItemsFromPlanner(List<StudyPlannerWeekModel> weeks) {
    _nextId = 1;
    final nextItems = <ScheduleTimetableItem>[];

    for (final week in weeks) {
      for (final plan in week.plans) {
        final startDate = plan.startDate;
        final durationMinutes = plan.endDate.difference(startDate).inMinutes;
        final topic = plan.subject.topics.firstOrNull;

        nextItems.add(
          ScheduleTimetableItem(
            id: _nextId++,
            subjectName: _capitalizeWords(plan.subject.subject),
            topicName: topic?.topicCore ?? '',
            subTopicName: topic?.subTopicCore ?? '',
            studyDate: DashboardDateUtils.dateOnly(startDate),
            startHour: startDate.hour + (startDate.minute / 60),
            studyHours: durationMinutes / 60,
            kind: plan.planType,
            suggestion: plan.notes,
          ),
        );
      }
    }

    items.assignAll(nextItems);
  }

  String _capitalizeWords(String value) {
    return value
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map(
          (word) => word.length == 1
              ? word.toUpperCase()
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  bool _validateItemForSubmission(ScheduleTimetableItem item) {
    if (!canScheduleDate(item.studyDate)) {
      _showPlanError('Select an available study date.');
      return false;
    }

    if (item.subjectName.trim().isEmpty ||
        item.topicName.trim().isEmpty ||
        item.subTopicName.trim().isEmpty ||
        item.kind.trim().isEmpty) {
      _showPlanError('Complete all required study-plan fields.');
      return false;
    }

    if (item.startHour < 0 || item.startHour >= 24) {
      _showPlanError('Select a valid study time.');
      return false;
    }

    if (item.studyHours <= 0 || item.studyHours > 8) {
      _showPlanError('Study hours must be greater than 0 and at most 8.');
      return false;
    }

    final suggestionError = validateSuggestion(item.suggestion);
    if (suggestionError != null) {
      _showPlanError(suggestionError);
      return false;
    }

    return true;
  }

  bool _rejectDuplicate(ScheduleTimetableItem candidate, {int? ignoredItemId}) {
    final duplicate = items.any((item) {
      if (item.id == ignoredItemId) return false;

      return DashboardDateUtils.isSameDate(
            item.studyDate,
            candidate.studyDate,
          ) &&
          _minuteOfDay(item.startHour) == _minuteOfDay(candidate.startHour) &&
          _normalized(item.subjectName) == _normalized(candidate.subjectName) &&
          _normalized(item.topicName) == _normalized(candidate.topicName) &&
          _normalized(item.subTopicName) ==
              _normalized(candidate.subTopicName) &&
          _normalized(item.kind) == _normalized(candidate.kind);
    });

    if (!duplicate) return false;

    AppSnackBar.showError(
      title: 'Duplicate study plan',
      message:
          'A matching study plan already exists for this date and start time.',
    );
    return true;
  }

  int _minuteOfDay(double hour) => (hour * 60).round();

  String _normalized(String value) => value.trim().toLowerCase();

  void _showPlanError(String message) {
    AppSnackBar.showError(title: 'Unable to save study plan', message: message);
  }
}
