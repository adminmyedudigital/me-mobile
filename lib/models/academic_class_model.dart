class AcademicClassModel {
  const AcademicClassModel({
    required this.id,
    required this.academicClass,
    this.schoolAcademicClassId = '',
  });

  final String id;
  final String academicClass;
  final String schoolAcademicClassId;

  factory AcademicClassModel.fromApiJson(
    Map<String, dynamic> json, {
    String schoolAcademicClassId = '',
  }) {
    return AcademicClassModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      academicClass: (json['academic_class'] ?? '').toString(),
      schoolAcademicClassId: schoolAcademicClassId,
    );
  }

  factory AcademicClassModel.fromJson(Map<String, dynamic> json) {
    return AcademicClassModel(
      id: (json['id'] ?? '').toString(),
      academicClass: (json['academicClass'] ?? '').toString(),
      schoolAcademicClassId: (json['schoolAcademicClassId'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'academicClass': academicClass,
      'schoolAcademicClassId': schoolAcademicClassId,
    };
  }
}
