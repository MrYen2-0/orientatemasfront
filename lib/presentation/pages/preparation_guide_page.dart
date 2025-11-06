import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class PreparationGuidePage extends StatelessWidget {
  const PreparationGuidePage({super.key});

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
        title: Text('Guía de Preparación', style: AppTextStyles.h4),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.secondary600, AppColors.secondary700],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.white,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tips para Elegir tu Carrera Perfecta',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Una guía completa para tomar la mejor decisión',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Pasos
          _buildStep(
            1,
            'Conócete a Ti Mismo',
            'Antes de elegir una carrera, es fundamental que te conozcas bien.',
            [
              '• Identifica tus intereses: ¿Qué te apasiona?',
              '• Reconoce tus habilidades: ¿En qué eres bueno?',
              '• Define tus valores: ¿Qué es importante para ti?',
              '• Considera tu personalidad: ¿Prefieres trabajar solo o en equipo?',
            ],
            Icons.person_search,
            AppColors.primary600,
          ),

          _buildStep(
            2,
            'Investiga las Opciones',
            'Explora diferentes carreras y sus posibilidades.',
            [
              '• Lee sobre el plan de estudios de cada carrera',
              '• Investiga el campo laboral y oportunidades',
              '• Conoce los salarios promedio',
              '• Habla con profesionales del área',
              '• Asiste a ferias universitarias',
            ],
            Icons.search,
            AppColors.secondary600,
          ),

          _buildStep(
            3,
            'Considera el Futuro',
            'Piensa en las tendencias del mercado laboral.',
            [
              '• Carreras con mayor demanda en los próximos años',
              '• Tecnologías emergentes y su impacto',
              '• Posibilidades de crecimiento profesional',
              '• Opciones de especialización o posgrado',
              '• Movilidad geográfica requerida',
            ],
            Icons.trending_up,
            AppColors.accent600,
          ),

          _buildStep(
            4,
            'Evalúa las Universidades',
            'No solo la carrera importa, también dónde la estudias.',
            [
              '• Reputación y acreditación de la institución',
              '• Calidad de los profesores',
              '• Infraestructura y recursos disponibles',
              '• Costo y opciones de becas',
              '• Ubicación y accesibilidad',
            ],
            Icons.school,
            AppColors.warning600,
          ),

          _buildStep(
            5,
            'Toma una Decisión Informada',
            'Con toda la información, es hora de decidir.',
            [
              '• Haz una lista de pros y contras',
              '• Consulta con tu familia y mentores',
              '• Confía en tu intuición',
              '• Recuerda que puedes cambiar si es necesario',
              '• Comprométete con tu elección',
            ],
            Icons.check_circle,
            AppColors.success600,
          ),

          const SizedBox(height: 24),

          // Errores comunes
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.error700),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.error50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.warning_amber,
                        color: AppColors.error600,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Errores Comunes a Evitar',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.error600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildErrorItem('Elegir solo por el dinero'),
                _buildErrorItem('Seguir la presión familiar'),
                _buildErrorItem('Escoger por tus amigos'),
                _buildErrorItem('No investigar lo suficiente'),
                _buildErrorItem('Ignorar tus verdaderos intereses'),
                _buildErrorItem('Tomar la decisión a última hora'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Recursos adicionales
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary700),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.primary600,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Recursos Adicionales',
                      style: AppTextStyles.h4,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildResourceItem(
                  'Realiza nuestra evaluación vocacional completa',
                  Icons.assignment_turned_in,
                ),
                _buildResourceItem(
                  'Lee testimonios de egresados exitosos',
                  Icons.people,
                ),
                _buildResourceItem(
                  'Explora universidades recomendadas',
                  Icons.school,
                ),
                _buildResourceItem(
                  'Consulta el catálogo completo de carreras',
                  Icons.library_books,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // CTA Final
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary600, AppColors.primary700],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  '¿Listo para descubrir tu vocación?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primary600,
                    ),
                    child: const Text('Comenzar Evaluación'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStep(
      int number,
      String title,
      String description,
      List<String> points,
      IconData icon,
      Color color,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(icon, color: color, size: 32),
            ],
          ),
          const SizedBox(height: 16),
          ...points.map((point) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                point,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.gray700,
                  height: 1.5,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildErrorItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.close,
            color: AppColors.error600,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}