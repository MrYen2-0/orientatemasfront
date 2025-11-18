import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.semester,
    super.state,
    required super.createdAt,
    super.hasCompletedEvaluation,
    super.isTutor,
    super.phone,
    super.relationship,
    super.minorName,
    super.minorEmail,
    super.minorBirthdate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      semester: json['semester'] as String?,
      state: json['state'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      hasCompletedEvaluation: json['hasCompletedEvaluation'] as bool? ?? false,
      isTutor: json['isTutor'] as bool? ?? false,
      phone: json['phone'] as String?,
      relationship: json['relationship'] as String?,
      minorName: json['minorName'] as String?,
      minorEmail: json['minorEmail'] as String?,
      minorBirthdate: json['minorBirthdate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'semester': semester,
      'state': state,
      'createdAt': createdAt.toIso8601String(),
      'hasCompletedEvaluation': hasCompletedEvaluation,
      'isTutor': isTutor,
      'phone': phone,
      'relationship': relationship,
      'minorName': minorName,
      'minorEmail': minorEmail,
      'minorBirthdate': minorBirthdate,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      semester: user.semester,
      state: user.state,
      createdAt: user.createdAt,
      hasCompletedEvaluation: user.hasCompletedEvaluation,
      isTutor: user.isTutor,
      phone: user.phone,
      relationship: user.relationship,
      minorName: user.minorName,
      minorEmail: user.minorEmail,
      minorBirthdate: user.minorBirthdate,
    );
  }
}