import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_adult_usecase.dart';
import '../../domain/usecases/register_tutor_usecase.dart';
import '../../domain/usecases/register_minor_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../data/datasource/local/auth_local_datasource.dart';
import '../../../../core/error/failures.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

enum UserType { student, tutor }

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterAdultUseCase registerAdultUseCase;
  final RegisterTutorUseCase registerTutorUseCase;
  final RegisterMinorUseCase registerMinorUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final AuthLocalDataSource authLocalDataSource; // ← NUEVO

  AuthProvider({
    required this.loginUseCase,
    required this.registerAdultUseCase,
    required this.registerTutorUseCase,
    required this.registerMinorUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.authLocalDataSource, // ← NUEVO
  });

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;
  UserType _userType = UserType.student;

  String? _tutorId;
  String? _tutorToken; // Token temporal para registrar menores
  String? _authToken; // ← NUEVO: Token del usuario autenticado

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  UserType get userType => _userType;
  bool get isTutor => _userType == UserType.tutor;
  String? get tutorId => _tutorId;
  String? get tutorToken => _tutorToken;
  String? get authToken => _authToken; // ← NUEVO GETTER

  Future<void> initialize() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final result = await getCurrentUserUseCase();

      result.fold(
        (failure) {
          _status = AuthStatus.unauthenticated;
          _user = null;
          _authToken = null; // ← NUEVO
          notifyListeners();
        },
        (user) async {
          _status = AuthStatus.authenticated;
          _user = user;
          _userType = user.isTutor ? UserType.tutor : UserType.student;

          // ← NUEVO: Cargar token
          _authToken = await authLocalDataSource.getToken();

          notifyListeners();
        },
      );
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _user = null;
      _authToken = null; // ← NUEVO
      notifyListeners();
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _errorMessage = null;

    final result = await loginUseCase(email: email, password: password);

    return result.fold(
      (failure) {
        _setLoading(false);
        _status = AuthStatus.error;
        _errorMessage = _mapFailureToMessage(failure);
        _authToken = null; // ← NUEVO
        notifyListeners();
        return false;
      },
      (user) async {
        _setLoading(false);
        _status = AuthStatus.authenticated;
        _user = user;
        _userType = user.isTutor ? UserType.tutor : UserType.student;
        _errorMessage = null;

        // ← NUEVO: Cargar token después del login
        _authToken = await authLocalDataSource.getToken();
        print(
          '🔑 Token cargado después de login: ${_authToken?.substring(0, 20)}...',
        );

        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> registerAdult({
    required String email,
    required String password,
    required String name,
    required String semester,
    required String state,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final result = await registerAdultUseCase(
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
        _authToken = null; // ← NUEVO
        notifyListeners();
        return false;
      },
      (user) async {
        _setLoading(false);
        _status = AuthStatus.authenticated;
        _user = user;
        _userType = UserType.student;
        _errorMessage = null;

        // ← NUEVO: Cargar token después del registro
        _authToken = await authLocalDataSource.getToken();
        print(
          '🔑 Token cargado después de registro: ${_authToken?.substring(0, 20)}...',
        );

        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> registerTutor({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final result = await registerTutorUseCase(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );

    return result.fold(
      (failure) {
        _setLoading(false);
        _status = AuthStatus.error;
        _errorMessage = _mapFailureToMessage(failure);
        _tutorToken = null; // ← Token temporal
        _tutorId = null;
        notifyListeners();
        return false;
      },
      (data) {
        _setLoading(false);
        _user = data['tutor'];
        _tutorId = data['tutor'].id;
        _tutorToken =
            data['token']; // Token temporal solo para registro de menor
        _userType = UserType.tutor;
        _errorMessage = null;
        print(
          '🔑 Token temporal de tutor: ${_tutorToken?.substring(0, 20)}...',
        );
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> registerMinor({
    required String name,
    String? email,
    required String birthdate,
    required String semester,
    required String state,
    required String relationship,
  }) async {
    if (_tutorId == null) {
      _errorMessage = 'No hay datos del tutor disponibles';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _errorMessage = null;

    final result = await registerMinorUseCase(
      tutorId: _tutorId!,
      name: name,
      email: email,
      birthdate: birthdate,
      semester: semester,
      state: state,
      relationship: relationship,
    );

    return result.fold(
      (failure) {
        _setLoading(false);
        _status = AuthStatus.error;
        _errorMessage = _mapFailureToMessage(failure);
        notifyListeners();
        return false;
      },
      (user) async {
        _setLoading(false);
        _status = AuthStatus.authenticated;
        _user = user;
        _errorMessage = null;

        // ← NUEVO: El menor hereda el token del tutor
        if (_tutorToken != null) {
          await authLocalDataSource.cacheToken(_tutorToken!);
          _authToken = _tutorToken;
          print(
            '🔑 Menor heredó token del tutor: ${_authToken?.substring(0, 20)}...',
          );
        }

        // Limpiar datos temporales
        _tutorId = null;
        _tutorToken = null;

        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> logout() async {
    _setLoading(true);

    final result = await logoutUseCase();

    return result.fold(
      (failure) {
        _setLoading(false);
        _errorMessage = _mapFailureToMessage(failure);
        notifyListeners();
        return false;
      },
      (_) {
        _setLoading(false);
        _status = AuthStatus.unauthenticated;
        _user = null;
        _tutorId = null;
        _tutorToken = null;
        _authToken = null; // ← NUEVO: Limpiar token
        _userType = UserType.student;
        _errorMessage = null;
        print('🔓 Tokens limpiados en logout');
        notifyListeners();
        return true;
      },
    );
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return failure.message;
    }
    return 'Error desconocido';
  }
}
