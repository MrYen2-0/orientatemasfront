import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Domain
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/get_current_user_usecase.dart';

// Data
import '../data/repositories/auth_repository_impl.dart';
import '../data/datasource/remote/auth_remote_datasource.dart';
import '../data/datasource/local/auth_local_datasource.dart';

// Core
import '../core/network/network_info.dart';

// Presentation - PROVIDERS (no BLoCs)
import '../presentation/providers/auth_provider.dart';

final sl = GetIt.instance;

/// Inicializa todas las dependencias del proyecto
/// Este método debe llamarse antes de runApp() en main.dart
Future<void> initializeDependencies() async {
  // ============================================
  // External Dependencies (Third-party packages)
  // ============================================

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Dio (HTTP client)
  sl.registerLazySingleton(() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.orientaplus.com', // Cambiar por tu API real
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Interceptores para logging y manejo de tokens
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    return dio;
  });

  // Connectivity
  sl.registerLazySingleton(() => Connectivity());

  // ============================================
  // Core
  // ============================================

  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(sl()),
  );

  // ============================================
  // Data Sources
  // ============================================

  // Remote Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  // Local Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ============================================
  // Repositories
  // ============================================

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // ============================================
  // Use Cases
  // ============================================

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // ============================================
  // PROVIDERS (reemplaza BLoCs)
  // ============================================

  // ChangeNotifier - usa Factory para crear nueva instancia cada vez
  sl.registerFactory(
        () => AuthProvider(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );
}