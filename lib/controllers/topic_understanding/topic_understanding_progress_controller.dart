import 'package:get/get.dart';

import 'package:me_mobile/models/models.dart';

class TopicUnderstandingProgressController extends GetxController {
  static const String editorUpdateId = 'topic-understanding-editor';

  StudyTopicModel? editingTopic;
  StudySubTopicModel? editingSubTopic;
  int editingProgress = 0;

  final Map<String, int> _subTopicProgress = {};

  int topicProgress(StudyTopicModel topic, int topicIndex) {
    if (topic.subTopics.isEmpty) return _sampleTopicProgress(topicIndex);

    var total = 0;
    for (var index = 0; index < topic.subTopics.length; index++) {
      total += subTopicProgress(topicIndex, index, topic.subTopics[index]);
    }
    return (total / topic.subTopics.length).round();
  }

  int subTopicProgress(
    int topicIndex,
    int subTopicIndex,
    StudySubTopicModel subTopic,
  ) {
    return _subTopicProgress.putIfAbsent(
      subTopic.id,
      () => _sampleSubTopicProgress(topicIndex, subTopicIndex),
    );
  }

  void openEditor({
    required StudyTopicModel topic,
    required StudySubTopicModel subTopic,
    required int initialProgress,
  }) {
    editingTopic = topic;
    editingSubTopic = subTopic;
    editingProgress = initialProgress.clamp(0, 100);
    update([editorUpdateId]);
  }

  void setEditingProgress(double value) {
    final progress = value.round().clamp(0, 100);
    if (progress == editingProgress) return;

    editingProgress = progress;
    update([editorUpdateId]);
  }

  void adjustEditingProgress(int amount) {
    setEditingProgress((editingProgress + amount).toDouble());
  }

  bool saveEditingProgress() {
    final subTopic = editingSubTopic;
    if (subTopic == null) return false;

    _subTopicProgress[subTopic.id] = editingProgress;
    update();
    return true;
  }

  void closeEditor() {
    editingTopic = null;
    editingSubTopic = null;
    update();
  }
}

int _sampleTopicProgress(int topicIndex) {
  const values = [0, 25, 50, 75, 100];
  return values[topicIndex % values.length];
}

int _sampleSubTopicProgress(int topicIndex, int subTopicIndex) {
  const values = [0, 18, 42, 67, 84, 100];
  return values[(topicIndex * 2 + subTopicIndex) % values.length];
}
