import 'package:equatable/equatable.dart';

class Career extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> skills;
  final int compatibilityScore;
  final bool isSaved;

  const Career({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.skills,
    this.compatibilityScore = 0,
    this.isSaved = false,
  });

  Career copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    List<String>? skills,
    int? compatibilityScore,
    bool? isSaved,
  }) {
    return Career(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      skills: skills ?? this.skills,
      compatibilityScore: compatibilityScore ?? this.compatibilityScore,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    category,
    skills,
    compatibilityScore,
    isSaved,
  ];
}