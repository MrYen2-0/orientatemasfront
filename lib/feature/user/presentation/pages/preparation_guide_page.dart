import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/questionnaire_provider.dart';

class PreparationGuidePage extends StatelessWidget {
  const PreparationGuidePage({super.key});

  Future<void> _startEvaluation(BuildContext context) async {
    print('🚀 Botón "Comenzar Evaluación" presionado');
    
    try {
      final provider = context.read<QuestionnaireProvider>();
      print('📋 Provider obtenido: ${provider.runtimeType}');
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      print('🔍 Verificando sesión en progreso...');
      final restored = await provider.restoreInProgressSession();
      print('📊 Sesión restaurada: $restored');

      if (!restored) {
        print('🆕 Iniciando nueva sesión...');
        final started = await provider.startNewSession();
        print('✅ Nueva sesión iniciada: $started');
        
        if (!started) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al iniciar evaluación: ${provider.errorMessage}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          return;
        }
      }

      Navigator.pop(context);

      print('🎯 Navegando a QuestionnairePage...');
      context.push('/questionnaire');
      print('✅ Navegación ejecutada');
    } catch (e) {
      Navigator.pop(context);
      print('❌ Error en _startEvaluation: $e');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

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
        title: Text('Guía de Preparación', style: textTheme.titleLarge),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: colorScheme.onSecondary,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tips para Elegir tu Carrera Perfecta',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Una guía completa para tomar la mejor decisión',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _buildStep(
            context,
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
            colorScheme.primary,
          ),

          _buildStep(
            context,
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
            colorScheme.secondary,
          ),

          _buildStep(
            context,
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
            Colors.orange.shade600,
          ),

          _buildStep(
            context,
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
            Colors.amber.shade600,
          ),

          _buildStep(
            context,
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
            Colors.green.shade600,
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.error),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.warning_amber,
                        color: colorScheme.error,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Errores Comunes a Evitar',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildErrorItem(context, 'Elegir solo por el dinero'),
                _buildErrorItem(context, 'Seguir la presión familiar'),
                _buildErrorItem(context, 'Escoger por tus amigos'),
                _buildErrorItem(context, 'No investigar lo suficiente'),
                _buildErrorItem(context, 'Ignorar tus verdaderos intereses'),
                _buildErrorItem(context, 'Tomar la decisión a última hora'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.primary),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Recursos Adicionales',
                      style: textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildResourceItem(
                  context,
                  'Realiza nuestra evaluación vocacional completa',
                  Icons.assignment_turned_in,
                ),
                _buildResourceItem(
                  context,
                  'Lee testimonios de egresados exitosos',
                  Icons.people,
                ),
                _buildResourceItem(
                  context,
                  'Explora universidades recomendadas',
                  Icons.school,
                ),
                _buildResourceItem(
                  context,
                  'Consulta el catálogo completo de carreras',
                  Icons.library_books,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '¿Listo para descubrir tu vocación?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _startEvaluation(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.primary,
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
    BuildContext context,
    int number,
    String title,
    String description,
    List<String> points,
    IconData icon,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
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
                    style: TextStyle(
                      color: colorScheme.surface,
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
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildErrorItem(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.close,
            color: colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(BuildContext context, String text, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}