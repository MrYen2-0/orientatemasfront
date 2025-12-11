import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class UniversitiesPage extends StatefulWidget {
  const UniversitiesPage({super.key});

  @override
  State<UniversitiesPage> createState() => _UniversitiesPageState();
}

class _UniversitiesPageState extends State<UniversitiesPage> {
  String _selectedState = 'Chiapas';

  final Map<String, List<University>> universitiesByState = {
    'Chiapas': [
      University(
        name: 'Universidad Autónoma de Chiapas (UNACH)',
        type: 'Pública',
        location: 'Tuxtla Gutiérrez',
        rating: 4.2,
        students: '45,000+',
        programs: ['Ingeniería', 'Medicina', 'Derecho', 'Arquitectura'],
        tuition: 'Gratuita',
        accreditation: 'CIEES Nivel 1',
      ),
      University(
        name: 'Universidad de Ciencias y Artes de Chiapas (UNICACH)',
        type: 'Pública',
        location: 'Tuxtla Gutiérrez',
        rating: 4.0,
        students: '12,000+',
        programs: ['Psicología', 'Nutrición', 'Artes', 'Biología'],
        tuition: 'Gratuita',
        accreditation: 'CIEES',
      ),
      University(
        name: 'Universidad Valle del Grijalva',
        type: 'Privada',
        location: 'Tuxtla Gutiérrez',
        rating: 3.8,
        students: '8,000+',
        programs: ['Administración', 'Contaduría', 'Derecho', 'Gastronomía'],
        tuition: '\$15,000 - \$25,000 MXN/semestre',
        accreditation: 'FIMPES',
      ),
    ],
    'Ciudad de México': [
      University(
        name: 'Universidad Nacional Autónoma de México (UNAM)',
        type: 'Pública',
        location: 'Ciudad Universitaria',
        rating: 4.9,
        students: '350,000+',
        programs: ['Todas las áreas del conocimiento'],
        tuition: '\$0.20 MXN/año',
        accreditation: 'Top 100 Mundial',
      ),
      University(
        name: 'Instituto Politécnico Nacional (IPN)',
        type: 'Pública',
        location: 'Varias sedes',
        rating: 4.7,
        students: '180,000+',
        programs: ['Ingenierías', 'Ciencias', 'Medicina'],
        tuition: 'Gratuita',
        accreditation: 'CIEES Nivel 1',
      ),
      University(
        name: 'Instituto Tecnológico Autónomo de México (ITAM)',
        type: 'Privada',
        location: 'Río Hondo',
        rating: 4.8,
        students: '5,000+',
        programs: ['Economía', 'Derecho', 'Ciencias Políticas', 'Administración'],
        tuition: '\$180,000 MXN/semestre',
        accreditation: 'Top 3 México',
      ),
    ],
    'Nuevo León': [
      University(
        name: 'Universidad Autónoma de Nuevo León (UANL)',
        type: 'Pública',
        location: 'San Nicolás de los Garza',
        rating: 4.5,
        students: '200,000+',
        programs: ['Ingenierías', 'Medicina', 'Derecho', 'Arquitectura'],
        tuition: 'Gratuita - \$5,000 MXN/semestre',
        accreditation: 'CIEES Nivel 1',
      ),
      University(
        name: 'Tecnológico de Monterrey',
        type: 'Privada',
        location: 'Monterrey',
        rating: 4.8,
        students: '90,000+',
        programs: ['Ingenierías', 'Negocios', 'Medicina', 'Arquitectura'],
        tuition: '\$150,000 - \$200,000 MXN/semestre',
        accreditation: 'Top 1 México',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final universities = universitiesByState[_selectedState] ?? [];

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gray900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Universidades Recomendadas', style: AppTextStyles.h4),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Selector de estado
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selecciona tu estado', style: AppTextStyles.label),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedState,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  items: universitiesByState.keys.map((state) {
                    return DropdownMenuItem(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedState = value!);
                  },
                ),
              ],
            ),
          ),

          // Lista de universidades
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: universities.length,
              itemBuilder: (context, index) {
                return _buildUniversityCard(universities[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUniversityCard(University university) {
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: university.type == 'Pública'
                        ? AppColors.primary50
                        : AppColors.secondary50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.school,
                    color: university.type == 'Pública'
                        ? AppColors.primary600
                        : AppColors.secondary600,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: university.type == 'Pública'
                              ? AppColors.primary100
                              : AppColors.secondary100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          university.type,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: university.type == 'Pública'
                                ? AppColors.primary700
                                : AppColors.secondary700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        university.name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Ubicación y rating
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.gray500),
                const SizedBox(width: 4),
                Text(
                  university.location,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.star, size: 16, color: AppColors.warning600),
                const SizedBox(width: 4),
                Text(
                  '${university.rating}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.people, size: 16, color: AppColors.gray500),
                const SizedBox(width: 4),
                Text(
                  university.students,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Programas
            Text('Programas destacados:', style: AppTextStyles.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: university.programs.map((program) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    program,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gray700,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Información adicional
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.attach_money, size: 16, color: AppColors.success600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Colegiatura: ${university.tuition}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.success700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.verified, size: 16, color: AppColors.primary600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Acreditación: ${university.accreditation}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Botón
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Ver más información
                },
                icon: const Icon(Icons.info_outline, size: 18),
                label: const Text('Más Información'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class University {
  final String name;
  final String type;
  final String location;
  final double rating;
  final String students;
  final List<String> programs;
  final String tuition;
  final String accreditation;

  University({
    required this.name,
    required this.type,
    required this.location,
    required this.rating,
    required this.students,
    required this.programs,
    required this.tuition,
    required this.accreditation,
  });
}