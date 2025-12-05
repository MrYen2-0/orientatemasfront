import 'package:dio/dio.dart';
import '../../models/user_model.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/constants/api_constants.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> registerAdult({
    required String email,
    required String password,
    required String name,
    String? semester,
    String? state,
  });

  Future<UserModel> registerTutor({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String relationship,
  });

  Future<UserModel> registerMinor({
    required String tutorToken,
    required String name,
    String? email,
    required String birthdate,
    required String semester,
    required String state,
  });

  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<void> resetPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio}) {
    // Configurar Dio para el Gateway
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.headers = ApiConstants.headers;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    
    // Interceptor para logs en debug
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Attempting login: $email -> ${ApiConstants.loginEndpoint}');
      
      final response = await dio.post(
        '/api/auth/login',  // Ruta relativa
        data: {
          'email': email,
          'password': password,
        },
      );

      print('✅ Login response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final userData = response.data['user'];
        return UserModel.fromJson(userData);
      } else {
        throw ServerException('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('❌ Dio error: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      throw ServerException('Network error: ${e.message}');
    } catch (e) {
      print('❌ Unknown error: $e');
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<UserModel> registerAdult({
    required String email,
    required String password,
    required String name,
    String? semester,
    String? state,
  }) async {
    try {
      print('📝 Registering adult: $name -> ${ApiConstants.registerAdultEndpoint}');
      
      final response = await dio.post(
        '/api/auth/register/adult',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'semester': semester,
          'state': state ?? 'Chiapas',
        },
      );

      print('✅ Register response: ${response.statusCode}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final userData = response.data['user'];
        return UserModel.fromJson(userData);
      } else {
        throw ServerException('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('❌ Register error: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      throw ServerException('Registration error: ${e.message}');
    }
  }

  @override
  Future<UserModel> registerTutor({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String relationship,
  }) async {
    try {
      print('👨‍👩‍👧‍👦 Registering tutor: $name');
      
      final response = await dio.post(
        '/api/auth/register/tutor',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'phone': phone,
          'relationship': relationship,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final userData = response.data['user'];
        return UserModel.fromJson(userData);
      } else {
        throw ServerException('Tutor registration failed');
      }
    } on DioException catch (e) {
      throw ServerException('Tutor registration error: ${e.message}');
    }
  }

  @override
  Future<UserModel> registerMinor({
    required String tutorToken,
    required String name,
    String? email,
    required String birthdate,
    required String semester,
    required String state,
  }) async {
    try {
      // TODO: Implementar endpoint para registro de menor
      // Por ahora, simulamos la respuesta
      await Future.delayed(const Duration(seconds: 1));
      
      // Simular respuesta del menor registrado
      final userData = {
        'id': 'minor-${DateTime.now().millisecondsSinceEpoch}',
        'email': email ?? 'menor@demo.com',
        'name': name,
        'semester': semester,
        'state': state,
        'createdAt': DateTime.now().toIso8601String(),
        'hasCompletedEvaluation': false,
        'isTutor': false,
      };
      
      return UserModel.fromJson(userData);
    } catch (e) {
      throw ServerException('Minor registration error: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      // TODO: Implementar logout en backend si es necesario
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw ServerException('Logout error: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      // TODO: Implementar cuando tengamos JWT tokens
      throw CacheException('No current user endpoint yet');
    } catch (e) {
      throw ServerException('Get current user error: $e');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      // TODO: Implementar reset password
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw ServerException('Reset password error: $e');
    }
  }
}