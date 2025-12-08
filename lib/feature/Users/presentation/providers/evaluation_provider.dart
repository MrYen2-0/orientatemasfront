import 'package:flutter/foundation.dart';
import '../../data/models/evaluation_model.dart';

class EvaluationProvider with ChangeNotifier {
  Evaluation? _currentEvaluation;
  List<EvaluationQuestion> _questions = [];
  Map<String, String> _answers = {};
  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  Evaluation? get currentEvaluation => _currentEvaluation;
  List<EvaluationQuestion> get questions => _questions;
  Map<String, String> get answers => _answers;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isCompleted => _currentEvaluation?.isCompleted ?? false;
  bool get hasEvaluation => _currentEvaluation != null;

  double get progress {
    if (_questions.isEmpty) return 0.0;
    return _answers.length / _questions.length;
  }

  EvaluationQuestion? get currentQuestion {
    if (_currentQuestionIndex >= 0 && _currentQuestionIndex < _questions.length) {
      return _questions[_currentQuestionIndex];
    }
    return null;
  }

  bool get canGoNext => _currentQuestionIndex < _questions.length - 1;
  bool get canGoPrevious => _currentQuestionIndex > 0;
  bool get canSubmit => _answers.length == _questions.length;

  // Load Questions
  Future<void> loadQuestions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      // Mock questions - En producción, cargar desde API
      _questions = [
        EvaluationQuestion(
          id: '1',
          question: '¿Disfrutas resolver problemas lógicos y matemáticos?',
          options: ['Mucho', 'Regular', 'Poco', 'Nada'],
          category: 'Tecnología',
          weight: 2,
        ),
        EvaluationQuestion(
          id: '2',
          question: '¿Te interesa ayudar a las personas con problemas de salud?',
          options: ['Mucho', 'Regular', 'Poco', 'Nada'],
          category: 'Ciencias',
          weight: 2,
        ),
        EvaluationQuestion(
          id: '3',
          question: '¿Disfrutas liderar proyectos y tomar decisiones importantes?',
          options: ['Mucho', 'Regular', 'Poco', 'Nada'],
          category: 'Negocios',
          weight: 2,
        ),
        EvaluationQuestion(
          id: '4',
          question: '¿Te gusta investigar sobre la sociedad y el comportamiento humano?',
          options: ['Mucho', 'Regular', 'Poco', 'Nada'],
          category: 'Humanidades',
          weight: 2,
        ),
        EvaluationQuestion(
          id: '5',
          question: '¿Disfrutas expresarte creativamente a través del arte?',
          options: ['Mucho', 'Regular', 'Poco', 'Nada'],
          category: 'Artes',
          weight: 2,
        ),
        EvaluationQuestion(
          id: '6',
          question: '¿Te interesa programar y desarrollar aplicaciones?',
          options: ['Mucho', 'Regular', 'Poco', 'Nada'],
          category: 'Tecnología',
          weight: 3,
        ),
        EvaluationQuestion(
          id: '7',
          question: '¿Te atrae trabajar en laboratorios e investigación científica?',
          options: ['Mucho', 'Regular', 'Poco', 'Nada'],
          category: 'Ciencias',
          weight: 2,
        ),
        EvaluationQuestion(
          id: '8',
          question: '¿Te gustaría crear y gestionar tu propio negocio?',
          options: ['Mucho', 'Regular', 'Poco', 'Nada'],
          category: 'Negocios',
          weight: 3,
        ),
        EvaluationQuestion(
          id: '9',
          question: '¿Disfrutas escribir y comunicar ideas complejas?',
          options: ['Mucho', 'Regular', 'Poco', 'Nada'],
          category: 'Humanidades',
          weight: 2,
        ),
        EvaluationQuestion(
          id: '10',
          question: '¿Te gustaría diseñar espacios, productos o experiencias visuales?',
          options: ['Mucho', 'Regular', 'Poco', 'Nada'],
          category: 'Artes',
          weight: 2,
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al cargar las preguntas';
      notifyListeners();
    }
  }

