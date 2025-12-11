import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/questionnaire_session.dart';
import '../../data/datasource/local/questionnaire_local_storage.dart';
import 'package:integradorfront/core/constants/api_constants.dart';

enum QuestionnaireStatus { initial, loading, loaded, error, completed }

class QuestionnaireProvider extends ChangeNotifier {
  final QuestionnaireLocalStorage _localStorage;
  String? Function()? _getToken;

  QuestionnaireProvider({
    QuestionnaireLocalStorage? localStorage,
    String? Function()? getToken,
  }) : _localStorage = localStorage ?? QuestionnaireLocalStorage(),
       _getToken = getToken;

  void updateTokenGetter(String? Function() getToken) {
    _getToken = getToken;
  }

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

  Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = _getToken?.call();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<bool> startNewSession() async {
    try {
      _status = QuestionnaireStatus.loading;
      _errorMessage = '';
      notifyListeners();

      final url = '${ApiConstants.baseUrl}/api/questionnaire/session/start';
      final uri = Uri.parse(url);

      final response = await http.post(
        uri,
        headers: _getHeaders(),
        body: jsonEncode({
          'metadata': {
            'timestamp': DateTime.now().toIso8601String(),
            'source': 'flutter_app',
          },
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final sessionId = data['session_id'];

        _currentSession = QuestionnaireSession.initial(sessionId);
        await _localStorage.saveSession(_currentSession!);
        await _loadNextQuestion();

        _status = QuestionnaireStatus.loaded;
        notifyListeners();
        return true;
      } else {
        throw Exception(
          'Error del servidor: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      _status = QuestionnaireStatus.error;
      _errorMessage = 'Error al iniciar cuestionario: $e';
      notifyListeners();
      return false;
    }
  }

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
      await _loadNextQuestion();

      _status = QuestionnaireStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _status = QuestionnaireStatus.error;
      _errorMessage = 'Error al restaurar sesion: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> loadSession(String sessionId) async {
    try {
      _status = QuestionnaireStatus.loading;
      notifyListeners();

      final session = await _localStorage.getSession(sessionId);

      if (session == null) {
        throw Exception('Sesion no encontrada');
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
      _errorMessage = 'Error al cargar sesion: $e';
      notifyListeners();
      return false;
    }
  }

Future<void> _loadNextQuestion() async {
  if (_currentSession == null) return;

  try {
    final url = ApiConstants.getSessionNextQuestionUrl(_currentSession!.sessionId);

    final response = await http.get(Uri.parse(url), headers: _getHeaders());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['session_status'] == 'ready_to_finish' &&
          data['pregunta'] == null) {
        _currentQuestion = null;
        await _completeQuestionnaire();
      } else {
        _currentQuestion = data;
      }
    } else {
      throw Exception(
        'Error al cargar pregunta: ${response.statusCode} - ${response.body}',
      );
    }
  } catch (e) {
    _errorMessage = 'Error al cargar pregunta: $e';
    rethrow;
  }
}

Future<bool> submitAnswer(String preguntaId, String respuesta) async {
  if (_currentSession == null) {
    _errorMessage = 'No hay sesion activa';
    return false;
  }

  try {
    _status = QuestionnaireStatus.loading;
    notifyListeners();

    final url = ApiConstants.getSessionAnswerUrl(_currentSession!.sessionId);

    final response = await http.post(
      Uri.parse(url),
      headers: _getHeaders(),
      body: jsonEncode({'pregunta_id': preguntaId, 'respuesta': respuesta}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final preguntaTexto = _currentQuestion?['pregunta']?['texto'] ?? '';

      _currentSession = _currentSession!.copyWith(
        respuestas: {..._currentSession!.respuestas, preguntaId: respuesta},
        preguntasRespondidas: [
          ..._currentSession!.preguntasRespondidas,
          QuestionResponse(
            preguntaId: preguntaId,
            preguntaTexto: preguntaTexto,
            respuesta: respuesta,
            timestamp: DateTime.now(),
          ),
        ],
        estado: data['debe_continuar'] == false
            ? 'listo_para_finalizar'
            : 'en_progreso',
      );

      if (_autoSaveEnabled) {
        await _localStorage.saveSession(_currentSession!);
      }

      if (data['debe_continuar'] == false &&
          data['puede_finalizar'] == true) {
        await _completeQuestionnaire();
      } else {
        await _loadNextQuestion();
      }

      _status = QuestionnaireStatus.loaded;
      notifyListeners();
      return true;
    } else {
      throw Exception(
        'Error al enviar respuesta: ${response.statusCode} - ${response.body}',
      );
    }
  } catch (e) {
    _status = QuestionnaireStatus.error;
    _errorMessage = 'Error al enviar respuesta: $e';
    notifyListeners();
    return false;
  }
}

Future<void> _completeQuestionnaire() async {
  if (_currentSession == null) return;

  try {
    final url = ApiConstants.getSessionFinishUrl(_currentSession!.sessionId);

    final response = await http.post(
      Uri.parse(url),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      final resultsData = {
        'session_id': data['session_id'],
        'capacidad_academica': data['capacidad_academica'],
        'rama_universitaria': data['rama_universitaria'],
        'recomendaciones': data['top_3_recomendaciones'],
        'resumen_ejecutivo': data['resumen_ejecutivo'],
        'mensaje_motivacional': data['mensaje_motivacional'],
        'total_respuestas': data['total_respuestas'],
        'fecha_evaluacion': data['timestamp'],
        'metadata': {
          'llm_disponible': data['llm_disponible'],
        },
      };
      
      _results = QuestionnaireResults.fromJson(resultsData);

      _currentSession = _currentSession!.copyWith(
        estado: 'completado',
        timestampFin: DateTime.now(),
      );

      await _localStorage.saveSession(_currentSession!);
      await _localStorage.saveResults(_results!);

      _status = QuestionnaireStatus.completed;
      notifyListeners();
    } else {
      throw Exception(
        'Error al obtener resultados: ${response.statusCode} - ${response.body}',
      );
    }
  } catch (e) {
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

      throw Exception('Resultados no encontrados');
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
}