import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Domain
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/register_adult_usecase.dart';
import '../domain/usecases/register_tutor_usecase.dart';
import '../domain/usecases/register_minor_usecase.dart';
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

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: ApiConstants.headers,
    ));

    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
      logPrint: (obj) => print('🌐 DIO: $obj'),
    ));

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

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

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
  sl.registerLazySingleton(() => RegisterAdultUseCase(sl()));
  sl.registerLazySingleton(() => RegisterTutorUseCase(sl()));
  sl.registerLazySingleton(() => RegisterMinorUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // ============================================
  // PROVIDERS
  // ============================================

sl.registerFactory(
  () => AuthProvider(
    loginUseCase: sl(),
    registerAdultUseCase: sl(),
    registerTutorUseCase: sl(),
    registerMinorUseCase: sl(),
    logoutUseCase: sl(),
    getCurrentUserUseCase: sl(),
    authLocalDataSource: sl(), // ← NUEVO: Agregar esta línea
  ),
);

  sl.registerFactory(() => EvaluationProvider());
  sl.registerFactory(() => CareerProvider());
  sl.registerFactory(() => ProfileProvider());
  sl.registerFactory(() => NotificationProvider());

  print('✅ Todas las dependencias inicializadas correctamente');
}