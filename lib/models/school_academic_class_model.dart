import 'package:me_mobile/models/education_board_model.dart';

class SchoolAcademicClassModel {
  const SchoolAcademicClassModel({
    required this.schoolAcademicClassId,
    required this.schoolId,
    required this.educationBoards,
  });

  final String schoolAcademicClassId;
  final String schoolId;
  final List<EducationBoardModel> educationBoards;

  static List<SchoolAcademicClassModel> fromApiList(List<dynamic> values) {
    final groupedSchools = <String, SchoolAcademicClassModel>{};

    for (var index = 0; index < values.length; index++) {
      final value = values[index];

      if (value is! Map) {
        continue;
      }

      final schoolAcademicClass = SchoolAcademicClassModel.fromJson(
        Map<String, dynamic>.from(value),
      );
      final schoolKey = schoolAcademicClass.schoolId.isNotEmpty
          ? schoolAcademicClass.schoolId
          : 'unknown-school-$index';
      final existingSchool = groupedSchools[schoolKey];

      groupedSchools[schoolKey] = existingSchool == null
          ? schoolAcademicClass
          : existingSchool._mergeEducationBoards(schoolAcademicClass);
    }

    return groupedSchools.values.toList();
  }

  factory SchoolAcademicClassModel.fromJson(Map<String, dynamic> json) {
    final storedEducationBoards = json['educationBoards'];

    if (storedEducationBoards is List) {
      return SchoolAcademicClassModel(
        schoolAcademicClassId: (json['schoolAcademicClassId'] ?? '').toString(),
        schoolId: (json['schoolId'] ?? '').toString(),
        educationBoards: storedEducationBoards
            .whereType<Map>()
            .map(
              (board) => EducationBoardModel.fromJson(
                Map<String, dynamic>.from(board),
              ),
            )
            .toList(),
      );
    }

    final school = _mapOrEmpty(json['school']);
    final educationBoard = _mapOrEmpty(json['education_board']);
    final academicClass = _mapOrEmpty(json['academic_class']);

    return SchoolAcademicClassModel(
      schoolAcademicClassId: _readId(json),
      schoolId: _readId(school),
      educationBoards: [
        EducationBoardModel.fromApiJson(
          educationBoard,
          academicClass: academicClass,
          schoolAcademicClassId: _readId(json),
        ),
      ],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schoolAcademicClassId': schoolAcademicClassId,
      'schoolId': schoolId,
      'educationBoards': educationBoards
          .map((educationBoard) => educationBoard.toJson())
          .toList(),
    };
  }

  SchoolAcademicClassModel _mergeEducationBoards(
    SchoolAcademicClassModel other,
  ) {
    final mergedEducationBoards = [...educationBoards];

    for (final educationBoard in other.educationBoards) {
      final existingIndex = mergedEducationBoards.indexWhere(
        (existingBoard) => educationBoard.id.isNotEmpty
            ? existingBoard.id == educationBoard.id
            : existingBoard.educationBoard == educationBoard.educationBoard,
      );

      if (existingIndex == -1) {
        mergedEducationBoards.add(educationBoard);
        continue;
      }

      mergedEducationBoards[existingIndex] =
          mergedEducationBoards[existingIndex].mergeAcademicClasses(
            educationBoard,
          );
    }

    return SchoolAcademicClassModel(
      schoolAcademicClassId: schoolAcademicClassId,
      schoolId: schoolId,
      educationBoards: mergedEducationBoards,
    );
  }
}

Map<String, dynamic> _mapOrEmpty(dynamic value) {
  return value is Map ? Map<String, dynamic>.from(value) : const {};
}

String _readId(Map<String, dynamic> json) {
  return (json['id'] ?? json['_id'] ?? '').toString();
}
