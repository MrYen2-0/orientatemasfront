import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import 'help_center_page.dart';
import 'contact_support_page.dart';
import 'report_problem_page.dart';
import 'app_info_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;

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
        title: Text('Configuración', style: AppTextStyles.h4),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Sección: Cuenta
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'Editar información personal',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.lock_outline,
              title: 'Cambiar contraseña',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.delete_outline,
              title: 'Eliminar cuenta',
              titleColor: AppColors.error600,
              onTap: () {
                _showDeleteAccountDialog();
              },
            ),

            const SizedBox(height: 16),
            Container(height: 8, color: AppColors.gray100),

            // Sección: Notificaciones
            _buildSectionHeader('Notificaciones'),
            _buildSwitchItem(
              icon: Icons.notifications_outlined,
              title: 'Activar notificaciones',
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
              },
            ),
            _buildSwitchItem(
              icon: Icons.email_outlined,
              title: 'Notificaciones por email',
              value: _emailNotifications,
              onChanged: (value) {
                setState(() => _emailNotifications = value);
              },
            ),

            const SizedBox(height: 16),
            Container(height: 8, color: AppColors.gray100),

            // Sección: Soporte y ayuda
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Centro de ayuda',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HelpCenterPage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.chat_bubble_outline,
              title: 'Contactar al soporte',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ContactSupportPage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.bug_report_outlined,
              title: 'Reportar un problema',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ReportProblemPage()),
                );
              },
            ),

            const SizedBox(height: 16),
            Container(height: 8, color: AppColors.gray100),

            // Sección: Acerca de la app
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'Información de la app',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AppInfoPage()),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.code_outlined,
              title: 'Versión 1.0.0',
              subtitle: 'Última actualización: 20/10/2025',
              onTap: null,
              showArrow: false,
            ),

            const SizedBox(height: 32),

            // Botón Cerrar Sesión
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar Sesión'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error600,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: AppTextStyles.overline.copyWith(
          color: AppColors.gray500,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return Container(
      color: AppColors.white,
      child: ListTile(
        leading: Icon(icon, color: AppColors.gray600, size: 24),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: titleColor ?? AppColors.gray900,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.gray600,
          ),
        )
            : null,
        trailing: showArrow
            ? const Icon(
          Icons.chevron_right,
          color: AppColors.gray400,
          size: 20,
        )
            : null,
        onTap: onTap,
        enabled: onTap != null,
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      color: AppColors.white,
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.gray600, size: 24),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.gray900,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary600,
      ),
    );
  }

  void _handleLogout() {
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

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text(
          'Esta acción es permanente y no se puede deshacer. '
              'Todos tus datos serán eliminados.\n\n'
              '¿Estás seguro que deseas continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implementar eliminación de cuenta
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppColors.error600),
            ),
          ),
        ],
      ),
    );
  }
}