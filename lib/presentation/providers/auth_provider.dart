import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../core/error/failures.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  });

  // Estado
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Inicializar - Verificar si hay usuario en sesión
  Future<void> initialize() async {
    _status = AuthStatus.loading;
    notifyListeners();

    final result = await getCurrentUserUseCase();

    result.fold(
          (failure) {
        _status = AuthStatus.unauthenticated;
        _user = null;
        notifyListeners();
      },
          (user) {
        _status = AuthStatus.authenticated;
        _user = user;
        notifyListeners();
      },
    );
  }

  /// Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final result = await loginUseCase(
      email: email,
      password: password,
    );

    return result.fold(
          (failure) {
        _setLoading(false);
        _status = AuthStatus.error;
        _errorMessage = _mapFailureToMessage(failure);
        notifyListeners();
        return false;
      },
          (user) {
        _setLoading(false);
        _status = AuthStatus.authenticated;
        _user = user;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
    );
  }

  /// ✅ Login Demo (AGREGAR ESTE MÉTODO)
  Future<bool> loginDemo() async {
    _setLoading(true);
    _errorMessage = null;

    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    // Crear usuario demo
    final demoUser = User(
      id: 'demo-123',
      email: 'demo@orientaplus.com',
      name: 'Usuario Demo',
      semester: '5° Semestre',
      state: 'Chiapas',
      createdAt: DateTime.now(),
      hasCompletedEvaluation: true,
    );

    _setLoading(false);
    _status = AuthStatus.authenticated;
    _user = demoUser;
    _errorMessage = null;
    notifyListeners();

    return true;
  }

  /// Register
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    String? semester,
    String? state,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final result = await registerUseCase(
      email: email,
      password: password,
      name: name,
      semester: semester,
      state: state,
    );

    return result.fold(
          (failure) {
        _setLoading(false);
        _status = AuthStatus.error;
        _errorMessage = _mapFailureToMessage(failure);
        notifyListeners();
        return false;
      },
          (user) {
        _setLoading(false);
        _status = AuthStatus.authenticated;
        _user = user;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
    );
  }

  /// Logout
  Future<void> logout() async {
    _setLoading(true);

    final result = await logoutUseCase();

    result.fold(
          (failure) {
        _setLoading(false);
        // Aún así cerrar sesión localmente
        _status = AuthStatus.unauthenticated;
        _user = null;
        notifyListeners();
      },
          (_) {
        _setLoading(false);
        _status = AuthStatus.unauthenticated;
        _user = null;
        notifyListeners();
      },
    );
  }

  /// Limpiar error
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // Helpers privados
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return 'No hay conexión a internet';
    } else if (failure is CacheFailure) {
      return 'Error al guardar datos localmente';
    } else {
      return 'Ha ocurrido un error inesperado';
    }
  }
}