  // Answer Question
  void answerQuestion(String questionId, String answer) {
    _answers[questionId] = answer;
    notifyListeners();
  }

  // Get answer for question
  String? getAnswer(String questionId) {
    return _answers[questionId];
  }

  // Next Question
  void nextQuestion() {
    if (canGoNext) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  // Previous Question
  void previousQuestion() {
    if (canGoPrevious) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  // Go to specific question
  void goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  // Submit Evaluation
  Future<bool> submitEvaluation(String userId) async {
    if (!canSubmit) {
      _errorMessage = 'Debes responder todas las preguntas';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      // Calcular scores basado en respuestas
      final scores = _calculateScores();

      // Obtener top careers
      final topCareers = _getTopCareers(scores);

      _currentEvaluation = Evaluation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        scores: scores,
        topCareers: topCareers,
        completedAt: DateTime.now(),
        isCompleted: true,
        totalQuestions: _questions.length,
        answeredQuestions: _answers.length,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al enviar la evaluación';
      notifyListeners();
      return false;
    }
  }

  // Load User Evaluation
  Future<void> loadUserEvaluation(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      // Mock evaluation - En producción, cargar desde API
      final scores = {
        'Tecnología': 0.92,
        'Ciencias': 0.78,
        'Negocios': 0.65,
        'Humanidades': 0.45,
        'Artes': 0.38,
      };

      _currentEvaluation = Evaluation(
        id: '1',
        userId: userId,
        scores: scores,
        topCareers: ['Ingeniería en Software', 'Ciencia de Datos', 'Ingeniería en Sistemas'],
        completedAt: DateTime.now().subtract(const Duration(days: 7)),
        isCompleted: true,
        totalQuestions: 10,
        answeredQuestions: 10,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al cargar la evaluación';
      notifyListeners();
    }
  }

  // Reset Evaluation
  void resetEvaluation() {
    _currentEvaluation = null;
    _questions.clear();
    _answers.clear();
    _currentQuestionIndex = 0;
    _errorMessage = null;
    notifyListeners();
  }

  // Private: Calculate Scores
  Map<String, double> _calculateScores() {
    final categoryScores = <String, double>{};
    final categoryWeights = <String, int>{};

    for (final question in _questions) {
      final answer = _answers[question.id];
      if (answer == null) continue;

      // Convertir respuesta a puntaje (0-1)
      double score = 0.0;
      switch (answer) {
        case 'Mucho':
          score = 1.0;
          break;
        case 'Regular':
          score = 0.66;
          break;
        case 'Poco':
          score = 0.33;
          break;
        case 'Nada':
          score = 0.0;
          break;
      }

      // Aplicar peso de la pregunta
      score *= question.weight;

      // Acumular score por categoría
      categoryScores[question.category] =
          (categoryScores[question.category] ?? 0.0) + score;
      categoryWeights[question.category] =
          (categoryWeights[question.category] ?? 0) + question.weight;
    }

    // Normalizar scores (0-1)
    final normalizedScores = <String, double>{};
    for (final category in categoryScores.keys) {
      final totalWeight = categoryWeights[category] ?? 1;
      normalizedScores[category] = categoryScores[category]! / totalWeight;
    }

    return normalizedScores;
  }

  // Private: Get Top Careers
  List<String> _getTopCareers(Map<String, double> scores) {
    final sortedCategories = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Mapear categorías a carreras (mock)
    final careersByCategory = {
      'Tecnología': ['Ingeniería en Software', 'Ciencia de Datos', 'Ingeniería en Sistemas'],
      'Ciencias': ['Medicina', 'Biología', 'Química'],
      'Negocios': ['Administración de Empresas', 'Marketing', 'Contaduría'],
      'Humanidades': ['Psicología', 'Derecho', 'Comunicación'],
      'Artes': ['Diseño Gráfico', 'Arquitectura', 'Artes Visuales'],
    };

    final topCareers = <String>[];
    for (final entry in sortedCategories) {
      final careers = careersByCategory[entry.key] ?? [];
      topCareers.addAll(careers);
      if (topCareers.length >= 5) break;
    }

    return topCareers.take(5).toList();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}