import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../domain/entities/user.dart'; // AGREGAR ESTE IMPORT
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(User user);
  Future<UserModel> getCachedUser();
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearCache();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  // Constante para la key del usuario
  static const String _cachedUserKey = 'CACHED_USER';
  static const String _cachedTokenKey = 'CACHED_TOKEN';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(User user) async {
    try {
      // Convertir User a UserModel si es necesario
      final userModel = user is UserModel
          ? user
          : UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        semester: user.semester,
        state: user.state,
        createdAt: user.createdAt,
        hasCompletedEvaluation: user.hasCompletedEvaluation,
      );

      final userJson = json.encode(userModel.toJson());
      await sharedPreferences.setString(_cachedUserKey, userJson);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<UserModel> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(_cachedUserKey);
      if (jsonString != null) {
        final userMap = json.decode(jsonString) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      } else {
        throw CacheException();
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheToken(String token) async {
    try {
      await sharedPreferences.setString(_cachedTokenKey, token);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return sharedPreferences.getString(_cachedTokenKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(_cachedUserKey);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await sharedPreferences.remove(_cachedTokenKey);
    } catch (e) {
      throw CacheException();
    }
  }
}