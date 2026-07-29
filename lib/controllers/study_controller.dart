import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/utils/utils.dart';
import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/services/services.dart';
import 'package:me_mobile/controllers/auth_controller.dart';
import 'package:me_mobile/controllers/api_controller_mixin.dart';

class StudyController extends GetxController with ApiControllerMixin {
  static const String practiceDialogUpdateId = 'study-practice-dialog';
  static const String planningSubjectsUpdateId = 'study-planning-subjects';
  static const String planningSubjectsDialogUpdateId =
      'study-planning-subjects-dialog';

  final practiceFormKey = GlobalKey<FormState>();

  String? _planningSubjectsSessionToken;
  List<StudySubjectTopicsModel> subjects = const [];
  String? errorMessage;
  bool isLoading = false;
  String? selectedSubjectId;
  String? selectedTopicId;
  List<String> selectedPlanningSubjectIds = const [];
  List<String> draftPlanningSubjectIds = const [];
  bool isSavingPlanningSubjects = false;
  bool practiceSubmitted = false;

  bool get hasSubjects => subjects.isNotEmpty;
  AutovalidateMode get practiceAutovalidateMode =>
      practiceSubmitted ? AutovalidateMode.always : AutovalidateMode.disabled;

  StudySubjectTopicsModel? get selectedSubject {
    for (final subject in subjects) {
      if (subject.id == selectedSubjectId) {
        return subject;
      }
    }

    return null;
  }

  List<StudyTopicModel> get topicsForSelectedSubject {
    return selectedSubject?.topics ?? const [];
  }

  List<StudySubjectTopicsModel> get selectedPlanningSubjects {
    return Get.find<AuthController>().academicHistory?.subjects ?? const [];
  }

  bool get areAllPlanningSubjectsSelected {
    return subjects.isNotEmpty &&
        subjects.every(
          (subject) => draftPlanningSubjectIds.contains(subject.id),
        );
  }

  void preparePlanningSubjectsDialog() {
    draftPlanningSubjectIds = List<String>.of(selectedPlanningSubjectIds);
    update([planningSubjectsDialogUpdateId]);
  }

  void togglePlanningSubject(String subjectId, bool selected) {
    final subjectIds = draftPlanningSubjectIds.toSet();
    selected ? subjectIds.add(subjectId) : subjectIds.remove(subjectId);
    draftPlanningSubjectIds = subjectIds.toList(growable: false);
    update([planningSubjectsDialogUpdateId]);
  }

  void toggleAllPlanningSubjects(bool selected) {
    draftPlanningSubjectIds = selected
        ? subjects.map((subject) => subject.id).toList(growable: false)
        : const [];
    update([planningSubjectsDialogUpdateId]);
  }

  Future<bool> savePlanningSubjects() async {
    if (isSavingPlanningSubjects) {
      return false;
    }

    final authController = Get.find<AuthController>();
    final academicHistoryId = authController.academicHistory?.id.trim() ?? '';
    if (academicHistoryId.isEmpty) {
      AppSnackBar.showError(
        title: 'Unable to save study planning subjects',
        message: 'The academic history details are unavailable.',
      );
      return false;
    }

    final availableSubjectIds = subjects.map((subject) => subject.id).toSet();
    final subjectIds = draftPlanningSubjectIds
        .where(availableSubjectIds.contains)
        .toList(growable: false);

    isSavingPlanningSubjects = true;
    update([planningSubjectsUpdateId]);

    try {
      final response = await api.put<dynamic>(
        ApiRoutes.academicHistorySubjects(academicHistoryId),
        headers: {'Authorization': 'Bearer ${authController.authToken}'},
        body: {'subjects': subjectIds},
      );

      if (!response.isSuccess) {
        AppSnackBar.showError(
          title: 'Unable to save study planning subjects',
          message: response.message,
        );
        return false;
      }

      final updatedSubjects = _subjectsFromSaveResponse(
        response.data,
        fallbackSubjectIds: subjectIds,
      );
      await authController.updateAcademicHistory(
        authController.academicHistory!.copyWith(subjects: updatedSubjects),
      );
      selectedPlanningSubjectIds = updatedSubjects
          .map((subject) => subject.id)
          .toList(growable: false);
      return true;
    } finally {
      isSavingPlanningSubjects = false;
      update([planningSubjectsUpdateId]);
    }
  }

  void preparePracticeDialog() {
    selectedSubjectId = null;
    selectedTopicId = null;
    practiceSubmitted = false;
    update([practiceDialogUpdateId]);
  }

  void selectSubject(String? value) {
    selectedSubjectId = value;
    selectedTopicId = null;
    update([practiceDialogUpdateId]);
  }

  void selectTopic(String? value) {
    selectedTopicId = value;
    update([practiceDialogUpdateId]);
  }

