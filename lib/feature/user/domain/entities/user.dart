import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? semester;
  final String? state;
  final DateTime createdAt;
  final bool hasCompletedEvaluation;

  final bool isTutor;
  final String? phone;
  final String? relationship;
  final String? tutorId;
  final String? birthdate;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.semester,
    this.state,
    required this.createdAt,
    this.hasCompletedEvaluation = false,
    this.isTutor = false,
    this.phone,
    this.relationship,
    this.tutorId,
    this.birthdate,
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
    isTutor,
    phone,
    relationship,
    tutorId,
    birthdate,
  ];

  bool get isRegistrationComplete {
    if (isTutor) {
      return phone != null;
    }
    if (tutorId != null) {
      return birthdate != null && semester != null && state != null && relationship != null;
    }
    return semester != null && state != null;
  }
}