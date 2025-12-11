import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Centro de Ayuda', style: textTheme.titleLarge),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Header
          Container(
            color: colorScheme.primaryContainer,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.help_outline,
                  size: 60,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  '¿En qué podemos ayudarte?',
                  style: textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Encuentra respuestas a las preguntas más frecuentes',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Categorías de ayuda
          _buildHelpCategory(
            context,
            icon: Icons.assignment_outlined,
            title: 'Evaluación Vocacional',
            subtitle: 'Todo sobre las evaluaciones',
            questions: [
              FAQItem(
                question: '¿Cuánto tiempo toma la evaluación?',
                answer: 'La evaluación completa toma aproximadamente 20-30 minutos. Puedes pausarla y continuar después.',
              ),
              FAQItem(
                question: '¿Puedo repetir la evaluación?',
                answer: 'Sí, puedes repetir la evaluación cada 30 días para actualizar tus resultados.',
              ),
              FAQItem(
                question: '¿Qué tan precisa es la evaluación?',
                answer: 'Nuestra evaluación tiene una precisión del 85% basada en algoritmos validados y perfiles vocacionales.',
              ),
            ],
          ),

          _buildHelpCategory(
            context,
            icon: Icons.person_outline,
            title: 'Cuenta y Perfil',
            subtitle: 'Gestiona tu información',
            questions: [
              FAQItem(
                question: '¿Cómo cambio mi email?',
                answer: 'Ve a Configuración > Cuenta > Editar información personal y actualiza tu email.',
              ),
              FAQItem(
                question: '¿Cómo elimino mi cuenta?',
                answer: 'Ve a Configuración > Cuenta > Eliminar cuenta. Esta acción es permanente.',
              ),
              FAQItem(
                question: '¿Puedo recuperar mi contraseña?',
                answer: 'Sí, en la pantalla de login selecciona "¿Olvidó su contraseña?" y sigue las instrucciones.',
              ),
            ],
          ),

          _buildHelpCategory(
            context,
            icon: Icons.school_outlined,
            title: 'Carreras y Resultados',
            subtitle: 'Información sobre carreras',
            questions: [
              FAQItem(
                question: '¿Qué significa el porcentaje de compatibilidad?',
                answer: 'Indica qué tan bien tu perfil coincide con profesionales exitosos en esa carrera.',
              ),
              FAQItem(
                question: '¿Cómo descargo mi reporte?',
                answer: 'Desde la pantalla de resultados, toca "Descargar PDF" para obtener un reporte completo.',
              ),
              FAQItem(
                question: '¿Por qué no aparece mi carrera favorita?',
                answer: 'Nuestro catálogo incluye las 50 carreras más demandadas. Puedes sugerir nuevas carreras contactando soporte.',
              ),
            ],
          ),

          _buildHelpCategory(
            context,
            icon: Icons.security_outlined,
            title: 'Privacidad y Seguridad',
            subtitle: 'Protección de datos',
            questions: [
              FAQItem(
                question: '¿Mis datos están seguros?',
                answer: 'Sí. Utilizamos encriptación AES-256 y cumplimos con GDPR y leyes mexicanas de protección de datos.',
              ),
              FAQItem(
                question: '¿Comparten mi información?',
                answer: 'Nunca compartimos tu información personal sin tu consentimiento explícito.',
              ),
              FAQItem(
                question: '¿Puedo descargar mis datos?',
                answer: 'Sí, ve a Configuración > Privacidad > Descargar mis datos.',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Botón de contacto
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.headset_mic,
                    color: colorScheme.onPrimary,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '¿No encontraste lo que buscabas?',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nuestro equipo de soporte está listo para ayudarte',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.primary,
                    ),
                    child: const Text('Contactar Soporte'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHelpCategory(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required List<FAQItem> questions,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 24),
          ),
          title: Text(
            title,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          children: questions.map((faq) {
            return _buildFAQItem(context, faq);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, FAQItem faq) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.help_outline,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  faq.question,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              faq.answer,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}