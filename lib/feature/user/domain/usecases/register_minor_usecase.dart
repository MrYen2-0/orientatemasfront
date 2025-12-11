import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterMinorUseCase {
  final AuthRepository repository;

  RegisterMinorUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String tutorId,
    required String name,
    String? email,
    required String birthdate,
    required String semester,
    required String state,
    required String relationship,
  }) async {
    return await repository.registerMinor(
      tutorId: tutorId,
      name: name,
      email: email,
      birthdate: birthdate,
      semester: semester,
      state: state,
      relationship: relationship,
    );
  }
}