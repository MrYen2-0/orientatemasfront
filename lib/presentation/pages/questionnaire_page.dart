import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/questionnaire_provider.dart';
import 'questionnaire_results_page.dart';
import 'dart:convert';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({Key? key}) : super(key: key);

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  String? _selectedAnswer;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initQuestionnaire();
    });
  }

  Future<void> _initQuestionnaire() async {
    final provider = context.read<QuestionnaireProvider>();
    final restored = await provider.restoreInProgressSession();

    if (!restored) {
      await provider.startNewSession();
    }
    if (!mounted) return;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _submitAnswer() async {
    if (_selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una respuesta'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final provider = context.read<QuestionnaireProvider>();
    final preguntaId = provider.currentQuestion?['pregunta']?['id'];

    if (preguntaId == null) return;

    final success = await provider.submitAnswer(preguntaId, _selectedAnswer!);

    if (success) {
      setState(() {
        _selectedAnswer = null;
      });

      if (provider.isCompleted && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const QuestionnaireResultsPage(),
          ),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Vocacional'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showSessionHistory(context),
            tooltip: 'Ver historial',
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _confirmExit(context),
            tooltip: 'Salir',
          ),
        ],
      ),
      body: Consumer<QuestionnaireProvider>(
        builder: (context, provider, child) {
          if (provider.status == QuestionnaireStatus.loading) {
            return _buildLoadingState();
          }

          if (provider.status == QuestionnaireStatus.error) {
            return _buildErrorState(provider.errorMessage);
          }

          if (provider.currentQuestion == null) {
            return _buildNoQuestionState();
          }

          return _buildQuestionView(provider);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Cargando pregunta...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text('Error', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _initQuestionnaire(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoQuestionState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Cuestionario completado',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Ya no hay más preguntas. Obteniendo resultados...',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionView(QuestionnaireProvider provider) {
    final question = provider.currentQuestion!['pregunta'];
    final progreso = provider.currentQuestion!['progreso'];
    final theme = Theme.of(context);

    return Column(
      children: [
        _buildProgressBar(progreso, theme),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProgressInfo(progreso, theme),
                const SizedBox(height: 24),
                _buildQuestionCard(question, theme),
                const SizedBox(height: 24),
                _buildAnswerOptions(question, theme),
                const SizedBox(height: 24),
                _buildSubmitButton(theme),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(Map<String, dynamic> progreso, ThemeData theme) {
    final porcentaje = (progreso['porcentaje'] ?? 0.0) / 100.0;

    return Column(
      children: [
        LinearProgressIndicator(
          value: porcentaje,
          minHeight: 8,
          backgroundColor: theme.colorScheme.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        ),
      ],
    );
  }

  Widget _buildProgressInfo(Map<String, dynamic> progreso, ThemeData theme) {
    final fase = progreso['fase'] ?? 'universal';
    final faseTextos = {
      'universal': 'Preguntas generales',
      'profundizacion': 'Explorando tu perfil',
      'refinamiento': 'Refinando resultados',
    };

    final faseIconos = {
      'universal': Icons.explore,
      'profundizacion': Icons.psychology,
      'refinamiento': Icons.tune,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              faseIconos[fase] ?? Icons.help_outline,
              color: theme.colorScheme.primary,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fase: ${faseTextos[fase]}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (progreso['puede_finalizar'] == true)
                    Text(
                      'Ya puedes finalizar o continuar para mayor precisión',
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question, ThemeData theme) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    question['id'] ?? '',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              question['texto'] ?? '',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(Map<String, dynamic> question, ThemeData theme) {
    // Las opciones vienen como una lista (array) desde la API
    final opcionesRaw = question['opciones'];
    List<String> opciones = [];

    if (opcionesRaw is List) {
      // Convertir la lista a List<String>
      opciones = opcionesRaw.map((e) => e.toString()).toList();
    } else if (opcionesRaw is String) {
      // Si viene como string, intentar parsearlo
      try {
        final parsed = json.decode(opcionesRaw);
        if (parsed is List) {
          opciones = parsed.map((e) => e.toString()).toList();
        }
      } catch (e) {
        print('Error parseando opciones: $e');
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: opciones.asMap().entries.map((entry) {
        final index = entry.key;
        final opcionTexto = entry.value;
        
        // Generar letra (A, B, C, D, E)
        final letra = String.fromCharCode(65 + index);
        
        // Limpiar el texto de la opción (remover "A) " si existe)
        String textoLimpio = opcionTexto;
        if (opcionTexto.contains(') ')) {
          textoLimpio = opcionTexto.split(') ').last;
        } else if (opcionTexto.startsWith(letra)) {
          textoLimpio = opcionTexto.substring(letra.length).trim();
        }
        
        final isSelected = _selectedAnswer == letra;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedAnswer = letra;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surface,
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        letra,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      textoLimpio,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: theme.colorScheme.primary),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return FilledButton.icon(
      onPressed: _selectedAnswer != null ? _submitAnswer : null,
      icon: const Icon(Icons.arrow_forward),
      label: const Text('Siguiente'),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.all(16),
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }

  void _showSessionHistory(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función próximamente')),
    );
  }

  void _confirmExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Salir del cuestionario?'),
        content: const Text(
          'Tu progreso se guardará automáticamente y podrás continuar después.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              context.read<QuestionnaireProvider>().saveCurrentSession();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }
}