import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/enums/enums.dart';
import 'package:me_mobile/utils/utils.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/services/services.dart';
import 'package:me_mobile/controllers/auth_controller.dart';
import 'package:me_mobile/controllers/api_controller_mixin.dart';

part 'exams_api.dart';

/*
  Owns the exam list and add-exam form state.
  API methods are separated into exams_api.dart while remaining part of this
  controller library, so every screen reacts to the same operation state.
*/
class ExamsController extends GetxController with ApiControllerMixin {
  static const String resultFormUpdateId = 'exam-result-form';

  /*
    Initial loading and pull-to-refresh are separate so the UI never displays
    the centered loader and RefreshIndicator at the same time.
  */
  final examResultFormKey = GlobalKey<FormState>();
  final RxBool isLoadingSubjects = false.obs;
  final RxBool isLoadingExams = false.obs;
  final RxBool isRefreshingExams = false.obs;
  final RxBool isSubmittingExam = false.obs;
  final RxBool isDeletingExam = false.obs;
  final RxList<ExamModel> exams = <ExamModel>[].obs;
  final RxnString examsErrorMessage = RxnString();

  // A successful POST followed by a failed GET must retry only the GET.
  // Without this flag, tapping the submit button again would create a
  // duplicate exam result.
  bool _hasSubmittedExamPendingRefresh = false;
  String? _updatedExamPendingRefreshId;
  String? _deletedExamPendingRefreshId;

  // Incremented on logout so responses started by the previous user cannot
  // repopulate this in-memory cache after it has been cleared.
  int _sessionGeneration = 0;

  AuthController get _authController => Get.find<AuthController>();

  // Subject/topic options are scoped to the exam form and use exam models.
  List<ExamSubjectModel> subjects = const [];
  String? subjectsErrorMessage;
  ExamModel? editingExam;

  /// Used to disable Add and reject concurrent exam API requests.
  bool get isApiOperationInProgress =>
      isLoadingSubjects.value ||
      isLoadingExams.value ||
      isRefreshingExams.value ||
      isSubmittingExam.value ||
      isDeletingExam.value;

  bool get isEditingResult => editingExam != null;

  String get resultFormTitle =>
      isEditingResult ? 'Edit exam result' : 'Exam result';

  String get submitButtonLabel {
    if (isEditingResult) {
      return _updatedExamPendingRefreshId == editingExam?.id
          ? 'Retry loading exam results'
          : 'Update result';
    }
    return _hasSubmittedExamPendingRefresh
        ? 'Retry loading exam results'
        : 'Save result';
  }

  // Mutable form values live in the controller so validation and submission
  // use one source of truth.
  String? selectedSubjectId;
  List<String> selectedTopicIds = const [];
  DateTime? selectedExamDate;
  ExamType? selectedExamType = ExamType.school;
  String totalMarks = '';
  String achievedMarks = '';

  DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// The earliest allowed date is the same calendar day two months ago.
  ///
  /// The day is clamped for shorter months (for example, March 31 -> January
  /// 31, while April 30 -> February 28/29).
  DateTime get earliestExamDate {
    final currentDate = today;
    final targetMonth = DateTime(currentDate.year, currentDate.month - 2);
    final lastDayOfTargetMonth = DateTime(
      targetMonth.year,
      targetMonth.month + 1,
      0,
    ).day;

    return DateTime(
      targetMonth.year,
      targetMonth.month,
      math.min(currentDate.day, lastDayOfTargetMonth),
    );
  }

  String get selectedExamDateLabel {
    final examDate = selectedExamDate;
    return examDate == null ? '' : formatDate(examDate);
  }

  ExamSubjectModel? get selectedSubject {
    for (final subject in subjects) {
      if (subject.id == selectedSubjectId) return subject;
    }

    return null;
  }

  List<ExamTopicModel> get topicsForSelectedSubject {
    return selectedSubject?.topics ?? const [];
  }

  List<ExamTopicModel> get selectedTopics {
    return topicsForSelectedSubject
        .where((topic) => selectedTopicIds.contains(topic.id))
        .toList(growable: false);
  }

  List<ExamModel> get sortedExams {
    return List<ExamModel>.of(exams)
      ..sort((first, second) => second.examDate.compareTo(first.examDate));
  }

  /// Resets every form value when a new result form is opened.
  void prepareResultForm() {
    editingExam = null;
    _updatedExamPendingRefreshId = null;
    _hasSubmittedExamPendingRefresh = false;
    selectedSubjectId = subjects.firstOrNull?.id;
    selectedTopicIds = const [];
    selectedExamDate = null;
    selectedExamType = ExamType.school;
    totalMarks = '';
    achievedMarks = '';
    update([resultFormUpdateId]);
  }

