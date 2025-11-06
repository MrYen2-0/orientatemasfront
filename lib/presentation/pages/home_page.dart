import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'notifications_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'explore_careers_page.dart';
import 'testimonials_page.dart';
import 'universities_page.dart';
import 'preparation_guide_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasCompletedEvaluation = true; // Cambiar a true para ver resultados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primary600,
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Text(
                  'O+',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'ORIENTA+',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.primary600,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                color: AppColors.gray900,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error600,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de bienvenida
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary50,
                    AppColors.white,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido, Usuario',
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Descubre tu carrera ideal',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),

            // Card principal
            Padding(
              padding: const EdgeInsets.all(16),
              child: _hasCompletedEvaluation
                  ? _buildCompletedEvaluationCard()
                  : _buildStartEvaluationCard(),
            ),

            // Sección "Tus Resultados" (NUEVO)
            if (_hasCompletedEvaluation) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Tus Resultados Vocacionales',
                      style: AppTextStyles.h3,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // TODO: Ver todos los resultados
                      },
                      child: Text(
                        'Ver todo',
                        style: TextStyle(color: AppColors.primary600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Gráfica de compatibilidad
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCompatibilityChart(),
              ),

              const SizedBox(height: 16),

              // Top 3 carreras recomendadas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildTopCareers(),
              ),

              const SizedBox(height: 24),
            ],

            // Sección "Recursos útiles" (ACTUALIZADO - FUNCIONAL)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Recursos Útiles',
                style: AppTextStyles.h3,
              ),
            ),
            const SizedBox(height: 16),

            _buildResourceCard(
              'Testimonios de egresados',
              'Lee experiencias reales de profesionales',
              Icons.school,
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const TestimonialsPage(),
                  ),
                );
              },
            ),
            _buildResourceCard(
              'Universidades recomendadas',
              'Explora opciones en tu estado',
              Icons.apartment,
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const UniversitiesPage(),
                  ),
                );
              },
            ),
            _buildResourceCard(
              'Guía de preparación',
              'Tips para elegir tu carrera perfecta',
              Icons.lightbulb_outline,
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PreparationGuidePage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary600,
        unselectedItemColor: AppColors.gray400,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ExploreCareersPage(),
                ),
              );
              break;
            case 2:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ProfilePage(),
                ),
              );
              break;
            case 3:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }

  Widget _buildStartEvaluationCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.primary600, width: 2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
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
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    size: 32,
                    color: AppColors.primary600,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Evaluación Vocacional',
                        style: AppTextStyles.h4,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Descubre tu carrera ideal',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Iniciar evaluación
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Comenzar Evaluación'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedEvaluationCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary600, AppColors.primary700],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary600.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.white,
                  size: 28,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Evaluación Completada',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Tienes 5 carreras altamente compatibles',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Ver resultados completos
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.primary600,
                ),
                child: const Text('Ver Resultados Completos'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NUEVO: Gráfica de compatibilidad
  Widget _buildCompatibilityChart() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: AppColors.primary600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Tu Perfil Vocacional',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Áreas de interés
          _buildSkillBar('Tecnología', 0.92, AppColors.primary600),
          _buildSkillBar('Ciencias', 0.78, AppColors.secondary600),
          _buildSkillBar('Negocios', 0.65, AppColors.accent600),
          _buildSkillBar('Humanidades', 0.45, AppColors.warning600),
          _buildSkillBar('Artes', 0.38, AppColors.error600),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.success600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tu perfil muestra alta compatibilidad con carreras tecnológicas',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillBar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(value * 100).toInt()}%',
                style: AppTextStyles.bodySmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: AppColors.gray200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  // NUEVO: Top 3 carreras
  Widget _buildTopCareers() {
    final careers = [
      {
        'name': 'Ingeniería en Software',
        'compatibility': 92,
        'icon': Icons.computer,
        'color': AppColors.primary600,
      },
      {
        'name': 'Ciencia de Datos',
        'compatibility': 88,
        'icon': Icons.analytics,
        'color': AppColors.secondary600,
      },
      {
        'name': 'Ingeniería en Sistemas',
        'compatibility': 85,
        'icon': Icons.developer_board,
        'color': AppColors.accent600,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: AppColors.warning600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Top 3 Carreras Recomendadas',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ...careers.asMap().entries.map((entry) {
            final index = entry.key;
            final career = entry.value;
            return _buildCareerRankItem(
              index + 1,
              career['name'] as String,
              career['compatibility'] as int,
              career['icon'] as IconData,
              career['color'] as Color,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCareerRankItem(
      int rank,
      String name,
      int compatibility,
      IconData icon,
      Color color,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$compatibility% de compatibilidad',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.gray400,
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(
      String title,
      String subtitle,
      IconData icon,
      VoidCallback onTap,
      ) {
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
          child: Icon(icon, color: AppColors.primary600),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.gray600,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.gray400,
        ),
        onTap: onTap,
      ),
    );
  }
}