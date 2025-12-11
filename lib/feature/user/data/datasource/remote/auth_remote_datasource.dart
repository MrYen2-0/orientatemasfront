import 'package:dio/dio.dart';
import '../../models/user_model.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/constants/api_constants.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });
  
  Future<Map<String, dynamic>> registerAdult({
    required String email,
    required String password,
    required String name,
    required String semester,
    required String state,
  });
  
  Future<Map<String, dynamic>> registerTutor({
    required String email,
    required String password,
    required String name,
    required String phone,
  });
  
  Future<UserModel> registerMinor({
    required String tutorId,
    required String name,
    String? email,
    required String birthdate,
    required String semester,
    required String state,
    required String relationship,
  });
  
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<void> resetPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio}) {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.headers = ApiConstants.headers;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      if (response.statusCode == 200) {
        final userData = response.data['user'];
        final token = response.data['token'];
        
        if (userData == null || token == null) {
          throw ServerException('Respuesta incompleta del servidor');
        }
        
        return {
          'user': UserModel.fromJson(userData),
          'token': token,
        };
      } else {
        throw ServerException('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Credenciales incorrectas. Verifica tu email y contraseña.');
      } else if (e.response?.statusCode == 400) {
        throw ServerException('Datos de login inválidos');
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Error del servidor. Intenta más tarde.');
      } else {
        throw ServerException('Error de conexión. Verifica tu conexión a internet.');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Error inesperado: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> registerAdult({
    required String email,
    required String password,
    required String name,
    required String semester,
    required String state,
  }) async {
    try {
      final response = await dio.post(
        '/api/auth/register/student/adult',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'semester': semester,
          'state': state,
        },
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data == null) {
          throw ServerException('Respuesta vacía del servidor');
        }
        
        final userData = response.data['user'];
        final token = response.data['token'];
        
        if (userData == null || token == null) {
          throw ServerException('El servidor no devolvió los datos completos');
        }
        
        return {
          'user': UserModel.fromJson(userData),
          'token': token,
        };
      } else {
        throw ServerException('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ServerException('Email ya registrado o datos inválidos');
      } else if (e.response?.statusCode == 422) {
        throw ServerException('Datos de registro incompletos o inválidos');
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Error del servidor. Intenta más tarde.');
      } else {
        throw ServerException('Error de conexión. Verifica tu conexión a internet.');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Error inesperado: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> registerTutor({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final response = await dio.post(
        '/api/auth/register/tutor',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'phone': phone,
        },
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final tutorData = response.data['tutor'];
        final token = response.data['token'];
        
        if (tutorData == null || token == null) {
          throw ServerException('Respuesta incompleta del servidor');
        }
        
        return {
          'tutor': UserModel.fromJson(tutorData),
          'token': token,
        };
      } else {
        throw ServerException('Tutor registration failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ServerException('Email ya registrado o datos inválidos');
      } else if (e.response?.statusCode == 422) {
        throw ServerException('Datos de registro incompletos o inválidos');
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Error del servidor. Intenta más tarde.');
      } else {
        throw ServerException('Error de conexión. Verifica tu conexión a internet.');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Error inesperado: $e');
    }
  }

  @override
  Future<UserModel> registerMinor({
    required String tutorId,
    required String name,
    String? email,
    required String birthdate,
    required String semester,
    required String state,
    required String relationship,
  }) async {
    try {
      final response = await dio.post(
        '/api/auth/register/student/minor',
        data: {
          'email': email,
          'name': name,
          'semester': semester,
          'state': state,
          'birthdate': birthdate,
          'relationship': relationship,
          'tutorId': tutorId,
        },
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final userData = response.data['student'] ?? response.data['user'];
        return UserModel.fromJson(userData);
      } else {
        throw ServerException('Minor registration failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ServerException('Datos inválidos para el registro del menor');
      } else if (e.response?.statusCode == 422) {
        throw ServerException('Datos de registro incompletos o inválidos');
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Error del servidor. Intenta más tarde.');
      } else {
        throw ServerException('Error de conexión. Verifica tu conexión a internet.');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Error inesperado: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw ServerException('Logout error: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      throw CacheException('No current user endpoint yet');
    } catch (e) {
      throw ServerException('Get current user error: $e');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw ServerException('Reset password error: $e');
    }
  }
}