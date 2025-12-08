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
import 'repositories/auth_repository_impl.dart';
import 'datasource/remote/auth_remote_datasource.dart';
import 'datasource/local/auth_local_datasource.dart';

// Core
import '../../../core/network/network_info.dart';
import '../../../core/constants/api_constants.dart';

// Presentation - PROVIDERS
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/evaluation_provider.dart';
import '../presentation/providers/career_provider.dart';
import '../presentation/providers/profile_provider.dart';
import '../presentation/providers/notification_provider.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  print('🚀 Inicializando dependencias...');
  
  // ============================================
  // External Dependencies (Third-party packages)
  // ============================================

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Dio (HTTP client) - CONFIGURADO PARA GATEWAY
  sl.registerLazySingleton(() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,  // Gateway URL
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: ApiConstants.headers,
    ));

    // Interceptores para logging
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
      logPrint: (obj) => print('🌐 DIO: $obj'),
    ));

    // Interceptor para manejo de errores
    dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        print('❌ DIO ERROR: ${error.message}');
        print('❌ DIO RESPONSE: ${error.response?.data}');
        handler.next(error);
      },
    ));

    print('✅ Dio configurado para Gateway: ${ApiConstants.baseUrl}');
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
  // PROVIDERS
  // ============================================

  sl.registerFactory(
        () => AuthProvider(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  sl.registerFactory(() => EvaluationProvider());
  sl.registerFactory(() => CareerProvider());
  sl.registerFactory(() => ProfileProvider());
  sl.registerFactory(() => NotificationProvider());

  print('✅ Todas las dependencias inicializadas correctamente');
}