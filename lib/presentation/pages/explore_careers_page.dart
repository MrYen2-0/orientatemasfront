import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ExploreCareersPage extends StatefulWidget {
  const ExploreCareersPage({super.key});

  @override
  State<ExploreCareersPage> createState() => _ExploreCareersPageState();
}

class _ExploreCareersPageState extends State<ExploreCareersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Todas';

  final List<String> _categories = [
    'Todas',
    'Ingenierías',
    'Salud',
    'Tecnología',
    'Negocios',
    'Artes',
  ];

  final List<CareerItem> _popularCareers = [
    CareerItem(
      name: 'Ingeniería en Sistemas Computacionales',
      category: 'Tecnología',
      description: 'Diseña, desarrolla y mantiene sistemas de software para resolver problemas complejos',
      demand: 'Muy Alta',
      salary: '\$18,000 - \$35,000 MXN',
      duration: '4-5 años',
      popularityRank: 1,
      icon: Icons.computer,
      color: AppColors.primary600,
      skills: ['Programación', 'Lógica', 'Resolución de problemas'],
      jobOpportunities: '95% de empleabilidad',
    ),
    CareerItem(
      name: 'Medicina General',
      category: 'Salud',
      description: 'Diagnostica, trata y previene enfermedades para mejorar la salud y bienestar',
      demand: 'Muy Alta',
      salary: '\$20,000 - \$50,000 MXN',
      duration: '6 años + especialidad',
      popularityRank: 2,
      icon: Icons.medical_services,
      color: AppColors.error600,
      skills: ['Empatía', 'Conocimiento científico', 'Trabajo bajo presión'],
      jobOpportunities: '98% de empleabilidad',
    ),
    CareerItem(
      name: 'Administración de Empresas',
      category: 'Negocios',
      description: 'Gestiona recursos organizacionales para alcanzar objetivos empresariales',
      demand: 'Alta',
      salary: '\$12,000 - \$30,000 MXN',
      duration: '4 años',
      popularityRank: 3,
      icon: Icons.business_center,
      color: AppColors.secondary600,
      skills: ['Liderazgo', 'Toma de decisiones', 'Análisis'],
      jobOpportunities: '88% de empleabilidad',
    ),
    CareerItem(
      name: 'Ciencia de Datos',
      category: 'Tecnología',
      description: 'Analiza grandes volúmenes de datos para extraer insights y crear modelos predictivos',
      demand: 'Muy Alta',
      salary: '\$25,000 - \$60,000 MXN',
      duration: '4 años',
      popularityRank: 4,
      icon: Icons.analytics,
      color: AppColors.accent600,
      skills: ['Estadística', 'Programación', 'Machine Learning'],
      jobOpportunities: '96% de empleabilidad',
    ),
    CareerItem(
      name: 'Ingeniería Industrial',
      category: 'Ingenierías',
      description: 'Optimiza procesos productivos y gestiona sistemas industriales complejos',
      demand: 'Alta',
      salary: '\$15,000 - \$35,000 MXN',
      duration: '4.5 años',
      popularityRank: 5,
      icon: Icons.factory,
      color: AppColors.gray700,
      skills: ['Optimización', 'Gestión', 'Análisis de procesos'],
      jobOpportunities: '90% de empleabilidad',
    ),
  ];

  List<CareerItem> get _filteredCareers {
    if (_selectedCategory == 'Todas') {
      return _popularCareers;
    }
    return _popularCareers
        .where((career) => career.category == _selectedCategory)
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gray900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Explorar Carreras', style: AppTextStyles.h4),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar carreras...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.gray50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Filtros por categoría
          Container(
            height: 50,
            color: AppColors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: AppColors.gray100,
                    selectedColor: AppColors.primary100,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primary700
                          : AppColors.gray700,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Lista de carreras
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredCareers.length,
              itemBuilder: (context, index) {
                final career = _filteredCareers[index];
                return _buildCareerCard(career);
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _showCareerDetails(career);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con icono y ranking
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.trending_up,
                                    size: 14,
                                    color: AppColors.warning700,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '#${career.popularityRank}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.warning700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                career.category,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          career.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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

              const SizedBox(height: 16),

              // Metadata
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildMetadataChip(
                    Icons.attach_money,
                    career.salary,
                    AppColors.success600,
                  ),
                  _buildMetadataChip(
                    Icons.trending_up,
                    career.demand,
                    _getDemandColor(career.demand),
                  ),
                  _buildMetadataChip(
                    Icons.schedule,
                    career.duration,
                    AppColors.gray600,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Botón
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    _showCareerDetails(career);
                  },
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Ver detalles completos'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
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
      case 'Media':
        return AppColors.warning600;
      default:
        return AppColors.gray600;
    }
  }

  void _showCareerDetails(CareerItem career) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Icono grande
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: career.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    career.icon,
                    color: career.color,
                    size: 40,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Nombre
              Text(
                career.name,
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Categoría
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: career.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    career.category,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: career.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Descripción
              Text(
                'Descripción',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 8),
              Text(
                career.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray700,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 24),

              // Información clave
              _buildDetailSection('Información Clave', [
                _buildDetailRow('Duración', career.duration),
                _buildDetailRow('Demanda Laboral', career.demand),
                _buildDetailRow('Rango Salarial', career.salary),
                _buildDetailRow('Empleabilidad', career.jobOpportunities),
              ]),

              const SizedBox(height: 24),

              // Habilidades requeridas
              Text(
                'Habilidades Requeridas',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: career.skills.map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary700),
                    ),
                    child: Text(
                      skill,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // Botón
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cerrar'),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h4,
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.gray900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Modelo de Carrera
class CareerItem {
  final String name;
  final String category;
  final String description;
  final String demand;
  final String salary;
  final String duration;
  final int popularityRank;
  final IconData icon;
  final Color color;
  final List<String> skills;
  final String jobOpportunities;

  CareerItem({
    required this.name,
    required this.category,
    required this.description,
    required this.demand,
    required this.salary,
    required this.duration,
    required this.popularityRank,
    required this.icon,
    required this.color,
    required this.skills,
    required this.jobOpportunities,
  });
}