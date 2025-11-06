import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    required String name,
    String? semester,
    String? state,
  }) async {
    return await repository.register(
      email: email,
      password: password,
      name: name,
      semester: semester,
      state: state,
    );
  }
}
