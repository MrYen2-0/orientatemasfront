import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  /// Registro de estudiante adulto via Gateway
  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    required String name,
    String? semester,
    String? state,
  }) async {
    print('🔧 RegisterUseCase.call iniciado');
    
    // Llamar al método registerAdult del repository
    return await repository.registerAdult(
      email: email,
      password: password,
      name: name,
      semester: semester,
      state: state,
    );
  }
}