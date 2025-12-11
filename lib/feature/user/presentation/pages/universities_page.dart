import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('Universidades Recomendadas', style: textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selecciona tu estado', style: textTheme.labelLarge),
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
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: colorScheme.shadow.withOpacity(0.04),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: university.type == 'Pública'
                      ? colorScheme.primaryContainer
                      : colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school,
                  color: university.type == 'Pública'
                      ? colorScheme.primary
                      : colorScheme.secondary,
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
                            ? colorScheme.primaryContainer
                            : colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        university.type,
                        style: textTheme.bodySmall?.copyWith(
                          color: university.type == 'Pública'
                              ? colorScheme.primary
                              : colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      university.name,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.visible, 
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildInfoChip(Icons.location_on, university.location, colorScheme),
              _buildInfoChip(Icons.star, '${university.rating}', colorScheme, isRating: true),
              _buildInfoChip(Icons.people, university.students, colorScheme),
            ],
          ),

          const SizedBox(height: 16),

          Text('Programas destacados:', style: textTheme.bodySmall),
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
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  program,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.attach_money, size: 16, color: Colors.green.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Colegiatura: ${university.tuition}',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.green.shade700,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.verified, size: 16, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Acreditación: ${university.accreditation}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Información de ${university.name}'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
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

Widget _buildInfoChip(IconData icon, String text, ColorScheme colorScheme, {bool isRating = false}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon, 
        size: 16, 
        color: isRating ? Colors.orange.shade600 : colorScheme.onSurfaceVariant
      ),
      const SizedBox(width: 4),
      Flexible(
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isRating 
              ? colorScheme.onSurface 
              : colorScheme.onSurfaceVariant,
            fontWeight: isRating ? FontWeight.w600 : FontWeight.normal,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
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