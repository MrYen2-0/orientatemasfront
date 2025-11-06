import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Datos de ejemplo (reemplazar con datos reales del usuario)
  final String userName = 'Christian Jesús Chiu Valdivieso';
  final String userEmail = 'christian.chiu@email.com';
  final String userSchool = 'Preparatoria #5';
  final String userSemester = '5° Semestre';
  final String userState = 'Chiapas';
  final bool hasCompletedEvaluation = true;
  final String evaluationDate = '18 de octubre, 2025';

  final List<SavedCareer> savedCareers = [
    SavedCareer(
      name: 'Ingeniería Industrial',
      compatibility: 94,
      category: 'Ingeniería y Tecnología',
    ),
    SavedCareer(
      name: 'Psicología',
      compatibility: 89,
      category: 'Ciencias Sociales',
    ),
    SavedCareer(
      name: 'Medicina',
      compatibility: 85,
      category: 'Ciencias de la Salud',
    ),
  ];

  final List<String> strengths = [
    'Matemáticas avanzadas',
    'Pensamiento analítico',
    'Trabajo en equipo',
    'Liderazgo',
    'Resolución de problemas',
    'Comunicación efectiva',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Mi Perfil', style: AppTextStyles.h4),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.gray900),
            onPressed: () {
              // TODO: Navegar a configuración
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section - Información del usuario
            Container(
              width: double.infinity,
              color: AppColors.primary50,
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: AppColors.primary600,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white,
                            width: 4,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'CJ',
                            style: AppTextStyles.h2.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary600,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: AppColors.primary600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userName,
                    style: AppTextStyles.h3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.school_outlined,
                        size: 16,
                        color: AppColors.gray600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$userSchool • $userSemester',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Sección: Mi evaluación
            _buildSection('Mi evaluación vocacional'),
            _buildEvaluationCard(),

            // Sección: Carreras guardadas
            _buildSection('Mis carreras favoritas', badge: savedCareers.length),
            ...savedCareers.map((career) => _buildSavedCareerItem(career)),

            // Sección: Mi información
            _buildSection('Información personal'),
            _buildInfoCard(),

            // Sección: Mis fortalezas
            _buildSection('Fortalezas identificadas'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: strengths.map((strength) {
                  return _buildStrengthChip(strength);
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Sección: Mi progreso
            _buildSection('Mi actividad'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildActivityStats(),
            ),

            const SizedBox(height: 24),

            // Botón editar perfil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Editar perfil
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Editar perfil completo'),
                ),
              ),
            ),

            const SizedBox(height: 80), // Espacio para bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, {int? badge}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Row(
        children: [
          Text(title, style: AppTextStyles.h3),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge.toString(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEvaluationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: hasCompletedEvaluation
                      ? AppColors.success50
                      : AppColors.warning50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  hasCompletedEvaluation
                      ? Icons.check_circle
                      : Icons.pending_outlined,
                  color: hasCompletedEvaluation
                      ? AppColors.success600
                      : AppColors.warning600,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasCompletedEvaluation
                          ? 'Evaluación completada'
                          : 'Evaluación pendiente',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppColors.gray500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hasCompletedEvaluation
                              ? 'Realizada el $evaluationDate'
                              : 'Aún no has completado tu evaluación',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Ver resultados o iniciar evaluación
                  },
                  child: Text(
                    hasCompletedEvaluation ? 'Ver resultados' : 'Comenzar ahora',
                  ),
                ),
              ),
              if (hasCompletedEvaluation) ...[
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
                    // TODO: Repetir evaluación
                  },
                  icon: const Icon(Icons.refresh),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.gray100,
                    foregroundColor: AppColors.primary600,
                  ),
                ),
              ],
            ],
          ),
          if (hasCompletedEvaluation) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warning50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColors.warning600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Podrás repetir la evaluación el 18 de noviembre, 2025',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.gray700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSavedCareerItem(SavedCareer career) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.school_outlined,
            color: AppColors.primary600,
          ),
        ),
        title: Text(
          career.name,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${career.compatibility}% compatible',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.primary600,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.favorite,
            color: AppColors.error600,
          ),
          onPressed: () {
            // TODO: Remover de favoritos
          },
        ),
        onTap: () {
          // TODO: Ver detalle de carrera
        },
      ),
    );
  }

  Widget _buildInfoCard() {
    final List<InfoItem> items = [
      InfoItem(Icons.person_outline, 'Nombre completo', userName),
      InfoItem(Icons.calendar_today, 'Fecha de nacimiento', '15/03/2007'),
      InfoItem(Icons.mail_outline, 'Email', userEmail),
      InfoItem(Icons.phone_outlined, 'Teléfono', '+52 961 123 4567'),
      InfoItem(Icons.location_on_outlined, 'Estado', userState),
      InfoItem(Icons.school_outlined, 'Preparatoria', userSchool),
      InfoItem(Icons.book_outlined, 'Semestre', userSemester),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: items.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(item.icon, size: 24, color: AppColors.gray600),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.value,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.gray900,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.gray400,
                  size: 20,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStrengthChip(String strength) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            size: 16,
            color: AppColors.primary700,
          ),
          const SizedBox(width: 6),
          Text(
            strength,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            Icons.check_circle_outline,
            '1',
            'Evaluaciones',
            AppColors.primary600,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            Icons.explore_outlined,
            '12',
            'Carreras exploradas',
            AppColors.secondary600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String number, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            number,
            style: AppTextStyles.h2.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Modelos de datos
class SavedCareer {
  final String name;
  final int compatibility;
  final String category;

  SavedCareer({
    required this.name,
    required this.compatibility,
    required this.category,
  });
}

class InfoItem {
  final IconData icon;
  final String label;
  final String value;

  InfoItem(this.icon, this.label, this.value);
}