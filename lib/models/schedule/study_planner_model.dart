class StudyPlannerWeekModel {
  const StudyPlannerWeekModel({
    required this.startDate,
    required this.endDate,
    required this.totalPlans,
    required this.studyHours,
    required this.practice,
    required this.revision,
    required this.examPreparation,
    required this.plans,
  });

  final DateTime startDate;
  final DateTime endDate;
  final int totalPlans;
  final String studyHours;
  final int practice;
  final int revision;
  final int examPreparation;
  final List<StudyPlannerPlanModel> plans;

  factory StudyPlannerWeekModel.fromJson(Map<String, dynamic> json) {
    return StudyPlannerWeekModel(
      startDate: _parsePlannerDate(json['start_date']),
      endDate: _parsePlannerDate(json['end_date']),
      totalPlans: _asInt(json['total_plans']),
      studyHours: (json['study_hours'] ?? '0h').toString(),
      practice: _asInt(json['practice']),
      revision: _asInt(json['revision']),
      examPreparation: _asInt(json['exam_preparation']),
      plans: _asMapList(
        json['plans'],
      ).map(StudyPlannerPlanModel.fromJson).toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_date': _formatPlannerDate(startDate),
      'end_date': _formatPlannerDate(endDate),
      'total_plans': totalPlans,
      'study_hours': studyHours,
      'practice': practice,
      'revision': revision,
      'exam_preparation': examPreparation,
      'plans': plans.map((plan) => plan.toJson()).toList(growable: false),
    };
  }
}

class StudyPlannerPlanModel {
  const StudyPlannerPlanModel({
    required this.startDate,
    required this.endDate,
    required this.planType,
    required this.notes,
    required this.subject,
  });

  final DateTime startDate;
  final DateTime endDate;
  final String planType;
  final String notes;
  final StudyPlannerSubjectModel subject;

  factory StudyPlannerPlanModel.fromJson(Map<String, dynamic> json) {
    return StudyPlannerPlanModel(
      startDate: DateTime.parse(json['start_date'].toString()).toLocal(),
      endDate: DateTime.parse(json['end_date'].toString()).toLocal(),
      planType: (json['plan_type'] ?? '').toString(),
      notes: (json['notes'] ?? '').toString(),
      subject: StudyPlannerSubjectModel.fromJson(
        Map<String, dynamic>.from(json['subject'] as Map? ?? const {}),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate.toUtc().toIso8601String(),
      'end_date': endDate.toUtc().toIso8601String(),
      'plan_type': planType,
      'notes': notes,
      'subject': subject.toJson(),
    };
  }
}

class StudyPlannerSubjectModel {
  const StudyPlannerSubjectModel({
    required this.id,
    required this.educationBoardId,
    required this.academicClassId,
    required this.subject,
    required this.topics,
  });

  final String id;
  final String educationBoardId;
  final String academicClassId;
  final String subject;
  final List<StudyPlannerTopicModel> topics;

  factory StudyPlannerSubjectModel.fromJson(Map<String, dynamic> json) {
    return StudyPlannerSubjectModel(
      id: (json['_id'] ?? '').toString(),
      educationBoardId: (json['education_board'] ?? '').toString(),
      academicClassId: (json['academic_class'] ?? '').toString(),
      subject: (json['subject'] ?? '').toString(),
      topics: _asMapList(
        json['topics'],
      ).map(StudyPlannerTopicModel.fromJson).toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'education_board': educationBoardId,
      'academic_class': academicClassId,
      'subject': subject,
      'topics': topics.map((topic) => topic.toJson()).toList(growable: false),
    };
  }
}

class StudyPlannerTopicModel {
  const StudyPlannerTopicModel({
    required this.id,
    required this.topicEn,
    required this.topicCore,
    required this.subTopicEn,
    required this.subTopicCore,
    required this.difficultyLevel,
  });

  final String id;
  final String topicEn;
  final String topicCore;
  final String subTopicEn;
  final String subTopicCore;
  final String difficultyLevel;

  factory StudyPlannerTopicModel.fromJson(Map<String, dynamic> json) {
    return StudyPlannerTopicModel(
      id: (json['_id'] ?? '').toString(),
      topicEn: (json['topic_en'] ?? '').toString(),
      topicCore: (json['topic_core'] ?? '').toString(),
      subTopicEn: (json['sub_topic_en'] ?? '').toString(),
      subTopicCore: (json['sub_topic_core'] ?? '').toString(),
      difficultyLevel: (json['defiantly_level'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'topic_en': topicEn,
      'topic_core': topicCore,
      'sub_topic_en': subTopicEn,
      'sub_topic_core': subTopicCore,
      'defiantly_level': difficultyLevel,
    };
  }
}

DateTime _parsePlannerDate(dynamic value) {
  final parts = value.toString().split('-');
  if (parts.length != 3) {
    throw FormatException('Invalid planner date: $value');
  }

  return DateTime(
    int.parse(parts[2]),
    int.parse(parts[1]),
    int.parse(parts[0]),
  );
}

String _formatPlannerDate(DateTime value) {
  String twoDigits(int number) => number.toString().padLeft(2, '0');
  return '${twoDigits(value.day)}-${twoDigits(value.month)}-${value.year}';
}

int _asInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList(growable: false);
}
