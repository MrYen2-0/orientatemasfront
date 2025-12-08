import 'package:flutter/foundation.dart';
import '../../domain/entities/career.dart'; // AGREGAR ESTA LÍNEA

class CareerProvider extends ChangeNotifier {
  List<Career> _allCareers = [];
  List<Career> _filteredCareers = [];
  List<Career> _savedCareers = [];
  String _selectedCategory = 'Todas';
  String _searchQuery = '';
  bool _isLoading = false;

  // Getters
  List<Career> get allCareers => _allCareers;
  List<Career> get filteredCareers => _filteredCareers;
  List<Career> get savedCareers => _savedCareers;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  // Top carreras
  List<Career> get topCareers {
    final sorted = List<Career>.from(_allCareers)
      ..sort((a, b) => b.compatibilityScore.compareTo(a.compatibilityScore));
    return sorted.take(3).toList();
  }

  // Categorías disponibles
  List<String> get categories {
    final cats = _allCareers.map((c) => c.category).toSet().toList();
    return ['Todas', ...cats];
  }

  // Métodos...
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void searchCareers(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredCareers = _allCareers.where((career) {
      final matchesCategory =
          _selectedCategory == 'Todas' || career.category == _selectedCategory;
      final matchesSearch = career.name
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
          career.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          career.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          career.skills.any((skill) =>
              skill.toLowerCase().contains(_searchQuery.toLowerCase()));

      return matchesCategory && matchesSearch;
    }).toList();
    notifyListeners();
  }

  // Inicializar con datos mock
  Future<void> loadCareers() async {
    _isLoading = true;
    notifyListeners();

    // Simular delay de carga
    await Future.delayed(const Duration(seconds: 1));

    _allCareers = [
      Career(
        id: '1',
        name: 'Ingeniería en Sistemas Computacionales',
        description: 'Diseña y desarrolla sistemas de software',
        category: 'Tecnología',
        skills: ['Programación', 'Lógica', 'Resolución de problemas'],
        compatibilityScore: 92,
      ),
      Career(
        id: '2',
        name: 'Medicina General',
        description: 'Diagnostica y trata enfermedades',
        category: 'Salud',
        skills: ['Empatía', 'Conocimiento científico', 'Trabajo bajo presión'],
        compatibilityScore: 88,
      ),
      Career(
        id: '3',
        name: 'Administración de Empresas',
        description: 'Gestiona recursos organizacionales',
        category: 'Negocios',
        skills: ['Liderazgo', 'Toma de decisiones', 'Análisis'],
        compatibilityScore: 85,
      ),
      Career(
        id: '4',
        name: 'Ciencia de Datos',
        description: 'Analiza grandes volúmenes de datos',
        category: 'Tecnología',
        skills: ['Estadística', 'Programación', 'Machine Learning'],
        compatibilityScore: 78,
      ),
      Career(
        id: '5',
        name: 'Ingeniería Industrial',
        description: 'Optimiza procesos productivos',
        category: 'Ingenierías',
        skills: ['Optimización', 'Gestión', 'Análisis de procesos'],
        compatibilityScore: 65,
      ),
    ];

    _filteredCareers = _allCareers;
    _isLoading = false;
    notifyListeners();
  }

  // Guardar/quitar carrera
  void toggleSaveCareer(String careerId) {
    final index = _allCareers.indexWhere((c) => c.id == careerId);
    if (index != -1) {
      final career = _allCareers[index];
      _allCareers[index] = career.copyWith(isSaved: !career.isSaved);

      if (_allCareers[index].isSaved) {
        _savedCareers.add(_allCareers[index]);
      } else {
        _savedCareers.removeWhere((c) => c.id == careerId);
      }

      _applyFilters();
    }
  }

  // Verificar si está guardada
  bool isCareerSaved(String careerId) {
    return _savedCareers.any((c) => c.id == careerId);
  }

  // Obtener carrera por ID
  Career? getCareerById(String id) {
    try {
      return _allCareers.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obtener carreras por categoría
  List<Career> getCareersByCategory(String category) {
    if (category == 'Todas') return _allCareers;
    return _allCareers.where((c) => c.category == category).toList();
  }
}