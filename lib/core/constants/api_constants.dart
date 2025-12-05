class ApiConstants {
  static const String baseUrl = 'http://192.168.1.96:8000/api/v2';
  
  // Endpoints
  static const String startSession = '$baseUrl/session/start';
  static const String nextQuestion = '$baseUrl/session';
  static const String submitAnswer = '$baseUrl/session';
  static const String getPrediction = '$baseUrl/session';
  static const String health = '$baseUrl/health';
  static const String demo = '$baseUrl/demo';
}