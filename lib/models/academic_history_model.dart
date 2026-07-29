import 'package:me_mobile/models/study_subject_topics_model.dart';

class AcademicHistoryModel {
  const AcademicHistoryModel({
    required this.id,
    required this.user,
    required this.schoolName,
    required this.schoolId,
    required this.schoolAcademicClassId,
    required this.educationBoardId,
    required this.educationBoard,
    required this.shortName,
    required this.coreLanguage,
    required this.coreLanguageId,
    required this.academicClassId,
    required this.academicClass,
    required this.startMonth,
    required this.startYear,
    required this.endMonth,
    required this.endYear,
    required this.isActive,
    this.subjects = const [],
  });

  final String id;
  final String user;
  final String schoolName;
  final String schoolId;
  final String schoolAcademicClassId;
  final String educationBoardId;
  final String educationBoard;
  final String shortName;
  final String coreLanguage;
  final String coreLanguageId;
  final String academicClassId;
  final String academicClass;
  final int startMonth;
  final int startYear;
  final int endMonth;
  final int endYear;
  final bool isActive;
  final List<StudySubjectTopicsModel> subjects;

  bool get hasRequiredData =>
      id.trim().isNotEmpty &&
      user.trim().isNotEmpty &&
      schoolId.trim().isNotEmpty &&
      schoolAcademicClassId.trim().isNotEmpty &&
      educationBoardId.trim().isNotEmpty &&
      academicClassId.trim().isNotEmpty &&
      startMonth > 0 &&
      startYear > 0 &&
      endMonth > 0 &&
      endYear > 0;

  factory AcademicHistoryModel.fromJson(Map<String, dynamic> json) {
    // Locally stored sessions use the flattened camelCase representation.
    if (json.containsKey('schoolAcademicClassId')) {
      return AcademicHistoryModel(
        id: _readId(json),
        user: (json['user'] ?? '').toString(),
        schoolName: (json['schoolName'] ?? '').toString(),
        schoolId: (json['schoolId'] ?? '').toString(),
        schoolAcademicClassId: (json['schoolAcademicClassId'] ?? '').toString(),
        educationBoardId: (json['educationBoardId'] ?? '').toString(),
        educationBoard: (json['educationBoard'] ?? '').toString(),
        shortName: (json['shortName'] ?? '').toString(),
        coreLanguage: (json['coreLanguage'] ?? '').toString(),
        coreLanguageId: (json['coreLanguageId'] ?? '').toString(),
        academicClassId: (json['academicClassId'] ?? '').toString(),
        academicClass: (json['academicClass'] ?? '').toString(),
        startMonth: _readInt(json['startMonth']),
        startYear: _readInt(json['startYear']),
        endMonth: _readInt(json['endMonth']),
        endYear: _readInt(json['endYear']),
        isActive: json['isActive'] == true,
        subjects: _parseSubjects(json['subjects']),
      );
    }

    final schoolAcademicClass = _mapOrEmpty(json['school_academic_class']);
    final user = json['user'];
    final school = _mapOrEmpty(schoolAcademicClass['school']);
    final educationBoard = _mapOrEmpty(schoolAcademicClass['education_board']);
    final coreLanguage = _mapOrEmpty(educationBoard['core_language']);
    final academicClass = _mapOrEmpty(schoolAcademicClass['academic_class']);

    return AcademicHistoryModel(
      id: _readId(json),
      user: user is Map
          ? _readId(Map<String, dynamic>.from(user))
          : (user ?? '').toString(),
      schoolName: (school['name'] ?? '').toString(),
      schoolId: _readId(school),
      schoolAcademicClassId: _readId(schoolAcademicClass),
      educationBoardId: _readId(educationBoard),
      educationBoard: (educationBoard['education_board'] ?? '').toString(),
      shortName: (educationBoard['short_name'] ?? '').toString(),
      coreLanguage: (coreLanguage['language'] ?? '').toString(),
      coreLanguageId: _readId(coreLanguage),
      academicClassId: _readId(academicClass),
      academicClass: (academicClass['academic_class'] ?? '').toString(),
      startMonth: _readInt(json['start_month']),
      startYear: _readInt(json['start_year']),
      endMonth: _readInt(json['end_month']),
      endYear: _readInt(json['end_year']),
      isActive: json['is_active'] == true,
      subjects: _parseSubjects(json['subjects']),
    );
  }

  AcademicHistoryModel copyWith({List<StudySubjectTopicsModel>? subjects}) {
    return AcademicHistoryModel(
      id: id,
      user: user,
      schoolName: schoolName,
      schoolId: schoolId,
      schoolAcademicClassId: schoolAcademicClassId,
      educationBoardId: educationBoardId,
      educationBoard: educationBoard,
      shortName: shortName,
      coreLanguage: coreLanguage,
      coreLanguageId: coreLanguageId,
      academicClassId: academicClassId,
      academicClass: academicClass,
      startMonth: startMonth,
      startYear: startYear,
      endMonth: endMonth,
      endYear: endYear,
      isActive: isActive,
      subjects: subjects ?? this.subjects,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'schoolName': schoolName,
      'schoolId': schoolId,
      'schoolAcademicClassId': schoolAcademicClassId,
      'educationBoardId': educationBoardId,
      'educationBoard': educationBoard,
      'shortName': shortName,
      'coreLanguage': coreLanguage,
      'coreLanguageId': coreLanguageId,
      'academicClassId': academicClassId,
      'academicClass': academicClass,
      'startMonth': startMonth,
      'startYear': startYear,
      'endMonth': endMonth,
      'endYear': endYear,
      'isActive': isActive,
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
    };
  }
}

List<StudySubjectTopicsModel> _parseSubjects(dynamic value) {
  if (value is! List) {
    return const [];
  }

  return value
      .whereType<Map>()
      .map(
        (subject) => StudySubjectTopicsModel.fromJson(
          Map<String, dynamic>.from(subject),
        ),
      )
      .where((subject) => subject.id.isNotEmpty)
      .toList(growable: false);
}

Map<String, dynamic> _mapOrEmpty(dynamic value) {
  return value is Map ? Map<String, dynamic>.from(value) : const {};
}

String _readId(Map<String, dynamic> json) {
  return (json['id'] ?? json['_id'] ?? '').toString();
}

int _readInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}
