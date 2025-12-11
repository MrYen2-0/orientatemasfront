import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

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
        title: Text('Centro de Ayuda', style: AppTextStyles.h4),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Header
          Container(
            color: AppColors.primary50,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.help_outline,
                  size: 60,
                  color: AppColors.primary600,
                ),
                const SizedBox(height: 16),
                Text(
                  '¿En qué podemos ayudarte?',
                  style: AppTextStyles.h3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Encuentra respuestas a las preguntas más frecuentes',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.gray600,
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
                gradient: const LinearGradient(
                  colors: [AppColors.primary600, AppColors.primary700],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.headset_mic,
                    color: AppColors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '¿No encontraste lo que buscabas?',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nuestro equipo de soporte está listo para ayudarte',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navegar a contactar soporte
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primary600,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary600, size: 24),
          ),
          title: Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.gray600,
            ),
          ),
          children: questions.map((faq) {
            return _buildFAQItem(faq);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem faq) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.gray200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.help_outline,
                size: 20,
                color: AppColors.primary600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  faq.question,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
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
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.gray600,
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