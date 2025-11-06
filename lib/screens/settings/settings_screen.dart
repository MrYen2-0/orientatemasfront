import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _reminderNotifications = false;
  bool _newTestimonials = true;
  bool _shareDataForResearch = false;

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
                // Sección: Cuenta
                _buildSectionHeader('CUENTA'),
            _buildSettingItem(
              icon: Icons.person_outline,
              title: 'Editar información personal',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.lock_outline,
              title: 'Cambiar contraseña',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.mail_outline,
              title: 'Cambiar email',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.delete_outline,
              title: 'Eliminar cuenta',
              titleColor: AppColors.error600,
              onTap: () {
                _showDeleteAccountDialog();
              },
            ),

            const SizedBox(height: 8),
            Container(height: 8, color: AppColors.gray100),

            // Sección: Notificaciones
            _buildSectionHeader('NOTIFICACIONES'),
            _buildSwitchItem(
              icon: Icons.notifications_outlined,
              title: 'Notificaciones push',
              value: _pushNotifications,
              onChanged: (value) {
                setState(() => _pushNotifications = value);
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
                  _buildSwitchItem(
                    icon: Icons.alarm_outlined,
                    title: 'Recordatorios de evaluación',
                    value: _reminderNotifications,
                    onChanged: (value) {
                      setState(() => _reminderNotifications = value);
                    },
                  ),
                  _buildSwitchItem(
                    icon: Icons.message_outlined,
                    title: 'Nuevos testimonios',
                    value: _newTestimonials,
                    onChanged: (value) {
                      setState(() => _newTestimonials = value);
                    },
                  ),

                  const SizedBox(height: 8),
                  Container(height: 8, color: AppColors.gray100),

                  // Sección: Privacidad
                  _buildSectionHeader('PRIVACIDAD Y DATOS'),
                  _buildSettingItem(
                    icon: Icons.shield_outlined,
                    title: 'Privacidad y seguridad',
                    onTap: () {},
                  ),
                  _buildSwitchItem(
                    icon: Icons.storage_outlined,
                    title: 'Compartir datos para investigación',
                    subtitle: 'Ayuda a mejorar el sistema',
                    value: _shareDataForResearch,
                    onChanged: (value) {
                      setState(() => _shareDataForResearch = value);
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.description_outlined,
                    title: 'Política de privacidad',
                    trailing: Icons.open_in_new,
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.article_outlined,
                    title: 'Términos y condiciones',
                    trailing: Icons.open_in_new,
                    onTap: () {},
                  ),

                  const SizedBox(height: 8),
                  Container(height: 8, color: AppColors.gray100),

                  // Sección: Soporte
                  _buildSectionHeader('SOPORTE Y AYUDA'),
                  _buildSettingItem(
                    icon: Icons.help_outline,
                    title: 'Centro de ayuda',
                    onTap: () {
                      // Navegar a centro de ayuda
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.chat_bubble_outline,
                    title: 'Contactar soporte',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.bug_report_outlined,
                    title: 'Reportar un problema',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.star_outline,
                    title: 'Calificar la app',
                    trailing: Icons.open_in_new,
                    onTap: () {},
                  ),

                  const SizedBox(height: 8),
                  Container(height: 8, color: AppColors.gray100),

                  // Sección: Acerca de
                  _buildSectionHeader('ACERCA DE ORIENTA+'),
                  _buildSettingItem(
                    icon: Icons.info_outline,
                    title: 'Acerca de la app',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.code_outlined,
                    title: 'Versión 1.0.0',
                    subtitle: 'Última actualización: 20/10/2025',
                    onTap: null,
                  ),
                  _buildSettingItem(
                    icon: Icons.favorite_outline,
                    title: 'Créditos y agradecimientos',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.book_outlined,
                    title: 'Licencias de código abierto',
                    onTap: () {},
                  ),

                  const SizedBox(height: 8),
                  Container(height: 8, color: AppColors.gray100),

                  // Botón cerrar sesión
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _handleLogout,
                        icon: const Icon(Icons.logout),
                        label: const Text('Cerrar sesión'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error600,
                          foregroundColor: AppColors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
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

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    IconData? trailing,
    VoidCallback? onTap,
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
        trailing: Icon(
          trailing ?? Icons.chevron_right,
          color: AppColors.gray400,
          size: 20,
        ),
        onTap: onTap,
        enabled: onTap != null,
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    String? subtitle,
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
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.gray600,
          ),
        )
            : null,
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
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidad en desarrollo'),
                ),
              );
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