import 'package:equatable/equatable.dart';

class Career extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final String iconPath;
  final double compatibilityPercentage;
  final List<String> requiredSkills;
  final List<String> relatedUniversities;
  final String averageSalary;
  final String employmentOutlook;

  const Career({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.iconPath,
    this.compatibilityPercentage = 0.0,
    required this.requiredSkills,
    required this.relatedUniversities,
    required this.averageSalary,
    required this.employmentOutlook,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        iconPath,
        compatibilityPercentage,
        requiredSkills,
        relatedUniversities,
        averageSalary,
        employmentOutlook,
      ];
}
