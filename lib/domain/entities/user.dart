import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? semester;
  final String? state;
  final DateTime createdAt;
  final bool hasCompletedEvaluation;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.semester,
    this.state,
    required this.createdAt,
    this.hasCompletedEvaluation = false,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        semester,
        state,
        createdAt,
        hasCompletedEvaluation,
      ];
}
