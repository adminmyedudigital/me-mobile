class ScheduleTimetableItem {
  const ScheduleTimetableItem({
    required this.id,
    required this.subjectName,
    required this.topicName,
    required this.subTopicName,
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
  final String subTopicName;
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
    String? subTopicName,
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
      subTopicName: subTopicName ?? this.subTopicName,
      studyDate: studyDate ?? this.studyDate,
      startHour: startHour ?? this.startHour,
      studyHours: studyHours ?? this.studyHours,
      kind: kind ?? this.kind,
      suggestion: suggestion ?? this.suggestion,
      isSystemGenerated: isSystemGenerated ?? this.isSystemGenerated,
    );
  }
}
