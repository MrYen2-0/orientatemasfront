class Evaluation {
  final String id;
  final String userId;
  final Map<String, double> scores;
  final List<String> topCareers;
  final DateTime completedAt;
  final bool isCompleted;
  final int totalQuestions;
  final int answeredQuestions;

  Evaluation({
    required this.id,
    required this.userId,
    required this.scores,
    required this.topCareers,
    required this.completedAt,
    this.isCompleted = false,
    this.totalQuestions = 0,
    this.answeredQuestions = 0,
  });

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      id: json['id'] as String,
      userId: json['userId'] as String,
      scores: Map<String, double>.from(json['scores'] as Map),
      topCareers: (json['topCareers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      completedAt: DateTime.parse(json['completedAt'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      answeredQuestions: json['answeredQuestions'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'scores': scores,
      'topCareers': topCareers,
      'completedAt': completedAt.toIso8601String(),
      'isCompleted': isCompleted,
      'totalQuestions': totalQuestions,
      'answeredQuestions': answeredQuestions,
    };
  }

  Evaluation copyWith({
    String? id,
    String? userId,
    Map<String, double>? scores,
    List<String>? topCareers,
    DateTime? completedAt,
    bool? isCompleted,
    int? totalQuestions,
    int? answeredQuestions,
  }) {
    return Evaluation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      scores: scores ?? this.scores,
      topCareers: topCareers ?? this.topCareers,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      answeredQuestions: answeredQuestions ?? this.answeredQuestions,
    );
  }

  double get highestScore {
    if (scores.isEmpty) return 0.0;
    return scores.values.reduce((a, b) => a > b ? a : b);
  }

  String get topCategory {
    if (scores.isEmpty) return '';
    return scores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  double get progress {
    if (totalQuestions == 0) return 0.0;
    return answeredQuestions / totalQuestions;
  }

  List<MapEntry<String, double>> get sortedScores {
    final entries = scores.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }
}

class EvaluationQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String category;
  final int weight;

  EvaluationQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.category,
    this.weight = 1,
  });

  factory EvaluationQuestion.fromJson(Map<String, dynamic> json) {
    return EvaluationQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      category: json['category'] as String,
      weight: json['weight'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'category': category,
      'weight': weight,
    };
  }
}