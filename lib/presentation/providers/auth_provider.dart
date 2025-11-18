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

enum UserType {
  student,
  tutor,
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
  UserType _userType = UserType.student;

  // Datos temporales del tutor (para vincular con el menor)
  Map<String, dynamic>? _tutorData;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  UserType get userType => _userType;
  bool get isTutor => _userType == UserType.tutor;

  /// Inicializar - Verificar si hay usuario en sesión
  Future<void> initialize() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
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
          _userType = user.isTutor ? UserType.tutor : UserType.student;
          notifyListeners();
        },
      );
    } catch (e) {
      // Si hay error de conexión, simplemente marcar como no autenticado
      print('⚠️ Error en initialize: $e');
      _status = AuthStatus.unauthenticated;
      _user = null;
      notifyListeners();
    }
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
        _userType = user.isTutor ? UserType.tutor : UserType.student;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
    );
  }

  /// Login Demo
  Future<bool> loginDemo() async {
    _setLoading(true);
    _errorMessage = null;

    await Future.delayed(const Duration(seconds: 1));

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
    _userType = UserType.student;
    _errorMessage = null;
    notifyListeners();

    return true;
  }

  /// Register (Estudiante regular) - DEPRECADO, ahora solo se registran tutores
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
        _userType = UserType.student;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
    );
  }

  /// ✅ NUEVO: Registrar Tutor
  Future<bool> registerTutor({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String relationship,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      print('📝 Registrando tutor: $name');

      // TODO: Aquí irá la llamada real al backend cuando esté listo
      // Por ahora simulamos el registro
      await Future.delayed(const Duration(seconds: 1));

      // Guardar datos temporales del tutor
      _tutorData = {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'relationship': relationship,
      };

      // Crear usuario temporal del tutor
      final tutorUser = User(
        id: 'temp-tutor-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        phone: phone,
        relationship: relationship,
        isTutor: true,
        createdAt: DateTime.now(),
        hasCompletedEvaluation: false,
      );

      _setLoading(false);
      _status = AuthStatus.authenticated;
      _user = tutorUser;
      _userType = UserType.tutor;
      _errorMessage = null;

      print('✅ Tutor registrado exitosamente');
      notifyListeners();

      return true;
    } catch (e) {
      print('❌ Error al registrar tutor: $e');
      _setLoading(false);
      _status = AuthStatus.error;
      _errorMessage = 'Error al registrar tutor: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// ✅ NUEVO: Registrar Menor (vinculado al tutor)
  Future<bool> registerMinor({
    required String name,
    String? email,
    required String birthdate,
    required String semester,
    required String state,
  }) async {
    if (_tutorData == null) {
      _errorMessage = 'No hay datos del tutor disponibles';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      print('📝 Registrando menor: $name');

      // TODO: Aquí irá la llamada real al backend cuando esté listo
      // Por ahora simulamos el registro
      await Future.delayed(const Duration(seconds: 1));

      // Crear usuario completo con datos del tutor y menor
      final completeUser = User(
        id: 'tutor-${DateTime.now().millisecondsSinceEpoch}',
        email: _tutorData!['email'],
        name: _tutorData!['name'],
        phone: _tutorData!['phone'],
        relationship: _tutorData!['relationship'],
        isTutor: true,
        minorName: name,
        minorEmail: email,
        minorBirthdate: birthdate,
        semester: semester,
        state: state,
        createdAt: DateTime.now(),
        hasCompletedEvaluation: false,
      );

      _setLoading(false);
      _status = AuthStatus.authenticated;
      _user = completeUser;
      _userType = UserType.tutor;
      _errorMessage = null;
      _tutorData = null; // Limpiar datos temporales

      print('✅ Menor registrado exitosamente');
      notifyListeners();

      return true;
    } catch (e) {
      print('❌ Error al registrar menor: $e');
      _setLoading(false);
      _status = AuthStatus.error;
      _errorMessage = 'Error al registrar menor: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Logout
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
        _tutorData = null;
        _userType = UserType.student;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
    );
  }

  /// Limpiar error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Setters privados
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Mapear failures a mensajes
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message ?? 'Error del servidor';
    } else if (failure is NetworkFailure) {
      return failure.message ?? 'Sin conexión a internet';
    } else if (failure is CacheFailure) {
      return failure.message ?? 'Error de caché';
    }
    return 'Error desconocido';
  }
}