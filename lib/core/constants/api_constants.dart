class ApiConstants {
  // URL del API Gateway (NO del servicio ML directamente)
  static const String baseUrl = 'http://192.168.1.96:4000';

  // Endpoints del Gateway (ya incluyen el prefijo correcto)
  static const String habitsEndpoint = baseUrl;

  // Auth endpoints (Gateway espera /auth, NO /api/auth)
  static const String loginEndpoint = '$baseUrl/auth/login'; // ← Quitar /api/
  static const String registerAdultEndpoint =
      '$baseUrl/auth/register/adult'; // ← Quitar /api/
  static const String registerTutorEndpoint =
      '$baseUrl/auth/register/tutor'; // ← Quitar /api/

  // ML Service endpoints (prefijo /api se agrega automáticamente por el gateway)
  static const String sessionStartEndpoint = '$baseUrl/api/session/start';
  static const String healthCheckEndpoint = '$baseUrl/health';
  static const String systemStatsEndpoint = '$baseUrl/api/system/stats';
  static const String demoEndpoint = '$baseUrl/api/demo';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Headers comunes
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Getter para compatibilidad con servicios existentes
  static Map<String, String> get headers => defaultHeaders;

  // Configuración de red
  static const bool enableDebugLogging = true;
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
