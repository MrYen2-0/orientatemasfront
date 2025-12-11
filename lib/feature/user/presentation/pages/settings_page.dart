import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('Configuración', style: textTheme.titleLarge),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Centro de ayuda',
              onTap: () => context.push('/help-center'),
            ),
            _buildMenuItem(
              icon: Icons.chat_bubble_outline,
              title: 'Contactar al soporte',
              onTap: () => context.push('/contact-support'),
            ),
            _buildMenuItem(
              icon: Icons.bug_report_outlined,
              title: 'Reportar un problema',
              onTap: () => context.push('/report-problem'),
            ),
            const SizedBox(height: 16),
            Container(
              height: 8, 
              color: colorScheme.surfaceVariant.withOpacity(0.3),
            ),
            _buildMenuItem(
              icon: Icons.article_outlined,
              title: 'Términos y Condiciones',
              onTap: () => context.push('/terms-conditions'),
            ),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'Información de la app',
              onTap: () => context.push('/app-info'),
            ),
            _buildMenuItem(
              icon: Icons.code_outlined,
              title: 'Versión 1.0.0',
              subtitle: 'Última actualización: 20/10/2025',
              onTap: null,
              showArrow: false,
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar Sesión'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
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

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    VoidCallback? onTap,
    bool showArrow = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.surface,
      child: ListTile(
        leading: Icon(icon, color: colorScheme.onSurfaceVariant, size: 24),
        title: Text(
          title,
          style: textTheme.bodyMedium?.copyWith(
            color: titleColor ?? colorScheme.onSurface,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        trailing: showArrow
            ? Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              )
            : null,
        onTap: onTap,
        enabled: onTap != null,
      ),
    );
  }

  void _handleLogout() {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              context.pop();
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
            },
            child: Text(
              'Cerrar sesión',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}