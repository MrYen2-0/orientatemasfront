import 'package:flutter/material.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Información de la App', style: textTheme.titleLarge),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Header con logo
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [colorScheme.primaryContainer, colorScheme.surface],
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'O+',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'ORIENTA+',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sistema Profesional de Orientación Vocacional',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
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
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colorScheme.secondary),
                  ),
                  child: Text(
                    'Versión 1.0.0',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSecondaryContainer,
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
            context,
            'Acerca de',
            'Orienta+ es una plataforma innovadora diseñada para ayudar a estudiantes de preparatoria en México a descubrir su vocación profesional mediante evaluaciones científicamente validadas y recomendaciones personalizadas.',
          ),

          _buildSection(
            context,
            'Nuestra Misión',
            'Empoderar a los jóvenes mexicanos con las herramientas necesarias para tomar decisiones informadas sobre su futuro profesional, reduciendo la deserción universitaria y aumentando la satisfacción laboral.',
          ),

          _buildSection(
            context,
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
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Información Técnica', style: textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _buildInfoRow(context, 'Versión', '1.0.0'),
                  _buildInfoRow(context, 'Última actualización', '20 de Octubre, 2025'),
                  _buildInfoRow(context, 'Tamaño', '45.2 MB'),
                  _buildInfoRow(context, 'Desarrollador', 'SoftCode Team'),
                  _buildInfoRow(context, 'Plataforma', 'Android, iOS, Web'),
                  _buildInfoRow(context, 'Idioma', 'Español'),
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
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.primary),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.contact_mail,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text('Contacto', style: textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildContactRow(
                    context,
                    Icons.email,
                    'softcode20246@gmail.com',
                  ),
                  _buildContactRow(
                    context,
                    Icons.phone,
                    '961 300 8534',
                  ),
                  _buildContactRow(
                    context,
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
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Créditos y Agradecimientos', style: textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Text(
                    'Equipo de Desarrollo',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• SoftCode Development Team\n'
                        '• Diseño UI/UX por SoftCode Design\n',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(BuildContext context, IconData icon, String text) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            text,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}