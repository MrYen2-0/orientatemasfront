import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Todas';

  final List<String> categories = [
    'Todas',
    'Ingenierías',
    'Salud',
    'Sociales',
    'Exactas',
    'Artes',
    'Humanidades',
  ];

  final List<CareerItem> allCareers = [
    CareerItem(
      name: 'Ingeniería Industrial',
      category: 'Ingenierías',
      description: 'Optimiza procesos, gestiona recursos y mejora sistemas productivos',
      salary: '\$15-20k',
      demand: 'Alta',
      duration: '4.5 años',
      icon: Icons.factory_outlined,
      color: AppColors.primary600,
    ),
    CareerItem(
      name: 'Psicología',
      category: 'Sociales',
      description: 'Estudia el comportamiento humano y ayuda a superar desafíos emocionales',
      salary: '\$10-18k',
      demand: 'Media-Alta',
      duration: '4 años',
      icon: Icons.psychology_outlined,
      color: AppColors.secondary600,
    ),
    CareerItem(
      name: 'Medicina',
      category: 'Salud',
      description: 'Diagnostica, trata y previene enfermedades para mejorar la salud',
      salary: '\$18-30k',
      demand: 'Muy Alta',
      duration: '6 años',
      icon: Icons.medical_services_outlined,
      color: AppColors.error600,
    ),
    CareerItem(
      name: 'Administración de Empresas',
      category: 'Sociales',
      description: 'Gestiona organizaciones y toma decisiones estratégicas',
      salary: '\$12-20k',
      demand: 'Alta',
      duration: '4 años',
      icon: Icons.business_outlined,
      color: AppColors.accent600,
    ),
    CareerItem(
      name: 'Diseño Gráfico',
      category: 'Artes',
      description: 'Crea soluciones visuales para comunicar mensajes efectivamente',
      salary: '\$8-15k',
      demand: 'Media',
      duration: '4 años',
      icon: Icons.palette_outlined,
      color: AppColors.warning600,
    ),
    CareerItem(
      name: 'Derecho',
      category: 'Humanidades',
      description: 'Defiende derechos, interpreta leyes y representa clientes',
      salary: '\$12-25k',
      demand: 'Media-Alta',
      duration: '4.5 años',
      icon: Icons.gavel_outlined,
      color: AppColors.gray700,
    ),
    CareerItem(
      name: 'Ingeniería en Sistemas',
      category: 'Ingenierías',
      description: 'Diseña y desarrolla sistemas de software y soluciones tecnológicas',
      salary: '\$16-28k',
      demand: 'Muy Alta',
      duration: '4.5 años',
      icon: Icons.computer_outlined,
      color: AppColors.primary600,
    ),
  ];

  List<CareerItem> get filteredCareers {
    List<CareerItem> filtered = allCareers;

    // Filtrar por categoría
    if (_selectedCategory != 'Todas') {
      filtered = filtered.where((c) => c.category == _selectedCategory).toList();
    }

    // Filtrar por búsqueda
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((c) {
        return c.name.toLowerCase().contains(query) ||
            c.description.toLowerCase().contains(query) ||
            c.category.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final careers = filteredCareers;

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Explorar', style: AppTextStyles.h4),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.gray900),
            onPressed: _showFiltersBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar carreras...',
                prefixIcon: const Icon(Icons.search, color: AppColors.gray400),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    setState(() => _searchController.clear());
                  },
                )
                    : null,
                filled: true,
                fillColor: AppColors.gray50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9999),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // Tabs de categorías
          Container(
            height: 56,
            color: AppColors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category);
                    },
                    backgroundColor: AppColors.white,
                    selectedColor: AppColors.primary50,
                    checkmarkColor: AppColors.primary600,
                    labelStyle: AppTextStyles.bodySmall.copyWith(
                      color: isSelected
                          ? AppColors.primary600
                          : AppColors.gray700,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary600
                          : AppColors.gray300,
                    ),
                  ),
                );
              },
            ),
          ),

          Container(height: 1, color: AppColors.gray200),

          // Contador de resultados
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            alignment: Alignment.centerLeft,
            child: Text(
              'Mostrando ${careers.length} ${careers.length == 1 ? 'carrera' : 'carreras'}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.gray600,
              ),
            ),
          ),

          // Lista de carreras
          Expanded(
            child: careers.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: careers.length,
              itemBuilder: (context, index) {
                return _buildCareerCard(careers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerCard(CareerItem career) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Navegar a detalle de carrera
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: career.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        career.icon,
                        color: career.color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            career.name,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              career.category,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.favorite_border,
                        color: AppColors.gray400,
                      ),
                      onPressed: () {
                        // TODO: Toggle favorito
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Descripción
                Text(
                  career.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.gray600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Metadata
                Row(
                  children: [
                    _buildMetadataChip(
                      Icons.attach_money,
                      career.salary,
                      AppColors.success600,
                    ),
                    const SizedBox(width: 12),
                    _buildMetadataChip(
                      Icons.trending_up,
                      career.demand,
                      _getDemandColor(career.demand),
                    ),
                    const SizedBox(width: 12),
                    _buildMetadataChip(
                      Icons.schedule,
                      career.duration,
                      AppColors.gray600,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Botón
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      // TODO: Ver más
                    },
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Ver más'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.gray600,
          ),
        ),
      ],
    );
  }

  Color _getDemandColor(String demand) {
    switch (demand) {
      case 'Muy Alta':
        return AppColors.success600;
      case 'Alta':
        return AppColors.secondary600;
      case 'Media-Alta':
        return AppColors.accent600;
      case 'Media':
        return AppColors.warning600;
      default:
        return AppColors.gray600;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: AppColors.gray300,
            ),
            const SizedBox(height: 24),
            Text(
              'No encontramos carreras',
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta con otros términos o\nexplora por categorías',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _selectedCategory = 'Todas';
                  });
                },
                child: const Text('Ver todas las carreras'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FiltersBottomSheet(),
    );
  }
}

