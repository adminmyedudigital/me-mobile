import 'package:me_mobile/models/academic_class_model.dart';

class EducationBoardModel {
  const EducationBoardModel({
    required this.id,
    required this.educationBoard,
    required this.shortName,
    required this.coreLanguage,
    required this.academicClasses,
  });

  final String id;
  final String educationBoard;
  final String shortName;
  final String coreLanguage;
  final List<AcademicClassModel> academicClasses;

  factory EducationBoardModel.fromApiJson(
    Map<String, dynamic> json, {
    required Map<String, dynamic> academicClass,
    String schoolAcademicClassId = '',
  }) {
    final coreLanguage = _mapOrEmpty(json['core_language']);

    return EducationBoardModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      educationBoard: (json['education_board'] ?? '').toString(),
      shortName: (json['short_name'] ?? '').toString(),
      coreLanguage: (coreLanguage['language'] ?? '').toString(),
      academicClasses: [
        AcademicClassModel.fromApiJson(
          academicClass,
          schoolAcademicClassId: schoolAcademicClassId,
        ),
      ],
    );
  }

  factory EducationBoardModel.fromJson(Map<String, dynamic> json) {
    final academicClasses = json['academicClasses'];

    return EducationBoardModel(
      id: (json['id'] ?? '').toString(),
      educationBoard: (json['educationBoard'] ?? '').toString(),
      shortName: (json['shortName'] ?? '').toString(),
      coreLanguage: (json['coreLanguage'] ?? '').toString(),
      academicClasses: academicClasses is List
          ? academicClasses
                .whereType<Map>()
                .map(
                  (academicClass) => AcademicClassModel.fromJson(
                    Map<String, dynamic>.from(academicClass),
                  ),
                )
                .toList()
          : const [],
    );
  }

  EducationBoardModel mergeAcademicClasses(EducationBoardModel other) {
    final mergedAcademicClasses = [...academicClasses];

    for (final academicClass in other.academicClasses) {
      final alreadyExists = mergedAcademicClasses.any(
        (existingClass) => academicClass.id.isNotEmpty
            ? existingClass.id == academicClass.id
            : existingClass.academicClass == academicClass.academicClass,
      );

      if (!alreadyExists) {
        mergedAcademicClasses.add(academicClass);
      }
    }

    return EducationBoardModel(
      id: id,
      educationBoard: educationBoard,
      shortName: shortName,
      coreLanguage: coreLanguage,
      academicClasses: mergedAcademicClasses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'educationBoard': educationBoard,
      'shortName': shortName,
      'coreLanguage': coreLanguage,
      'academicClasses': academicClasses
          .map((academicClass) => academicClass.toJson())
          .toList(),
    };
  }
}

Map<String, dynamic> _mapOrEmpty(dynamic value) {
  return value is Map ? Map<String, dynamic>.from(value) : const {};
}
