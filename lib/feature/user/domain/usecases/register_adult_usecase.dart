import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterAdultUseCase {
  final AuthRepository repository;

  RegisterAdultUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    required String name,
    required String semester,
    required String state,
  }) async {
    return await repository.registerAdult(
      email: email,
      password: password,
      name: name,
      semester: semester,
      state: state,
    );
  }
}