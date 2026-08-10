import 'dart:convert';

import 'package:me_mobile/models/auth_model.dart';
import 'package:me_mobile/models/academic_history_model.dart';
import 'package:me_mobile/models/school_academic_class_model.dart';
import 'package:me_mobile/models/study_subject_topics_model.dart';

class AuthSessionModel {
  const AuthSessionModel({
    required this.user,
    required this.token,
    required this.schoolAcademicClasses,
    this.subjects = const [],
    this.academicHistory,
  });

  final AuthUserModel user;
  final String token;
  final List<SchoolAcademicClassModel> schoolAcademicClasses;
  final List<StudySubjectTopicsModel> subjects;
  final AcademicHistoryModel? academicHistory;

  bool get hasValidToken => token.trim().isNotEmpty && !isTokenExpired;

  bool get isTokenExpired {
    final expiry = expiresAt;
    return expiry == null || !expiry.isAfter(DateTime.now());
  }

  DateTime? get expiresAt {
    final payload = _jwtPayload;
    final exp = payload?['exp'];

    if (exp is int) {
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    }

    if (exp is String) {
      final seconds = int.tryParse(exp);
      return seconds == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    }

    return null;
  }

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final subjects = _parseSubjects(json);
    final academicHistory = _parseAcademicHistory(json['academic_history']);

    return AuthSessionModel(
      user: AuthUserModel.fromJson(Map<String, dynamic>.from(json['user'])),
      token: (json['token'] ?? '').toString(),
      schoolAcademicClasses: _parseSchoolAcademicClasses(
        json['school_academic_classes'],
      ),
      subjects: subjects,
      academicHistory: _withFallbackSubjects(academicHistory, subjects),
    );
  }

  factory AuthSessionModel.fromSignInJson(Map<String, dynamic> json) {
    final subjects = _parseSubjects(json);
    final academicHistory = _parseAcademicHistory(json['academic_history']);

    return AuthSessionModel(
      user: AuthUserModel.fromJson(json),
      token: (json['token'] ?? '').toString(),
      schoolAcademicClasses: _parseSchoolAcademicClasses(
        json['school_academic_classes'],
      ),
      subjects: subjects,
      academicHistory: _withFallbackSubjects(academicHistory, subjects),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      'school_academic_classes': schoolAcademicClasses
          .map((schoolClass) => schoolClass.toJson())
          .toList(),
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
      'academic_history': academicHistory?.toJson(),
    };
  }

  static List<StudySubjectTopicsModel> _parseSubjects(
    Map<String, dynamic> json,
  ) {
    var value = json['subjects'];
    final academicHistory = json['academic_history'];
    if (value is! List && academicHistory is Map) {
      value = academicHistory['subjects'];
    }
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

  static AcademicHistoryModel? _parseAcademicHistory(dynamic value) {
    if (value is! Map || value.isEmpty) {
      return null;
    }

    final academicHistory = AcademicHistoryModel.fromJson(
      Map<String, dynamic>.from(value),
    );

    return academicHistory.hasRequiredData ? academicHistory : null;
  }

  static AcademicHistoryModel? _withFallbackSubjects(
    AcademicHistoryModel? academicHistory,
    List<StudySubjectTopicsModel> subjects,
  ) {
    if (academicHistory == null ||
        academicHistory.subjects.isNotEmpty ||
        subjects.isEmpty) {
      return academicHistory;
    }

    return academicHistory.copyWith(subjects: subjects);
  }

  static List<SchoolAcademicClassModel> _parseSchoolAcademicClasses(
    dynamic value,
  ) {
    if (value is! List) {
      return const [];
    }

    final schoolAcademicClasses = value.whereType<Map>().toList();

    if (schoolAcademicClasses.isEmpty) {
      return const [];
    }

    final isStoredFormat =
        schoolAcademicClasses.first['educationBoards'] is List;

    if (isStoredFormat) {
      return schoolAcademicClasses
          .map(
            (schoolClass) => SchoolAcademicClassModel.fromJson(
              Map<String, dynamic>.from(schoolClass),
            ),
          )
          .toList();
    }

    return SchoolAcademicClassModel.fromApiList(schoolAcademicClasses);
  }

  Map<String, dynamic>? get _jwtPayload {
    final parts = token.split('.');

    if (parts.length != 3) {
      return null;
    }

    try {
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      return Map<String, dynamic>.from(jsonDecode(payload) as Map);
    } on FormatException {
      return null;
    }
  }
}
