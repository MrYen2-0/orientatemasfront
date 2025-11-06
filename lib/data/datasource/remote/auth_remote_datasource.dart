import 'package:dio/dio.dart';
import '../../models/user_model.dart';
import '../../../core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    String? semester,
    String? state,
  });

  Future<void> logout();

  Future<UserModel> getCurrentUser();

  Future<void> resetPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    String? semester,
    String? state,
  }) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'semester': semester,
          'state': state,
        },
      );

      if (response.statusCode == 201) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post('/auth/logout');
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get('/auth/me');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await dio.post(
        '/auth/reset-password',
        data: {'email': email},
      );
    } on DioException {
      throw ServerException();
    }
  }
}
