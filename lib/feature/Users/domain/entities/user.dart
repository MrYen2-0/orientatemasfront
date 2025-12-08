import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? semester;
  final String? state;
  final DateTime createdAt;
  final bool hasCompletedEvaluation;

  // Campos para tutores
  final bool isTutor;
  final String? phone;
  final String? relationship; // Relación con el menor (Padre, Madre, Tutor Legal, etc.)

  // Campos del menor (cuando el usuario es tutor)
  final String? minorName;
  final String? minorEmail;
  final String? minorBirthdate;

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
    this.minorName,
    this.minorEmail,
    this.minorBirthdate,
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
    minorName,
    minorEmail,
    minorBirthdate,
  ];

  // Método para obtener el nombre a mostrar
  String get displayName => isTutor && minorName != null ? minorName! : name;

  // Método para verificar si el registro está completo
  bool get isRegistrationComplete {
    if (isTutor) {
      return minorName != null && minorBirthdate != null && semester != null && state != null;
    }
    return true;
  }
}