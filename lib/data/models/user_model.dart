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
    );
  }
}
