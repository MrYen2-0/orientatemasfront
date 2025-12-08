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
      print('🔄 Iniciando nueva sesión...');
      _status = QuestionnaireStatus.loading;
      _errorMessage = '';
      notifyListeners();

      // URL corregida para pasar por el API Gateway
      final url = '${ApiConstants.baseUrl}/api/session/start';
      print('🌐 URL: $url');

      final uri = Uri.parse(url);
      print('📍 URI parseado: $uri');

      // Test de conectividad
      try {
        print('🧪 Probando conectividad...');
        final healthCheck = await http.get(Uri.parse('${ApiConstants.baseUrl}/health'));
        print('✅ Health check: ${healthCheck.statusCode}');
        print('📄 Health response: ${healthCheck.body}');
      } catch (e) {
        print('❌ Error en health check: $e');
      }

      print('📤 Enviando POST a /api/session/start...');

      // Llamar a la API para iniciar sesión
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'metadata': {
            'timestamp': DateTime.now().toIso8601String(),
            'source': 'flutter_app',
          }
        }),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
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
        throw Exception('Error del servidor: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error en startNewSession: $e');
      _status = QuestionnaireStatus.error;
      _errorMessage = 'Error al iniciar cuestionario: $e';
      notifyListeners();
      return false;
    }
  }

  /// Restaura la sesión en progreso más reciente
  Future<bool> restoreInProgressSession() async {
    try {
      print('🔍 Buscando sesión en progreso...');
      _status = QuestionnaireStatus.loading;
      notifyListeners();

      final session = await _localStorage.getLatestInProgressSession();

      if (session == null) {
        print('📭 No hay sesión en progreso');
        _status = QuestionnaireStatus.initial;
        notifyListeners();
        return false;
      }

      print('📋 Sesión encontrada: ${session.sessionId}');
      _currentSession = session;

      // Cargar siguiente pregunta
      await _loadNextQuestion();

      _status = QuestionnaireStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error al restaurar sesión: $e');
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
      print('📝 Cargando siguiente pregunta para ${_currentSession!.sessionId}');
      
      // URL corregida para el API Gateway
      final url = '${ApiConstants.baseUrl}/api/session/${_currentSession!.sessionId}/next-question';
      print('🌐 URL pregunta: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('📥 Response status pregunta: ${response.statusCode}');
      print('📄 Response body pregunta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['session_status'] == 'ready_to_finish' && data['pregunta'] == null) {
          print('✅ Cuestionario completado');
          _currentQuestion = null;
          await _completeQuestionnaire();
        } else {
          _currentQuestion = data;
          print('📋 Pregunta cargada: ${data['pregunta']?['id'] ?? 'N/A'}');
        }
      } else {
        throw Exception('Error al cargar pregunta: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error al cargar pregunta: $e');
      _errorMessage = 'Error al cargar pregunta: $e';
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
      print('📤 Enviando respuesta: $preguntaId = $respuesta');
      _status = QuestionnaireStatus.loading;
      notifyListeners();

      // URL corregida para el API Gateway
      final url = '${ApiConstants.baseUrl}/api/session/${_currentSession!.sessionId}/answer';
      print('🌐 URL respuesta: $url');

      // Enviar a la API
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'pregunta_id': preguntaId,
          'respuesta': respuesta,
        }),
      );

      print('📥 Response status respuesta: ${response.statusCode}');
      print('📄 Response body respuesta: ${response.body}');

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
          estado: data['debe_continuar'] == false ? 'listo_para_finalizar' : 'en_progreso',
        );

        // Guardar localmente si está habilitado
        if (_autoSaveEnabled) {
          await _localStorage.saveSession(_currentSession!);
        }

        // Cargar siguiente pregunta o completar
        if (data['debe_continuar'] == false && data['puede_finalizar'] == true) {
          print('✅ Listo para completar cuestionario');
          await _completeQuestionnaire();
        } else {
          await _loadNextQuestion();
        }

        _status = QuestionnaireStatus.loaded;
        notifyListeners();
        return true;
      } else {
        throw Exception('Error al enviar respuesta: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error al enviar respuesta: $e');
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
      print('🎯 Completando cuestionario...');
      
      // URL corregida para el API Gateway
      final url = '${ApiConstants.baseUrl}/api/session/${_currentSession!.sessionId}/finish';
      print('🌐 URL finish: $url');

      // Obtener resultados de la API
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('📥 Response status finish: ${response.statusCode}');
      print('📄 Response body finish: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _results = QuestionnaireResults.fromJson(data['reporte_completo']);

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
        throw Exception('Error al obtener resultados: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error al completar cuestionario: $e');
      _errorMessage = 'Error al completar cuestionario: $e';
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
        Uri.parse('${ApiConstants.baseUrl}/api/session/$sessionId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Si la sesión está completada, obtener resultados
        if (data['status'] == 'completed') {
          final resultsResponse = await http.post(
            Uri.parse('${ApiConstants.baseUrl}/api/session/$sessionId/finish'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          );
          
          if (resultsResponse.statusCode == 200) {
            final resultsData = jsonDecode(resultsResponse.body);
            _results = QuestionnaireResults.fromJson(resultsData['reporte_completo']);

            // Guardar localmente
            await _localStorage.saveResults(_results!);

            _status = QuestionnaireStatus.completed;
            notifyListeners();
            return true;
          }
        }
      }
      
      throw Exception('Resultados no encontrados');
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