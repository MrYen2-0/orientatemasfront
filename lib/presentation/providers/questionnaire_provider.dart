import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/questionnaire_session.dart';
import '../../data/datasource/local/questionnaire_local_storage.dart';
import 'package:integradorfront/core/constants/api_constants.dart';

enum QuestionnaireStatus { initial, loading, loaded, error, completed }

class QuestionnaireProvider extends ChangeNotifier {
  final QuestionnaireLocalStorage _localStorage;

  QuestionnaireProvider({QuestionnaireLocalStorage? localStorage})
      : _localStorage = localStorage ?? QuestionnaireLocalStorage();

  // Estado
  QuestionnaireStatus _status = QuestionnaireStatus.initial;
  QuestionnaireSession? _currentSession;
  Map<String, dynamic>? _currentQuestion;
  QuestionnaireResults? _results;
  String _errorMessage = '';
  bool _autoSaveEnabled = true;

  // Getters
  QuestionnaireStatus get status => _status;
  QuestionnaireSession? get currentSession => _currentSession;
  Map<String, dynamic>? get currentQuestion => _currentQuestion;
  QuestionnaireResults? get results => _results;
  String get errorMessage => _errorMessage;
  bool get hasSession => _currentSession != null;
  bool get isCompleted => _currentSession?.estado == 'completado';
  int get preguntasRespondidas => _currentSession?.respuestas.length ?? 0;

  // ==================== GESTIÓN DE SESIÓN ====================

