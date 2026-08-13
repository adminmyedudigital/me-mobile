import 'package:get/get.dart';

import 'package:me_mobile/models/models.dart';
import 'package:me_mobile/controllers/study_controller.dart';

class TopicUnderstandingController extends GetxController {
  String? selectedSubjectId;
  String? selectedTopicKey;
  String? selectedSubTopicId;
  String? expandedTopicKey;

  StudyController get _studyController => Get.find<StudyController>();

  String? get errorMessage => _studyController.errorMessage;

  List<StudySubjectTopicsModel> get planningSubjects {
    final planningSubjectIds = _studyController.selectedPlanningSubjectIds
        .toSet();
    return _studyController.subjects
        .where((subject) => planningSubjectIds.contains(subject.id))
        .toList(growable: false);
  }

  StudySubjectTopicsModel? get selectedSubject {
    for (final subject in planningSubjects) {
      if (subject.id == selectedSubjectId) return subject;
    }
    return null;
  }

  void prepare() {
    selectedSubjectId = null;
    selectedTopicKey = null;
    selectedSubTopicId = null;
    expandedTopicKey = null;
    update();
  }

  void selectSubject(String? subjectId) {
    selectedSubjectId =
        planningSubjects.any((subject) => subject.id == subjectId)
        ? subjectId
        : null;
    selectedTopicKey = null;
    selectedSubTopicId = null;
    expandedTopicKey = null;
    update();
  }

  void setTopicExpanded(StudyTopicModel topic, bool isExpanded) {
    expandedTopicKey = isExpanded ? topic.selectionKey : null;
    update();
  }

  bool isTopicExpanded(StudyTopicModel topic) {
    return expandedTopicKey == topic.selectionKey;
  }

  void selectSubTopic(StudyTopicModel topic, StudySubTopicModel subTopic) {
    selectedTopicKey = topic.selectionKey;
    selectedSubTopicId = subTopic.id;
    update();
  }
}
