import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/questionnaire_session.dart';
import '../../data/datasource/local/questionnaire_local_storage.dart';
import '../../core/constants/api_constants.dart';

enum QuestionnaireStatus { initial, loading, loaded, error, completed }

class QuestionnaireProvider extends ChangeNotifier {
  final QuestionnaireLocalStorage _localStorage;

  QuestionnaireProvider({QuestionnaireLocalStorage? localStorage})
      : _localStorage = localStorage ?? QuestionnaireLocalStorage();

  QuestionnaireStatus _status = QuestionnaireStatus.initial;
  QuestionnaireSession? _currentSession;
  Map<String, dynamic>? _currentQuestion;
  QuestionnaireResults? _results;
  String _errorMessage = '';
  bool _autoSaveEnabled = true;

  QuestionnaireStatus get status => _status;
  QuestionnaireSession? get currentSession => _currentSession;
  Map<String, dynamic>? get currentQuestion => _currentQuestion;
  QuestionnaireResults? get results => _results;
  String get errorMessage => _errorMessage;
  bool get hasSession => _currentSession != null;
  bool get isCompleted => _currentSession?.estado == 'completado';
  int get preguntasRespondidas => _currentSession?.respuestas.length ?? 0;

  Future<bool> startNewSession() async {
    try {
      print('🔄 Iniciando nueva sesión...');
      print('🌐 URL: ${ApiConstants.baseUrl}/session/start');
      
      _status = QuestionnaireStatus.loading;
      _errorMessage = '';
      notifyListeners();

      final uri = Uri.parse('${ApiConstants.baseUrl}/session/start');
      print('📍 URI parseado: $uri');

      print('🧪 Probando conectividad...');
      try {
        final healthUrl = '${ApiConstants.baseUrl.replaceAll('/session/start', '')}/health';
        final testResponse = await http.get(
          Uri.parse(healthUrl),
          headers: {'Content-Type': 'application/json'},
        ).timeout(const Duration(seconds: 5));
        
        print('✅ Health check: ${testResponse.statusCode}');
        print('📄 Health response: ${testResponse.body}');
      } catch (e) {
        print('❌ Health check falló: $e');
        throw Exception('No se puede conectar al servidor. Verifica que esté corriendo en ${ApiConstants.baseUrl}');
      }

      print('📤 Enviando POST a /session/start...');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'metadata': {'client': 'flutter_app'}}),
      ).timeout(const Duration(seconds: 10));

      print('📥 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sessionId = data['session_id'];
        print('🎯 Session ID obtenido: $sessionId');

        _currentSession = QuestionnaireSession.initial(sessionId);
        await _localStorage.saveSession(_currentSession!);
        
        print('💾 Sesión guardada localmente');
        print('🔄 Cargando primera pregunta...');
        
        await _loadNextQuestion();

        _status = QuestionnaireStatus.loaded;
        print('✅ Nueva sesión iniciada exitosamente');
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
      await _loadNextQuestion();

      _status = QuestionnaireStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error restaurando sesión: $e');
      _status = QuestionnaireStatus.error;
      _errorMessage = 'Error al restaurar sesión: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> loadSession(String sessionId) async {
    try {
      print('📂 Cargando sesión: $sessionId');
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
      print('❌ Error cargando sesión: $e');
      _status = QuestionnaireStatus.error;
      _errorMessage = 'Error al cargar sesión: $e';
      notifyListeners();
      return false;
    }
  }

  List<String> _convertOptionsToList(dynamic opciones) {
    if (opciones is Map<String, dynamic>) {
      return opciones.entries.map((entry) {
        return '${entry.key}) ${entry.value}';
      }).toList();
    } else if (opciones is List) {
      return opciones.map((e) => e.toString()).toList();
    } else {
      print('⚠️ Formato de opciones no reconocido: $opciones');
      return ['Error al cargar opciones'];
    }
  }

  Future<void> _loadNextQuestion() async {
    if (_currentSession == null) {
      print('⚠️ No hay sesión activa para cargar pregunta');
      return;
    }

    try {
      print('❓ Cargando siguiente pregunta...');
      final url = '${ApiConstants.baseUrl}/session/${_currentSession!.sessionId}/next-question';
      print('🌐 URL: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      print('📥 Next question response: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Verificar si el cuestionario está completo usando session_status
        if (data['session_status'] == 'completed') {
          print('🏁 Cuestionario completo - session_status: completed');
          _currentQuestion = null;
          await _completeQuestionnaire();
        } else {
          final preguntaRaw = data['pregunta'];
          final metadata = data['metadata'] ?? {};
          
          print('🔍 Pregunta raw: $preguntaRaw');
          print('🔍 Opciones raw: ${preguntaRaw['opciones']}');
          
          final opcionesConvertidas = _convertOptionsToList(preguntaRaw['opciones']);
          print('✅ Opciones convertidas: $opcionesConvertidas');
          
          _currentQuestion = {
            'pregunta': {
              'id': preguntaRaw['id'],
              'texto': preguntaRaw['texto'],
              'opciones': opcionesConvertidas
            },
            'progreso': metadata['progreso'] ?? {
              'porcentaje_estimado': 0.0,
              'fase_actual': 'fase1'
            }
          };
          
          print('✅ Pregunta cargada: ${preguntaRaw['id']}');
        }
      } else {
        throw Exception('Error al cargar pregunta: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error en _loadNextQuestion: $e');
      _errorMessage = 'Error al cargar pregunta: $e';
      rethrow;
    }
  }

  Future<bool> submitAnswer(String preguntaId, String respuesta) async {
    if (_currentSession == null) {
      _errorMessage = 'No hay sesión activa';
      return false;
    }

    try {
      print('📝 Enviando respuesta: $preguntaId = $respuesta');
      _status = QuestionnaireStatus.loading;
      notifyListeners();

      final url = '${ApiConstants.baseUrl}/session/${_currentSession!.sessionId}/answer';
      print('🌐 URL: $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'pregunta_id': preguntaId,
          'respuesta': respuesta,
        }),
      ).timeout(const Duration(seconds: 10));

      print('📥 Submit answer response: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final preguntaTexto = _currentQuestion?['pregunta']?['texto'] ?? '';

        // Actualizar sesión local
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
          // No cambiar estado aquí, se determinará en next-question
        );

        if (_autoSaveEnabled) {
          await _localStorage.saveSession(_currentSession!);
        }

        // Verificar si puede finalizar o debe continuar
        final puedeFinalizarAhora = data['puede_finalizar'] ?? false;
        final debeContinuar = data['debe_continuar'] ?? true;
        
        print('🎯 Puede finalizar: $puedeFinalizarAhora');
        print('🎯 Debe continuar: $debeContinuar');

        if (!debeContinuar || puedeFinalizarAhora) {
          print('🏁 Completando cuestionario...');
          await _completeQuestionnaire();
        } else {
          print('➡️ Cargando siguiente pregunta...');
          await _loadNextQuestion();
        }

        _status = QuestionnaireStatus.loaded;
        notifyListeners();
        return true;
      } else {
        throw Exception('Error al enviar respuesta: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error en submitAnswer: $e');
      _status = QuestionnaireStatus.error;
      _errorMessage = 'Error al enviar respuesta: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> _completeQuestionnaire() async {
    if (_currentSession == null) return;

    try {
      print('🏆 Completando cuestionario...');
      final url = '${ApiConstants.baseUrl}/session/${_currentSession!.sessionId}/prediction';
      print('🌐 URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      print('📥 Prediction response: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        final recomendacionesRaw = data['recomendaciones'] as List;
        final top3Recomendaciones = recomendacionesRaw.take(3).toList();
        
        _results = QuestionnaireResults.fromJson({
          ...data,
          'session_id': _currentSession!.sessionId,
          'fecha_evaluacion': DateTime.now().toIso8601String(),
          'recomendaciones': top3Recomendaciones,
        });

        _currentSession = _currentSession!.copyWith(
          estado: 'completado',
          timestampFin: DateTime.now(),
        );

        await _localStorage.saveSession(_currentSession!);
        await _localStorage.saveResults(_results!);

        _status = QuestionnaireStatus.completed;
        print('✅ Cuestionario completado exitosamente');
        notifyListeners();
      } else {
        throw Exception('Error al obtener resultados: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error en _completeQuestionnaire: $e');
      _errorMessage = 'Error al completar cuestionario: $e';
      rethrow;
    }
  }

  Future<bool> loadResults(String sessionId) async {
    try {
      _status = QuestionnaireStatus.loading;
      notifyListeners();

      final localResults = await _localStorage.getResults(sessionId);

      if (localResults != null) {
        _results = localResults;
        _status = QuestionnaireStatus.completed;
        notifyListeners();
        return true;
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/session/$sessionId/prediction'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        final recomendacionesRaw = data['recomendaciones'] as List;
        final top3Recomendaciones = recomendacionesRaw.take(3).toList();
        
        _results = QuestionnaireResults.fromJson({
          ...data,
          'session_id': sessionId,
          'fecha_evaluacion': DateTime.now().toIso8601String(),
          'recomendaciones': top3Recomendaciones,
        });

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

  Future<bool> saveCurrentSession() async {
    if (_currentSession == null) return false;

    try {
      return await _localStorage.saveSession(_currentSession!);
    } catch (e) {
      print('❌ Error al guardar sesión: $e');
      return false;
    }
  }

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

  void reset() {
    _currentSession = null;
    _currentQuestion = null;
    _results = null;
    _status = QuestionnaireStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }

  void setAutoSave(bool enabled) {
    _autoSaveEnabled = enabled;
    notifyListeners();
  }

  Future<List<QuestionnaireSession>> getAllSessions() async {
    return await _localStorage.getAllSessions();
  }

  Future<List<QuestionnaireSession>> getCompletedSessions() async {
    return await _localStorage.getSessionsByEstado('completado');
  }

  Future<List<QuestionnaireResults>> getAllResults() async {
    return await _localStorage.getAllResults();
  }

  Future<bool> deleteSession(String sessionId) async {
    final success = await _localStorage.deleteSession(sessionId);
    if (success && _currentSession?.sessionId == sessionId) {
      reset();
    }
    return success;
  }

  Future<Map<String, dynamic>> getStatistics() async {
    return await _localStorage.getStatistics();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}