import 'package:flutter/foundation.dart';

class ProfileProvider with ChangeNotifier {
  Map<String, dynamic> _statistics = {};
  List<String> _strengths = [];
  bool _isLoading = false;

  Map<String, dynamic> get statistics => _statistics;
  List<String> get strengths => _strengths;
  bool get isLoading => _isLoading;

  // Load Profile Statistics
  Future<void> loadStatistics(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _statistics = {
        'evaluationsCompleted': 1,
        'careersExplored': 15,
        'timeSpent': '2h 30m',
        'lastActivity': DateTime.now().subtract(const Duration(hours: 3)),
      };

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load Strengths
  Future<void> loadStrengths(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _strengths = [
        'Pensamiento analítico',
        'Resolución de problemas',
        'Creatividad',
        'Trabajo en equipo',
        'Comunicación efectiva',
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
}