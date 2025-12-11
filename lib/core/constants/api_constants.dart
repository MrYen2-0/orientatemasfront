class ApiConstants {
  static const String baseUrl = 'https://api-gateway-w3zd.onrender.com';

  static const String habitsEndpoint = baseUrl;

  static const String loginEndpoint = '$baseUrl/api/auth/login';
  static const String registerAdultEndpoint = '$baseUrl/api/auth/register/student/adult';
  static const String registerTutorEndpoint = '$baseUrl/api/auth/register/tutor';
  static const String registerMinorEndpoint = '$baseUrl/api/auth/register/student/minor';

  static const String sessionStartEndpoint = '$baseUrl/api/questionnaire/session/start';
  static const String sessionNextQuestionEndpoint = '$baseUrl/api/questionnaire/session';
  static const String sessionAnswerEndpoint = '$baseUrl/api/questionnaire/session';
  static const String sessionFinishEndpoint = '$baseUrl/api/questionnaire/session';
  static const String healthCheckEndpoint = '$baseUrl/api/health';
  static const String questionnaireHealthEndpoint = '$baseUrl/api/questionnaire/health';
  static const String systemStatsEndpoint = '$baseUrl/api/system/stats';
  static const String demoEndpoint = '$baseUrl/api/questionnaire/demo';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 90);
  static const Duration sendTimeout = Duration(seconds: 30);

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> get headers => defaultHeaders;

  static const bool enableDebugLogging = true;
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  static String getSessionNextQuestionUrl(String sessionId) => 
    '$sessionNextQuestionEndpoint/$sessionId/next-question';
  
  static String getSessionAnswerUrl(String sessionId) => 
    '$sessionAnswerEndpoint/$sessionId/answer';
  
  static String getSessionFinishUrl(String sessionId) => 
    '$sessionFinishEndpoint/$sessionId/finish';
}