  /// Inicia una nueva sesión (local y remota)
  Future<bool> startNewSession() async {
    try {
      _status = QuestionnaireStatus.loading;
      _errorMessage = '';
      notifyListeners();

      // Llamar a la API para iniciar sesión
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/questionnaire/start'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sessionId = data['session_id'];

        // Crear sesión local
        _currentSession = QuestionnaireSession.initial(sessionId);

        // Guardar localmente
        await _localStorage.saveSession(_currentSession!);

        // Cargar primera pregunta
        await _loadNextQuestion();

        _status = QuestionnaireStatus.loaded;
        notifyListeners();
        return true;
      } else {
        throw Exception('Error al iniciar sesión: ${response.statusCode}');
      }
    } catch (e) {
      _status = QuestionnaireStatus.error;
      _errorMessage = 'Error al iniciar cuestionario: $e';
      notifyListeners();
      return false;
    }
  }

  /// Restaura la sesión en progreso más reciente
  Future<bool> restoreInProgressSession() async {
    try {
      _status = QuestionnaireStatus.loading;
      notifyListeners();

      final session = await _localStorage.getLatestInProgressSession();

      if (session == null) {
        _status = QuestionnaireStatus.initial;
        notifyListeners();
        return false;
      }

      _currentSession = session;

      // Cargar siguiente pregunta
      await _loadNextQuestion();

      _status = QuestionnaireStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _status = QuestionnaireStatus.error;
      _errorMessage = 'Error al restaurar sesión: $e';
      notifyListeners();
      return false;
    }
  }

  /// Carga una sesión específica
  Future<bool> loadSession(String sessionId) async {
    try {
      _status = QuestionnaireStatus.loading;
      notifyListeners();

      final session = await _localStorage.getSession(sessionId);

      if (session == null) {
        throw Exception('Sesión no encontrada');
      }

      _currentSession = session;

      if (session.estado != 'completado') {
        await _loadNextQuestion();
      }

      _status = QuestionnaireStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _status = QuestionnaireStatus.error;
      _errorMessage = 'Error al cargar sesión: $e';
      notifyListeners();
      return false;
    }
  }

  // ==================== GESTIÓN DE PREGUNTAS ====================

  /// Carga la siguiente pregunta desde la API
  Future<void> _loadNextQuestion() async {
    if (_currentSession == null) return;

    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}/api/questionnaire/next/${_currentSession!.sessionId}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['cuestionario_completo'] == true) {
          _currentQuestion = null;
          await _completeQuestionnaire();
        } else {
          _currentQuestion = data;
        }
      } else {
        throw Exception('Error al cargar pregunta: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = 'Error al cargar pregunta: $e';
      print(_errorMessage);
      rethrow;
    }
  }

  /// Envía una respuesta
  Future<bool> submitAnswer(String preguntaId, String respuesta) async {
    if (_currentSession == null) {
      _errorMessage = 'No hay sesión activa';
      return false;
    }

    try {
      _status = QuestionnaireStatus.loading;
      notifyListeners();

      // Enviar a la API
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/questionnaire/answer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'session_id': _currentSession!.sessionId,
          'pregunta_id': preguntaId,
          'respuesta': respuesta,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Actualizar sesión local
        final preguntaTexto = _currentQuestion?['pregunta']?['texto'] ?? '';

        _currentSession = _currentSession!.copyWith(
          respuestas: {
            ..._currentSession!.respuestas,
            preguntaId: respuesta,
          },
          preguntasRespondidas: [
            ..._currentSession!.preguntasRespondidas,
            QuestionResponse(
              preguntaId: preguntaId,
              preguntaTexto: preguntaTexto,
              respuesta: respuesta,
              timestamp: DateTime.now(),
            ),
          ],
          estado: data['cuestionario_completo'] ? 'completado' : 'en_progreso',
        );

        // Guardar localmente si está habilitado
        if (_autoSaveEnabled) {
          await _localStorage.saveSession(_currentSession!);
        }

        // Cargar siguiente pregunta o completar
        if (data['cuestionario_completo'] == true) {
          await _completeQuestionnaire();
        } else {
          await _loadNextQuestion();
        }

        _status = QuestionnaireStatus.loaded;
        notifyListeners();
        return true;
      } else {
        throw Exception('Error al enviar respuesta: ${response.statusCode}');
      }
    } catch (e) {
      _status = QuestionnaireStatus.error;
      _errorMessage = 'Error al enviar respuesta: $e';
      notifyListeners();
      return false;
    }
  }

  // ==================== FINALIZACIÓN ====================

  /// Completa el cuestionario y obtiene resultados
  Future<void> _completeQuestionnaire() async {
    if (_currentSession == null) return;

    try {
      // Obtener resultados de la API
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}/api/questionnaire/prediction/${_currentSession!.sessionId}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _results = QuestionnaireResults.fromJson(data);

        // Actualizar sesión como completada
        _currentSession = _currentSession!.copyWith(
          estado: 'completado',
          timestampFin: DateTime.now(),
        );

        // Guardar sesión y resultados localmente
        await _localStorage.saveSession(_currentSession!);
        await _localStorage.saveResults(_results!);

        _status = QuestionnaireStatus.completed;
        notifyListeners();
      } else {
        throw Exception('Error al obtener resultados: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = 'Error al completar cuestionario: $e';
      print(_errorMessage);
      rethrow;
    }
  }

  /// Obtiene resultados guardados de una sesión
  Future<bool> loadResults(String sessionId) async {
    try {
      _status = QuestionnaireStatus.loading;
      notifyListeners();

      // Buscar en local primero
      final localResults = await _localStorage.getResults(sessionId);

      if (localResults != null) {
        _results = localResults;
        _status = QuestionnaireStatus.completed;
        notifyListeners();
        return true;
      }

      // Si no está local, intentar de la API
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}/api/questionnaire/prediction/$sessionId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _results = QuestionnaireResults.fromJson(data);

        // Guardar localmente
        await _localStorage.saveResults(_results!);

        _status = QuestionnaireStatus.completed;
        notifyListeners();
        return true;
      } else {
        throw Exception('Resultados no encontrados');
      }
    } catch (e) {
      _status = QuestionnaireStatus.error;
      _errorMessage = 'Error al cargar resultados: $e';
      notifyListeners();
      return false;
    }
  }

  // ==================== UTILIDADES ====================

  /// Guarda manualmente la sesión actual
  Future<bool> saveCurrentSession() async {
    if (_currentSession == null) return false;

    try {
      return await _localStorage.saveSession(_currentSession!);
    } catch (e) {
      print('Error al guardar sesión: $e');
      return false;
    }
  }

  /// Cancela la sesión actual
  Future<void> cancelSession() async {
    if (_currentSession != null) {
      await _localStorage.saveSession(_currentSession!);
    }
    _currentSession = null;
    _currentQuestion = null;
    _results = null;
    _status = QuestionnaireStatus.initial;
    notifyListeners();
  }

  /// Resetea el provider
  void reset() {
    _currentSession = null;
    _currentQuestion = null;
    _results = null;
    _status = QuestionnaireStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }

  /// Habilita/deshabilita guardado automático
  void setAutoSave(bool enabled) {
    _autoSaveEnabled = enabled;
    notifyListeners();
  }

  // ==================== HISTÓRICO ====================

  /// Obtiene todas las sesiones guardadas
  Future<List<QuestionnaireSession>> getAllSessions() async {
    return await _localStorage.getAllSessions();
  }

  /// Obtiene todas las sesiones completadas
  Future<List<QuestionnaireSession>> getCompletedSessions() async {
    return await _localStorage.getSessionsByEstado('completado');
  }

  /// Obtiene todos los resultados guardados
  Future<List<QuestionnaireResults>> getAllResults() async {
    return await _localStorage.getAllResults();
  }

  /// Elimina una sesión
  Future<bool> deleteSession(String sessionId) async {
    final success = await _localStorage.deleteSession(sessionId);
    if (success && _currentSession?.sessionId == sessionId) {
      reset();
    }
    return success;
  }

  /// Obtiene estadísticas de uso
  Future<Map<String, dynamic>> getStatistics() async {
    return await _localStorage.getStatistics();
  }
}