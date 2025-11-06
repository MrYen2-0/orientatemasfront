import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/user_model.dart';
import '../../../core/error/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String cachedUserKey = 'CACHED_USER';
  static const String tokenKey = 'AUTH_TOKEN';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getCachedUser() async {
    final jsonString = sharedPreferences.getString(cachedUserKey);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
      cachedUserKey,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(cachedUserKey);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(tokenKey);
  }

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(tokenKey, token);
  }

  @override
  Future<void> clearToken() async {
    await sharedPreferences.remove(tokenKey);
  }
}
