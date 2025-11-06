import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_button.dart';
import '../settings/settings_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../explore/explore_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _hasCompletedEvaluation = false; // Cambiar según estado real

  void _onNavBarTap(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);

    // Navegar según el índice
    switch (index) {
      case 0:
      // Ya estamos en Home
        break;
      case 1:
      // Explorar
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ExploreScreen()),
        );
        break;
      case 2:
      // Perfil
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
      case 3:
      // Configuración
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.gray900),
          onPressed: () {
            // TODO: Abrir drawer
          },
        ),
        title: Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'O+',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary600,
              ),
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                color: AppColors.gray900,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              // Badge de notificación
              Positioned(
                right: 8,
                top: 8,
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
                    '¡Hola, Christian! 👋',
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '¿Listo para descubrir tu carrera ideal?',
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

            // Sección "Explorar"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Explorar carreras',
                style: AppTextStyles.h3,
              ),
            ),
            const SizedBox(height: 16),

            // Grid de categorías
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.0,
                children: [
                  _buildCategoryCard(
                    'Ingenierías',
                    Icons.construction,
                    AppColors.primary600,
                    '12 carreras',
                  ),
                  _buildCategoryCard(
                    'Ciencias de la Salud',
                    Icons.medical_services,
                    AppColors.error600,
                    '8 carreras',
                  ),
                  _buildCategoryCard(
                    'Ciencias Sociales',
                    Icons.people,
                    AppColors.secondary600,
                    '10 carreras',
                  ),
                  _buildCategoryCard(
                    'Ciencias Exactas',
                    Icons.science,
                    AppColors.accent600,
                    '6 carreras',
                  ),
                  _buildCategoryCard(
                    'Artes y Diseño',
                    Icons.palette,
                    AppColors.warning600,
                    '7 carreras',
                  ),
                  _buildCategoryCard(
                    'Humanidades',
                    Icons.menu_book,
                    AppColors.gray700,
                    '9 carreras',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sección "Recursos"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Recursos útiles',
                style: AppTextStyles.h3,
              ),
            ),
            const SizedBox(height: 16),

            _buildResourceCard(
              'Testimonios de egresados',
              'Lee experiencias reales',
              Icons.school,
            ),
            _buildResourceCard(
              'Universidades recomendadas',
              'Explora opciones en tu estado',
              Icons.apartment,
            ),
            _buildResourceCard(
              'Guía de preparación',
              'Tips para elegir carrera',
              Icons.lightbulb_outline,
            ),

            const SizedBox(height: 80), // Espacio para bottom nav
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
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
        child: Row(
          children: [
            // Ilustración placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.assignment,
                size: 40,
                color: AppColors.primary600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comienza tu evaluación vocacional',
                    style: AppTextStyles.h4,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.gray500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Tiempo estimado: 10-15 minutos',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navegar a cuestionario
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                      ),
                      child: const Text('Iniciar cuestionario'),
                    ),
                  ),
                ],
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
        color: AppColors.secondary50,
        border: Border.all(color: AppColors.success600),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                size: 48,
                color: AppColors.success600,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evaluación completada',
                      style: AppTextStyles.h4,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColors.gray500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Realizada el 18 de octubre, 2025',
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
          // Preview top 3
          _buildCareerPreview('1. Ingeniería Industrial', '94%'),
          _buildCareerPreview('2. Psicología', '89%'),
          _buildCareerPreview('3. Medicina', '85%'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Ver resultados
                  },
                  child: const Text('Ver resultados'),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  // TODO: Repetir evaluación
                },
                icon: const Icon(Icons.refresh),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.primary600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCareerPreview(String career, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check, size: 16, color: AppColors.success600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              career,
              style: AppTextStyles.bodySmall,
            ),
          ),
          Text(
            percentage,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      String title,
      IconData icon,
      Color color,
      String count,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Navegar a explorar categoría
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ExploreScreen()),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  count,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResourceCard(String title, String subtitle, IconData icon) {
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
        onTap: () {
          // TODO: Navegar a recurso
        },
      ),
    );
  }
}