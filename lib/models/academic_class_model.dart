class AcademicClassModel {
  const AcademicClassModel({required this.id, required this.academicClass});

  final String id;
  final String academicClass;

  factory AcademicClassModel.fromApiJson(Map<String, dynamic> json) {
    return AcademicClassModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      academicClass: (json['academic_class'] ?? '').toString(),
    );
  }

  factory AcademicClassModel.fromJson(Map<String, dynamic> json) {
    return AcademicClassModel(
      id: (json['id'] ?? '').toString(),
      academicClass: (json['academicClass'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'academicClass': academicClass};
  }
}
