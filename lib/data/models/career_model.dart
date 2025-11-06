import '../../domain/entities/career.dart';

class CareerModel extends Career {
  const CareerModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    required super.iconPath,
    super.compatibilityPercentage,
    required super.requiredSkills,
    required super.relatedUniversities,
    required super.averageSalary,
    required super.employmentOutlook,
  });

  factory CareerModel.fromJson(Map<String, dynamic> json) {
    return CareerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      iconPath: json['iconPath'] as String,
      compatibilityPercentage: (json['compatibilityPercentage'] as num?)?.toDouble() ?? 0.0,
      requiredSkills: List<String>.from(json['requiredSkills'] as List),
      relatedUniversities: List<String>.from(json['relatedUniversities'] as List),
      averageSalary: json['averageSalary'] as String,
      employmentOutlook: json['employmentOutlook'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'iconPath': iconPath,
      'compatibilityPercentage': compatibilityPercentage,
      'requiredSkills': requiredSkills,
      'relatedUniversities': relatedUniversities,
      'averageSalary': averageSalary,
      'employmentOutlook': employmentOutlook,
    };
  }

  factory CareerModel.fromEntity(Career career) {
    return CareerModel(
      id: career.id,
      name: career.name,
      description: career.description,
      category: career.category,
      iconPath: career.iconPath,
      compatibilityPercentage: career.compatibilityPercentage,
      requiredSkills: career.requiredSkills,
      relatedUniversities: career.relatedUniversities,
      averageSalary: career.averageSalary,
      employmentOutlook: career.employmentOutlook,
    );
  }
}