  StudyPracticeSelection? submitPracticeSelection() {
    practiceSubmitted = true;
    update([practiceDialogUpdateId]);

    if (!(practiceFormKey.currentState?.validate() ?? false)) {
      return null;
    }

    final subject = selectedSubject;
    final topic = _selectedTopic(subject);
    if (subject == null || topic == null) {
      return null;
    }

    return StudyPracticeSelection(
      subjectId: subject.id,
      subject: subject.subjectLabel,
      topicId: topic.id,
      topic: topic.label,
      topicEn: topic.topicEn,
    );
  }

  FormFieldValidator<String> requiredSelection(String fieldName) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName is required';
      }
      return null;
    };
  }

  Future<void> loadSubjectTopics() async {
    if (isLoading) {
      return;
    }

    final authController = Get.find<AuthController>();
    _hydratePlanningSubjects(authController);
    final academicHistory = authController.academicHistory;
    final educationBoardId = academicHistory?.educationBoardId.trim() ?? '';
    final academicClassId = academicHistory?.academicClassId.trim() ?? '';

    if (educationBoardId.isEmpty || academicClassId.isEmpty) {
      subjects = const [];
      selectedPlanningSubjectIds = const [];
      errorMessage = 'Complete your academic setup to load subjects.';
      update();
      return;
    }

    isLoading = true;
    errorMessage = null;
    update();

    try {
      final response = await api.get<StudySubjectTopicsModel>(
        ApiRoutes.subjectTopics(educationBoardId, academicClassId),
        headers: {'Authorization': 'Bearer ${authController.authToken}'},
        fromJson: (value) => StudySubjectTopicsModel.fromJson(
          Map<String, dynamic>.from(value as Map),
        ),
      );
      if (!response.isSuccess) {
        subjects = const [];
        selectedPlanningSubjectIds = const [];
        errorMessage = response.message.trim().isEmpty
            ? 'Unable to load subjects and topics.'
            : response.message;
        return;
      }

      subjects = response.data
          .where(
            (subject) =>
                subject.id.isNotEmpty && subject.subjectLabel.isNotEmpty,
          )
          .toList();
      _reconcilePlanningSubjects();
      errorMessage = subjects.isEmpty
          ? 'No subjects or topics are available for your class.'
          : null;
    } finally {
      isLoading = false;
      update();
    }
  }

  StudyTopicModel? _selectedTopic(StudySubjectTopicsModel? subject) {
    for (final topic in subject?.topics ?? const <StudyTopicModel>[]) {
      if (topic.id == selectedTopicId) {
        return topic;
      }
    }

    return null;
  }

  void _reconcilePlanningSubjects() {
    final availableSubjectIds = subjects.map((subject) => subject.id).toSet();
    selectedPlanningSubjectIds = selectedPlanningSubjectIds
        .where(availableSubjectIds.contains)
        .toList(growable: false);
  }

  void _hydratePlanningSubjects(AuthController authController) {
    final sessionToken = authController.authToken;
    if (_planningSubjectsSessionToken == sessionToken) {
      return;
    }

    _planningSubjectsSessionToken = sessionToken;
    selectedPlanningSubjectIds = authController.subjects
        .map((subject) => subject.id)
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }

  List<StudySubjectTopicsModel> _subjectsFromSaveResponse(
    List<dynamic> responseData, {
    required List<String> fallbackSubjectIds,
  }) {
    final responseSubjects = <StudySubjectTopicsModel>[];
    var hasResponseSubjects = false;

    for (final item in responseData) {
      if (item is! Map) {
        continue;
      }

      final json = Map<String, dynamic>.from(item);
      final nestedAcademicHistory = json['academic_history'];
      final rawSubjects =
          json['subjects'] ??
          (nestedAcademicHistory is Map
              ? nestedAcademicHistory['subjects']
              : null);

      if (rawSubjects is List) {
        hasResponseSubjects = true;
        responseSubjects.addAll(_parseSubjectList(rawSubjects));
      } else if (json.containsKey('subject')) {
        hasResponseSubjects = true;
        final subject = StudySubjectTopicsModel.fromJson(json);
        if (subject.id.isNotEmpty) {
          responseSubjects.add(subject);
        }
      }
    }

    if (hasResponseSubjects || fallbackSubjectIds.isEmpty) {
      return responseSubjects;
    }

    final selectedIds = fallbackSubjectIds.toSet();
    return subjects
        .where((subject) => selectedIds.contains(subject.id))
        .toList(growable: false);
  }

  List<StudySubjectTopicsModel> _parseSubjectList(List<dynamic> values) {
    return values
        .whereType<Map>()
        .map(
          (subject) => StudySubjectTopicsModel.fromJson(
            Map<String, dynamic>.from(subject),
          ),
        )
        .where((subject) => subject.id.isNotEmpty)
        .toList(growable: false);
  }
}
