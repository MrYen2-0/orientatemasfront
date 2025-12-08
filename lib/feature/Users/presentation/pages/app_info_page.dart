import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gray900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Información de la App', style: AppTextStyles.h4),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Header con logo
          Container(
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary50, AppColors.white],
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary600,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary600.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'O+',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'ORIENTA+',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary600,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sistema Profesional de Orientación Vocacional',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.success600),
                  ),
                  child: Text(
                    'Versión 1.0.0',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Información general
          _buildSection(
            'Acerca de',
            'Orienta+ es una plataforma innovadora diseñada para ayudar a estudiantes de preparatoria en México a descubrir su vocación profesional mediante evaluaciones científicamente validadas y recomendaciones personalizadas.',
          ),

          _buildSection(
            'Nuestra Misión',
            'Empoderar a los jóvenes mexicanos con las herramientas necesarias para tomar decisiones informadas sobre su futuro profesional, reduciendo la deserción universitaria y aumentando la satisfacción laboral.',
          ),

          _buildSection(
            'Características Principales',
                '• Recomendaciones personalizadas de carreras\n'
                '• Información actualizada del mercado laboral\n'
                '• Perfiles de egresados y testimonios reales\n'
                '• Análisis de compatibilidad con más de 50 carreras\n'
                '• Seguimiento de tu progreso académico',
          ),

          // Información técnica
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Información Técnica', style: AppTextStyles.h4),
                  const SizedBox(height: 16),
                  _buildInfoRow('Versión', '1.0.0'),
                  _buildInfoRow('Última actualización', '20 de Octubre, 2025'),
                  _buildInfoRow('Tamaño', '45.2 MB'),
                  _buildInfoRow('Desarrollador', 'SoftCode Team'),
                  _buildInfoRow('Plataforma', 'Android, iOS, Web'),
                  _buildInfoRow('Idioma', 'Español'),
                ],
              ),
            ),
          ),

          // Contacto
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary700),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.contact_mail,
                        color: AppColors.primary600,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text('Contacto', style: AppTextStyles.h4),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildContactRow(
                    Icons.email,
                    'softcode20246@gmail.com',
                  ),
                  _buildContactRow(
                    Icons.phone,
                    '961 300 8534',
                  ),
                  _buildContactRow(
                    Icons.language,
                    'www.orientaplus.com',
                  ),
                ],
              ),
            ),
          ),

          // Créditos
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Créditos y Agradecimientos', style: AppTextStyles.h4),
                  const SizedBox(height: 16),
                  Text(
                    'Equipo de Desarrollo',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• SoftCode Development Team\n'
                        '• Diseño UI/UX por SoftCode Design\n',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gray600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Copyright
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              '© 2025 Orienta+. Todos los derechos reservados.\n'
                  'Desarrollado con ❤️ en México',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.gray700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.gray600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary600),
          const SizedBox(width: 12),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}