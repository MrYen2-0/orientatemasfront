import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<FAQCategory> _categories = [
    FAQCategory(
      title: 'Sobre la evaluación vocacional',
      icon: Icons.assignment_outlined,
      color: AppColors.primary600,
      questions: [
        FAQItem(
          question: '¿Cuánto dura el cuestionario?',
          answer:
          'El cuestionario adaptativo toma entre 10-15 minutos. El sistema ajusta dinámicamente el número de preguntas según tus respuestas, mostrando solo lo relevante para tu perfil.',
        ),
        FAQItem(
          question: '¿Puedo cambiar mis respuestas?',
          answer:
          'Sí, durante el cuestionario puedes regresar y cambiar tus respuestas anteriores. Sin embargo, esto puede modificar las siguientes preguntas.',
        ),
        FAQItem(
          question: '¿Qué tan precisas son las recomendaciones?',
          answer:
          'Nuestras recomendaciones se basan en datos reales de egresados universitarios con perfiles similares al tuyo. Alcanzamos una precisión del 80-85% según estudios de validación.',
        ),
        FAQItem(
          question: '¿Qué pasa si no completo el cuestionario?',
          answer:
          'Tu progreso se guarda automáticamente cada 5 preguntas. Puedes continuar donde lo dejaste en cualquier momento dentro de los próximos 7 días.',
        ),
        FAQItem(
          question: '¿El cuestionario tiene costo?',
          answer:
          'La evaluación básica es completamente gratuita. Ofrecemos funciones premium opcionales para instituciones educativas.',
        ),
      ],
    ),
    FAQCategory(
      title: 'Sobre los resultados',
      icon: Icons.emoji_events_outlined,
      color: AppColors.success600,
      questions: [
        FAQItem(
          question: '¿Cómo se calculan las compatibilidades?',
          answer:
          'Usamos machine learning entrenado con datos de miles de egresados universitarios. El algoritmo identifica patrones entre tus respuestas y los perfiles de profesionales exitosos en cada carrera.',
        ),
        FAQItem(
          question: '¿Puedo repetir la evaluación?',
          answer:
          'Sí, puedes repetir la evaluación cada 30 días. Esto permite que el sistema capture cambios en tus intereses y aptitudes a medida que avanzas en la preparatoria.',
        ),
        FAQItem(
          question: '¿Cómo descargo mi reporte?',
          answer:
          'Desde la pantalla de resultados, toca el botón "Descargar PDF" para obtener un reporte completo con todas tus carreras recomendadas y explicaciones detalladas.',
        ),
        FAQItem(
          question: '¿Qué significa el porcentaje de compatibilidad?',
          answer:
          'Indica qué tan bien tu perfil coincide con el de profesionales exitosos en esa carrera. Un 90% significa que compartes características clave con el 90% de egresados satisfechos.',
        ),
        FAQItem(
          question: '¿Por qué no aparece la carrera que quiero?',
          answer:
          'Nuestro catálogo incluye las 50 carreras más demandadas. Si no encuentras una carrera específica, puedes sugerírnosla desde la sección de soporte.',
        ),
      ],
    ),
    FAQCategory(
      title: 'Sobre tu cuenta',
      icon: Icons.person_outline,
      color: AppColors.secondary600,
      questions: [
        FAQItem(
          question: 'No recibí el email de verificación',
          answer:
          'Revisa tu carpeta de spam. Si no lo encuentras, puedes solicitar reenvío desde la pantalla de login. Si el problema persiste, contáctanos.',
        ),
        FAQItem(
          question: 'Olvidé mi contraseña',
          answer:
          'En la pantalla de login, toca "¿Olvidaste tu contraseña?" e ingresa tu email. Recibirás un enlace para crear una nueva contraseña.',
        ),
        FAQItem(
          question: '¿Cómo cambio mi información personal?',
          answer:
          'Ve a tu perfil y toca "Editar perfil". Podrás actualizar tu nombre, email, semestre actual y otra información personal.',
        ),
        FAQItem(
          question: '¿Cómo elimino mi cuenta?',
          answer:
          'Ve a Configuración > Cuenta > Eliminar cuenta. Ten en cuenta que esta acción es permanente y todos tus datos serán eliminados.',
        ),
        FAQItem(
          question: '¿Puedo tener más de una cuenta?',
          answer:
          'Cada usuario debe tener una sola cuenta. Si necesitas realizar múltiples evaluaciones, puedes repetir la evaluación cada 30 días.',
        ),
      ],
    ),
    FAQCategory(
      title: 'Privacidad y seguridad',
      icon: Icons.shield_outlined,
      color: AppColors.primary600,
      questions: [
        FAQItem(
          question: '¿Mis datos están seguros?',
          answer:
          'Sí. Utilizamos encriptación de nivel bancario (AES-256) para proteger tu información. Cumplimos con GDPR y las leyes mexicanas de protección de datos.',
        ),
        FAQItem(
          question: '¿Comparten mi información con terceros?',
          answer:
          'Nunca compartimos tu información personal sin tu consentimiento explícito. Los datos usados para mejorar el sistema son completamente anónimos y agregados.',
        ),
        FAQItem(
          question: '¿Cómo puedo eliminar mis datos?',
          answer:
          'Ve a Configuración > Privacidad > Solicitar eliminación de datos. Procesaremos tu solicitud en un máximo de 30 días según la ley.',
        ),
        FAQItem(
          question: '¿Qué información recopilan?',
          answer:
          'Recopilamos tu nombre, email, respuestas del cuestionario y datos de uso básicos. No accedemos a tu cámara, micrófono o ubicación sin tu permiso.',
        ),
        FAQItem(
          question: '¿Puedo descargar mis datos?',
          answer:
          'Sí. Ve a Configuración > Privacidad > Descargar mis datos. Recibirás un archivo JSON o PDF con toda tu información.',
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            color: AppColors.primary50,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '¿En qué podemos ayudarte?',
                prefixIcon: const Icon(Icons.search, color: AppColors.gray400),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9999),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              onChanged: (value) {
                // TODO: Implementar búsqueda
              },
            ),
          ),

          // Lista de categorías
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return _buildCategorySection(_categories[index]);
              },
            ),
          ),

          // Footer de contacto
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                top: BorderSide(color: AppColors.gray200),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '¿No encontraste lo que buscabas?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Navegar a contactar soporte
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Contactar soporte'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(FAQCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header de categoría
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.title,
                  style: AppTextStyles.h3,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Lista de preguntas
        ...category.questions.map((question) {
          return _buildFAQItem(question);
        }).toList(),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFAQItem(FAQItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(
            item.question,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.gray900,
            ),
          ),
          iconColor: AppColors.gray400,
          collapsedIconColor: AppColors.gray400,
          children: [
            const Divider(color: AppColors.gray200),
            const SizedBox(height: 12),
            Text(
              item.answer,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.gray700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modelos de datos
class FAQCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<FAQItem> questions;

  FAQCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.questions,
  });
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}