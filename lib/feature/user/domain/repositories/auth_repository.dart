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

  Future<Either<Failure, User>> registerAdult({
    required String email,
    required String password,
    required String name,
    required String semester,
    required String state,
  });

  Future<Either<Failure, Map<String, dynamic>>> registerTutor({
    required String email,
    required String password,
    required String name,
    required String phone,
  });

  Future<Either<Failure, User>> registerMinor({
    required String tutorId,
    required String name,
    String? email,
    required String birthdate,
    required String semester,
    required String state,
    required String relationship,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, void>> resetPassword(String email);
}