import 'package:dio/dio.dart';
import '../../../../../core/constants/api_constants.dart';
import '../models/prediction_response_model.dart';

class QuestionnaireService {
  final Dio dio;
  String? Function()? _getToken;

  QuestionnaireService({required this.dio, String? Function()? getToken})
    : _getToken = getToken {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.headers = ApiConstants.headers;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _getToken?.call();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  void updateTokenGetter(String? Function() getToken) {
    _getToken = getToken;
  }

  Future<String?> startSession({Map<String, dynamic>? metadata}) async {
    try {
      final response = await dio.post(
        '/api/questionnaire/session/start',
        data: {
          'metadata':
              metadata ??
              {
                'timestamp': DateTime.now().toIso8601String(),
                'source': 'flutter_app',
              },
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final sessionId =
            response.data['session_id'] ?? response.data['sessionId'];
        return sessionId;
      }

      return null;
    } on DioException catch (e) {
      print('Error iniciando sesión: ${e.message}');
      print('Response: ${e.response?.data}');
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getNextQuestion(String sessionId) async {
    try {
      final response = await dio.get(
        '/api/questionnaire/session/$sessionId/next-question',
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      }

      return null;
    } on DioException catch (e) {
      print('Error obteniendo pregunta: ${e.message}');
      print('Response: ${e.response?.data}');
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> submitAnswer(
    String sessionId,
    String preguntaId,
    String respuesta,
  ) async {
    try {
      final response = await dio.post(
        '/api/questionnaire/session/$sessionId/answer',
        data: {'pregunta_id': preguntaId, 'respuesta': respuesta},
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      }

      return null;
    } on DioException catch (e) {
      print('Error enviando respuesta: ${e.message}');
      print('Response: ${e.response?.data}');
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

Future<PredictionResponse?> getResults(String sessionId) async {
  try {
    final response = await dio.get(
      '/api/questionnaire/session/$sessionId/prediction'
    );

    if (response.statusCode == 200 && response.data != null) {
      return PredictionResponse.fromJson(response.data);
    }
    
    return null;
  } on DioException catch (e) {
    print('Error obteniendo resultados: ${e.message}');
    print('Response: ${e.response?.data}');
    return null;
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
  Future<bool> healthCheck() async {
    try {
      final response = await dio.get('/api/questionnaire/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
