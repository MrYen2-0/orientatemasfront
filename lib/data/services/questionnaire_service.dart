import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';

class QuestionnaireService {
  final Dio dio;

  QuestionnaireService({required this.dio}) {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.headers = ApiConstants.headers;
    
    // Interceptor para logs
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
      logPrint: (obj) => print('🌐 QUESTIONNAIRE: $obj'),
    ));
  }

  /// Verificar salud del servicio de questionnaires
  Future<bool> verifyHealth() async {
    try {
      print('🏥 Verificando salud del servicio questionnaire...');
      
      final response = await dio.get('/api/v1/questionnaire/health');
      
      if (response.statusCode == 200) {
        print('✅ Servicio questionnaire saludable');
        return true;
      }
      
      return false;
    } catch (e) {
      print('❌ Error verificando salud del servicio questionnaire: $e');
      return false;
    }
  }

  /// Iniciar sesión de cuestionario VIA GATEWAY
  Future<String?> startSession(String userId) async {
    try {
      print('🚀 Iniciando sesión de cuestionario para usuario: $userId');
      
      final response = await dio.post(
        '/api/v1/questionnaire/session/start',  // ← VIA GATEWAY
        data: {'userId': userId},
      );

      print('✅ Respuesta session/start: ${response.statusCode}');
      print('📦 Data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final sessionId = response.data['sessionId'] ?? response.data['session_id'];
        print('✅ Sesión de cuestionario iniciada: $sessionId');
        return sessionId;
      }
      
      return null;
    } catch (e) {
      print('❌ Error iniciando sesión de cuestionario: $e');
      return null;
    }
  }

  /// Obtener siguiente pregunta VIA GATEWAY
  Future<Map<String, dynamic>?> getNextQuestion(String sessionId) async {
    try {
      print('❓ Obteniendo siguiente pregunta para sesión: $sessionId');
      
      final response = await dio.get(
        '/api/v1/questionnaire/session/$sessionId/next-question'
      );

      if (response.statusCode == 200 && response.data != null) {
        print('✅ Pregunta obtenida exitosamente');
        return response.data;
      }
      
      return null;
    } catch (e) {
      print('❌ Error obteniendo siguiente pregunta: $e');
      return null;
    }
  }

  /// Enviar respuesta VIA GATEWAY
  Future<bool> submitAnswer(String sessionId, int questionId, String answer) async {
    try {
      print('📝 Enviando respuesta para sesión $sessionId, pregunta $questionId');
      
      final response = await dio.post(
        '/api/v1/questionnaire/session/$sessionId/answer',
        data: {
          'questionId': questionId,
          'answer': answer,
        },
      );

      if (response.statusCode == 200) {
        print('✅ Respuesta enviada exitosamente');
        return true;
      }
      
      return false;
    } catch (e) {
      print('❌ Error enviando respuesta: $e');
      return false;
    }
  }

  /// Obtener predicción/resultados VIA GATEWAY
  Future<Map<String, dynamic>?> getResults(String sessionId) async {
    try {
      print('📊 Obteniendo resultados para sesión: $sessionId');
      
      final response = await dio.get(
        '/api/v1/questionnaire/session/$sessionId/prediction'
      );

      if (response.statusCode == 200 && response.data != null) {
        print('✅ Resultados obtenidos exitosamente');
        return response.data;
      }
      
      return null;
    } catch (e) {
      print('❌ Error obteniendo resultados: $e');
      return null;
    }
  }
}