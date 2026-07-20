import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/services/services.dart';
import 'package:me_mobile/controllers/auth_controller.dart';
import 'package:me_mobile/controllers/api_controller_mixin.dart';

class StudyController extends GetxController with ApiControllerMixin {
  static const String practiceDialogUpdateId = 'study-practice-dialog';

  final practiceFormKey = GlobalKey<FormState>();

  List<StudySubjectTopicsModel> subjects = const [];
  String? errorMessage;
  bool isLoading = false;
  String? selectedSubjectId;
  String? selectedTopicId;
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
    final academicHistory = authController.academicHistory;
    final educationBoardId = academicHistory?.educationBoardId.trim() ?? '';
    final academicClassId = academicHistory?.academicClassId.trim() ?? '';

    if (educationBoardId.isEmpty || academicClassId.isEmpty) {
      subjects = const [];
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
}