  /// Prefills the shared result form for the edit UI preview.
  void prepareEditResultForm(ExamModel exam) {
    editingExam = exam;
    _hasSubmittedExamPendingRefresh = false;

    // Keep the current exam selectable even if the latest subject response
    // no longer contains it.
    if (!subjects.any((subject) => subject.id == exam.subject.id)) {
      subjects = [
        ExamSubjectModel(
          id: exam.subject.id,
          subject: exam.subject.subject,
          educationBoardId: exam.subject.educationBoardId,
          academicClassId: exam.subject.academicClassId,
          topics: exam.subjectTopics,
        ),
        ...subjects,
      ];
    }

    selectedSubjectId = exam.subject.id;
    selectedTopicIds = exam.subjectTopics
        .map((topic) => topic.id)
        .toList(growable: false);
    selectedExamDate = DateTime(
      exam.examDate.year,
      exam.examDate.month,
      exam.examDate.day,
    );
    selectedExamType = exam.examType;
    totalMarks = exam.examMarks.toString();
    achievedMarks = exam.achievedMarks.toString();
    update([resultFormUpdateId]);
  }

  void selectSubject(String? subjectId) {
    selectedSubjectId = subjectId;

    // Topics belong to a subject, so selections from the previous subject
    // must never be carried into the new payload.
    selectedTopicIds = const [];
    update([resultFormUpdateId]);
  }

  void selectTopics(List<String> topicIds) {
    final availableTopicIds = topicsForSelectedSubject.map((topic) => topic.id);

    // Ignore stale or externally supplied topic IDs that are not part of the
    // currently selected subject.
    selectedTopicIds = topicIds
        .where(availableTopicIds.contains)
        .toList(growable: false);
    update([resultFormUpdateId]);
  }

  void selectExamDate(DateTime? examDate) {
    selectedExamDate = examDate == null
        ? null
        : DateTime(examDate.year, examDate.month, examDate.day);
    update([resultFormUpdateId]);
  }

  void selectExamType(ExamType? examType) {
    selectedExamType = examType;
  }

  void setTotalMarks(String value) {
    totalMarks = value;
  }

  void setAchievedMarks(String value) {
    achievedMarks = value;
  }

  String? validateSubject(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Select a subject';
    }

    return null;
  }

  String? validateExamType(ExamType? value) {
    if (value == null) {
      return 'Select an exam type';
    }

    return null;
  }

  String? validateTopics(List<String>? value) {
    if (value == null || value.isEmpty) {
      return 'Select at least one topic';
    }

    return null;
  }

  String? validateExamDate(DateTime? value) {
    if (value == null) {
      return 'Select an exam date';
    }

    final examDate = DateTime(value.year, value.month, value.day);
    if (examDate.isAfter(today)) {
      return 'Exam date cannot be in the future';
    }
    if (examDate.isBefore(earliestExamDate)) {
      return 'Exam date cannot be more than 2 months ago';
    }

    return null;
  }

  String? validateTotalMarks(String? value) {
    return _validateMark(
      value,
      fieldName: 'Total marks',
      minimum: 1,
      maximum: 100,
    );
  }

  String? validateAchievedMarks(String? value) {
    final validationMessage = _validateMark(
      value,
      fieldName: 'Achieved marks',
      minimum: 0,
      maximum: 100,
    );
    if (validationMessage != null) return validationMessage;

    final parsedAchievedMarks = int.parse(value!.trim());
    final parsedTotalMarks = int.tryParse(totalMarks.trim());
    if (parsedTotalMarks != null && parsedAchievedMarks > parsedTotalMarks) {
      return 'Achieved marks cannot exceed total marks';
    }

    return null;
  }

  /// Validates and saves the shared add/edit form without calling an API.
  bool validateResultForm() {
    final isValid = examResultFormKey.currentState?.validate() ?? false;
    if (!isValid) return false;

    examResultFormKey.currentState?.save();
    return true;
  }

  /// Clears all user-specific exam data when the authenticated session ends.
  ///
  /// Exam results are intentionally kept only in this controller's memory and
  /// are never written to local storage.
  void clearSessionData() {
    _sessionGeneration++;
    exams.clear();
    examsErrorMessage.value = null;
    _hasSubmittedExamPendingRefresh = false;
    _updatedExamPendingRefreshId = null;
    _deletedExamPendingRefreshId = null;
    subjects = const [];
    subjectsErrorMessage = null;
    editingExam = null;
    selectedSubjectId = null;
    selectedTopicIds = const [];
    selectedExamDate = null;
    selectedExamType = ExamType.school;
    totalMarks = '';
    achievedMarks = '';
    isLoadingSubjects.value = false;
    isLoadingExams.value = false;
    isRefreshingExams.value = false;
    isSubmittingExam.value = false;
    isDeletingExam.value = false;
  }

  /// Shared integer/range validation for total and achieved marks.
  String? _validateMark(
    String? value, {
    required String fieldName,
    required int minimum,
    required int maximum,
  }) {
    final text = (value ?? '').trim();
    if (text.isEmpty) {
      return 'Enter ${fieldName.toLowerCase()}';
    }

    final marks = int.tryParse(text);
    if (marks == null) {
      return '$fieldName must be a whole number';
    }
    if (marks < minimum || marks > maximum) {
      return '$fieldName must be between $minimum and $maximum';
    }

    return null;
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
