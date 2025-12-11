import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

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
        title: Text(
          'Términos y Condiciones',
          style: textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Última actualización: Noviembre 2025',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Bienvenido a Orientate+',
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Al acceder y utilizar el Sistema Profesional de Orientación Vocacional Orientate+, usted acepta estar sujeto a los siguientes términos y condiciones de uso.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),
            Divider(color: colorScheme.outline.withOpacity(0.2)),
            const SizedBox(height: 24),

            _buildSection(
              context,
              '1. Aceptación de los Términos',
              'Al registrarse y utilizar Orientate+, usted acepta cumplir con estos términos y condiciones, así como con nuestra política de privacidad. Si no está de acuerdo con alguno de estos términos, no debe utilizar nuestro servicio.',
            ),

            _buildSection(
              context,
              '2. Uso del Servicio',
              'Orientate+ es un sistema de orientación vocacional diseñado para ayudar a estudiantes de preparatoria a identificar carreras profesionales acordes a sus aptitudes e intereses.\n\nUsted se compromete a:\n• Proporcionar información verídica y actualizada\n• Utilizar el servicio de manera responsable\n• No compartir su cuenta con terceros\n• No manipular o alterar los resultados de las evaluaciones',
            ),

            _buildSection(
              context,
              '3. Evaluaciones y Resultados',
              'Las evaluaciones vocacionales proporcionadas son herramientas de orientación basadas en algoritmos y no sustituyen la asesoría profesional personalizada. Los resultados son indicativos y no garantizan el éxito en una carrera específica.\n\nLos resultados se basan en:\n• Cuestionarios de aptitudes\n• Análisis de intereses\n• Perfiles vocacionales\n• Datos estadísticos del mercado laboral',
            ),

            _buildSection(
              context,
              '4. Privacidad y Protección de Datos',
              'Nos comprometemos a proteger su información personal de acuerdo con la legislación mexicana vigente (LFPDPPP) y regulaciones internacionales aplicables.\n\nRecopilamos:\n• Datos personales básicos (nombre, correo, semestre)\n• Respuestas a evaluaciones\n• Preferencias de carrera\n• Datos de uso del sistema\n\nNo compartimos su información con terceros sin su consentimiento explícito.',
            ),

            _buildSection(
              context,
              '5. Propiedad Intelectual',
              'Todo el contenido de Orientate+, incluyendo textos, gráficos, logos, algoritmos y software, es propiedad exclusiva de Orientate+ y está protegido por las leyes de propiedad intelectual.\n\nQueda prohibido:\n• Copiar o reproducir el contenido sin autorización\n• Realizar ingeniería inversa del software\n• Utilizar el sistema con fines comerciales sin licencia',
            ),

            _buildSection(
              context,
              '6. Responsabilidades del Usuario',
              'El usuario es responsable de:\n• Mantener la confidencialidad de su contraseña\n• Todas las actividades realizadas bajo su cuenta\n• Responder honestamente a las evaluaciones\n• Notificar cualquier uso no autorizado de su cuenta',
            ),

            _buildSection(
              context,
              '7. Limitación de Responsabilidad',
              'Orientate+ no se hace responsable por:\n• Decisiones académicas o profesionales basadas únicamente en nuestras recomendaciones\n• Interrupciones del servicio por mantenimiento o causas técnicas\n• Pérdida de datos debido a problemas técnicos del usuario\n• Contenido de sitios web de terceros enlazados',
            ),

            _buildSection(
              context,
              '8. Modificaciones del Servicio',
              'Nos reservamos el derecho de:\n• Modificar o actualizar estos términos en cualquier momento\n• Agregar o eliminar funcionalidades del servicio\n• Suspender temporalmente el servicio por mantenimiento\n• Cancelar cuentas que violen estos términos',
            ),

            _buildSection(
              context,
              '9. Terminación de Cuenta',
              'Usted puede solicitar la eliminación de su cuenta en cualquier momento desde la configuración. Al eliminar su cuenta:\n• Se borrarán permanentemente todos sus datos personales\n• Perderá acceso a sus resultados y evaluaciones\n• Esta acción es irreversible',
            ),

            _buildSection(
              context,
              '10. Ley Aplicable',
              'Estos términos se rigen por las leyes de los Estados Unidos Mexicanos. Cualquier disputa se resolverá en los tribunales competentes de México.',
            ),

            const SizedBox(height: 24),
            Divider(color: colorScheme.outline.withOpacity(0.2)),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.contact_support_outlined,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Contacto',
                        style: textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Para preguntas sobre estos términos o el uso del servicio, contáctenos en:',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildContactItem(context, Icons.email, 'soporte@orientaplus.com'),
                  _buildContactItem(context, Icons.language, 'www.orientaplus.com'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('He Leído y Acepto'),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}