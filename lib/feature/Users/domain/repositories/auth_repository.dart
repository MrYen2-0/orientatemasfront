import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    String? semester,
    String? state,
  });

  /// 🆕 NUEVO: Registro de estudiante adulto
  Future<Either<Failure, User>> registerAdult({
    required String email,
    required String password,
    required String name,
    String? semester,
    String? state,
  });

  /// 🆕 NUEVO: Registro de tutor
  Future<Either<Failure, User>> registerTutor({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String relationship,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, void>> resetPassword(String email);
}