// Modelo de datos
class CareerItem {
  final String name;
  final String category;
  final String description;
  final String salary;
  final String demand;
  final String duration;
  final IconData icon;
  final Color color;

  CareerItem({
    required this.name,
    required this.category,
    required this.description,
    required this.salary,
    required this.demand,
    required this.duration,
    required this.icon,
    required this.color,
  });
}

// Bottom Sheet de Filtros
class FiltersBottomSheet extends StatefulWidget {
  const FiltersBottomSheet({Key? key}) : super(key: key);

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  String _selectedDuration = '';
  String _selectedDifficulty = '';
  RangeValues _salaryRange = const RangeValues(5, 40);
  List<String> _selectedDemands = [];

  final List<String> durations = ['3 años', '4 años', '4.5 años', '5 años', '6+ años'];
  final List<String> difficulties = ['Baja', 'Media', 'Alta', 'Muy Alta'];
  final List<String> demands = ['Baja', 'Media', 'Alta', 'Muy Alta'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filtros', style: AppTextStyles.h3),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedDuration = '';
                      _selectedDifficulty = '';
                      _salaryRange = const RangeValues(5, 40);
                      _selectedDemands.clear();
                    });
                  },
                  child: Text(
                    'Limpiar',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.gray200),

          // Contenido scrollable
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Duración
                  Text(
                    'Duración de la carrera',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: durations.map((duration) {
                      final isSelected = _selectedDuration == duration;
                      return FilterChip(
                        label: Text(duration),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedDuration = selected ? duration : '';
                          });
                        },
                        backgroundColor: AppColors.white,
                        selectedColor: AppColors.primary50,
                        checkmarkColor: AppColors.primary600,
                        labelStyle: AppTextStyles.bodySmall.copyWith(
                          color: isSelected
                              ? AppColors.primary600
                              : AppColors.gray700,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary600
                              : AppColors.gray300,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Nivel de dificultad
                  Text(
                    'Nivel de dificultad',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: difficulties.map((difficulty) {
                      final isSelected = _selectedDifficulty == difficulty;
                      return FilterChip(
                        label: Text(difficulty),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedDifficulty = selected ? difficulty : '';
                          });
                        },
                        backgroundColor: AppColors.white,
                        selectedColor: AppColors.primary50,
                        checkmarkColor: AppColors.primary600,
                        labelStyle: AppTextStyles.bodySmall.copyWith(
                          color: isSelected
                              ? AppColors.primary600
                              : AppColors.gray700,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary600
                              : AppColors.gray300,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Rango salarial
                  Text(
                    'Salario inicial esperado',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RangeSlider(
                    values: _salaryRange,
                    min: 5,
                    max: 50,
                    divisions: 45,
                    activeColor: AppColors.primary600,
                    inactiveColor: AppColors.gray300,
                    labels: RangeLabels(
                      '\$${_salaryRange.start.round()}k',
                      '\$${_salaryRange.end.round()}k',
                    ),
                    onChanged: (values) {
                      setState(() => _salaryRange = values);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${_salaryRange.start.round()},000 MXN',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                      Text(
                        '\$${_salaryRange.end.round()},000 MXN',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Demanda laboral
                  Text(
                    'Demanda laboral',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: demands.map((demand) {
                      final isSelected = _selectedDemands.contains(demand);
                      return FilterChip(
                        label: Text(demand),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedDemands.add(demand);
                            } else {
                              _selectedDemands.remove(demand);
                            }
                          });
                        },
                        backgroundColor: AppColors.white,
                        selectedColor: AppColors.primary50,
                        checkmarkColor: AppColors.primary600,
                        labelStyle: AppTextStyles.bodySmall.copyWith(
                          color: isSelected
                              ? AppColors.primary600
                              : AppColors.gray700,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary600
                              : AppColors.gray300,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Botones
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.gray200),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 56),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Aplicar filtros
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 56),
                    ),
                    child: const Text('Aplicar filtros'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}