import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
        title: Text('Mi perfil', style: AppTextStyles.h4),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: AppColors.gray900),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con avatar
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary100, AppColors.white],
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary600,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 4),
                    ),
                    child: const Center(
                      child: Text(
                        'CJ',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Nombre
                  Text(
                    'Nombre del usuario*',
                    style: AppTextStyles.h3,
                  ),

                  const SizedBox(height: 4),

                  // Email
                  Text(
                    'Correo del usuario',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Evaluación vocacional
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mi evaluación vocacional',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Estado de evaluación
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.success600,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Evaluación completa',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.gray700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Botón ver resultados
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navegar a resultados
                      },
                      child: const Text('Ver resultados'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Información personal
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información personal',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildInfoItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Fecha de nacimiento',
                    value: '15 / 05 / 2006',
                  ),

                  _buildInfoItem(
                    icon: Icons.phone_outlined,
                    label: 'Teléfono',
                    value: '961 123 4567',
                  ),

                  _buildInfoItem(
                    icon: Icons.school_outlined,
                    label: 'Nivel de preparatoria',
                    value: '5° Semestre',
                  ),

                  _buildInfoItem(
                    icon: Icons.location_on_outlined,
                    label: 'Estado',
                    value: 'Chiapas',
                    showDivider: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Botón Editar Perfil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Navegar a editar perfil
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar Perfil'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.gray400, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.gray900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: 16),
          const Divider(color: AppColors.gray200),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                    (route) => false,
              );
            },
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(color: AppColors.error600),
            ),
          ),
        ],
      ),
    );
  }
}