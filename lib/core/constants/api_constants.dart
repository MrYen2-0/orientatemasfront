class ApiConstants {
  static const String baseUrl = 'http://192.168.1.96:4000';
  
  static const String authBaseUrl = '$baseUrl/api/auth';
  static const String loginEndpoint = '$authBaseUrl/login';
  static const String registerAdultEndpoint = '$authBaseUrl/register/adult';
  static const String registerTutorEndpoint = '$authBaseUrl/register/tutor';
  
  static const String questionnaireBaseUrl = '$baseUrl/api/v1/questionnaire';
  static const String startSessionEndpoint = '$questionnaireBaseUrl/session/start';
  static const String questionnaireHealthEndpoint = '$questionnaireBaseUrl/health';
  
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> authHeaders(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}