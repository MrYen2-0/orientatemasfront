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
    super.tutorId,
    super.birthdate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      semester: json['semester']?.toString(),
      state: json['state']?.toString(),
      createdAt: json['createdAt'] != null 
        ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
        : DateTime.now(),
      hasCompletedEvaluation: json['hasCompletedEvaluation'] == true,
      isTutor: json['isTutor'] == true,
      phone: json['phone']?.toString(),
      relationship: json['relationship']?.toString(),
      tutorId: json['tutorId']?.toString(),
      birthdate: json['birthdate']?.toString(),
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
      'tutorId': tutorId,
      'birthdate': birthdate,
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
      tutorId: user.tutorId,
      birthdate: user.birthdate,
    );
  }
}