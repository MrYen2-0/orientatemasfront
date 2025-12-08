class CareerModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final double compatibilityScore;
  final List<String> skills;
  final String demand;
  final String salaryRange;
  final String duration;
  final bool isSaved;

  CareerModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.compatibilityScore = 0.0,
    required this.skills,
    required this.demand,
    required this.salaryRange,
    required this.duration,
    this.isSaved = false,
  });

  factory CareerModel.fromJson(Map<String, dynamic> json) {
    return CareerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      compatibilityScore: (json['compatibilityScore'] as num?)?.toDouble() ?? 0.0,
      skills: (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
      demand: json['demand'] as String,
      salaryRange: json['salaryRange'] as String,
      duration: json['duration'] as String,
      isSaved: json['isSaved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'compatibilityScore': compatibilityScore,
      'skills': skills,
      'demand': demand,
      'salaryRange': salaryRange,
      'duration': duration,
      'isSaved': isSaved,
    };
  }

  CareerModel copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    double? compatibilityScore,
    List<String>? skills,
    String? demand,
    String? salaryRange,
    String? duration,
    bool? isSaved,
  }) {
    return CareerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      compatibilityScore: compatibilityScore ?? this.compatibilityScore,
      skills: skills ?? this.skills,
      demand: demand ?? this.demand,
      salaryRange: salaryRange ?? this.salaryRange,
      duration: duration ?? this.duration,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}