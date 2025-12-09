import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../datasource/remote/auth_remote_datasource.dart';
import '../datasource/local/auth_local_datasource.dart';
import '../../../../core/network/network_info.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.login(
          email: email,
          password: password,
        );
        
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Error del servidor'));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    String? semester,
    String? state,
  }) async {
    return await registerAdult(
      email: email,
      password: password,
      name: name,
      semester: semester ?? '',
      state: state ?? '',
    );
  }

  @override
  Future<Either<Failure, User>> registerAdult({
    required String email,
    required String password,
    required String name,
    required String semester,
    required String state,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.registerAdult(
          email: email,
          password: password,
          name: name,
          semester: semester,
          state: state,
        );
        
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Error al registrar usuario'));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> registerTutor({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.registerTutor(
          email: email,
          password: password,
          name: name,
          phone: phone,
        );
        
        await localDataSource.cacheUser(result['tutor']);
        await localDataSource.cacheToken(result['token']);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Error al registrar tutor'));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, User>> registerMinor({
    required String tutorId,
    required String name,
    String? email,
    required String birthdate,
    required String semester,
    required String state,
    required String relationship,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.registerMinor(
          tutorId: tutorId,
          name: name,
          email: email,
          birthdate: birthdate,
          semester: semester,
          state: state,
          relationship: relationship,
        );
        
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Error al registrar menor'));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearCache();
      await localDataSource.clearToken();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error al cerrar sesión'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      return Right(cachedUser);
    } on CacheException {
      if (await networkInfo.isConnected) {
        try {
          final user = await remoteDataSource.getCurrentUser();
          await localDataSource.cacheUser(user);
          return Right(user);
        } on ServerException {
          return Left(ServerFailure('No se pudo obtener el usuario'));
        }
      } else {
        return Left(CacheFailure('No hay usuario en caché'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(email);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure('Error al restablecer contraseña'));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet'));
    }
  }
}