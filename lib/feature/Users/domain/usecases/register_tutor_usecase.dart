import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class RegisterTutorUseCase {
  final AuthRepository repository;

  RegisterTutorUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    return await repository.registerTutor(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );
  }
}