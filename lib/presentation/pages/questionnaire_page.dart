import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
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

  // Función que genera orden consistente basado en ID de pregunta
  List<String> _getShuffledOptions(List<String> opciones, String preguntaId) {
    final List<String> opcionesCopia = List.from(opciones);
    
    // Usar el hash del ID como semilla para generar siempre el mismo orden
    final seed = preguntaId.hashCode;
    final random = Random(seed);
    
    // Algoritmo Fisher-Yates con semilla fija
    for (int i = opcionesCopia.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = opcionesCopia[i];
      opcionesCopia[i] = opcionesCopia[j];
      opcionesCopia[j] = temp;
    }
    
    return opcionesCopia;
  }

  // Función para convertir texto seleccionado de vuelta a letra para el backend
  String _convertTextToLetter(String selectedText) {
    final question = context.read<QuestionnaireProvider>().currentQuestion?['pregunta'];
    final opcionesRaw = question?['opciones'];
    
    if (opcionesRaw is List) {
      final opciones = opcionesRaw.map((e) => e.toString()).toList();
      for (int i = 0; i < opciones.length; i++) {
        String textoLimpio = opciones[i];
        if (opciones[i].contains(') ')) {
          textoLimpio = opciones[i].split(') ').last;
        }
        if (textoLimpio == selectedText) {
          return String.fromCharCode(65 + i); // Devolver A, B, C, D...
        }
      }
    }
    
    return 'A'; // Fallback
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

    // Convertir el texto de vuelta a letra para el backend
    String respuestaParaBackend = _convertTextToLetter(_selectedAnswer!);
    
    final success = await provider.submitAnswer(preguntaId, respuestaParaBackend);

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
      backgroundColor: const Color(0xFFF9FAFB), // gray50
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF), // white
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)), // gray900
          onPressed: () => _confirmExit(context),
        ),
        title: const Text(
          'Test Vocacional',
          style: TextStyle(
            color: Color(0xFF111827), // gray900
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF111827)), // gray900
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
            ElevatedButton.icon(
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
    final progreso = provider.currentQuestion!['progreso'] ?? {};
    
    // Extraer información del progreso
    final preguntaActual = provider.preguntasRespondidas + 1; // Pregunta actual
    final totalRespuestas = provider.preguntasRespondidas;
    final porcentajeEstimado = (progreso['porcentaje_estimado'] ?? 0.0).toDouble();
    final faseActual = progreso['fase_actual'] ?? 'fase1';

    print('🎯 Debug progreso:');
    print('   - Pregunta actual: $preguntaActual');
    print('   - Total respuestas: $totalRespuestas');
    print('   - Porcentaje: $porcentajeEstimado');
    print('   - Fase: $faseActual');

    return Column(
      children: [
        // Barra de progreso superior
        Container(
          color: const Color(0xFFFFFFFF), // white
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Barra de progreso
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: porcentajeEstimado / 100.0,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE5E7EB), // gray200
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF2563EB), // primary600
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Información del progreso centrada
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pregunta $preguntaActual · ${porcentajeEstimado.toStringAsFixed(1)}% completado',
                    style: const TextStyle(
                      color: Color(0xFF1E40AF), // primary700
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              
              // Estimación de preguntas restantes
              const SizedBox(height: 8),
              Text(
                'Estimado: 100-120 preguntas total',
                style: const TextStyle(
                  color: Color(0xFF6B7280), // gray500
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // Contenido principal
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                _buildQuestionCard(question),
                const SizedBox(height: 24),
                _buildAnswerOptions(question),
                const SizedBox(height: 24),
                _buildSubmitButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getFaseTexto(String fase) {
    switch (fase) {
      case 'fase1':
        return 'Exploración general';
      case 'fase2':
        return 'Profundizando';
      default:
        return 'En progreso';
    }
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF), // white
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)), // gray200
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
                  color: const Color(0xFFDBEAFE), // primary100
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  question['id'] ?? '',
                  style: const TextStyle(
                    color: Color(0xFF1E40AF), // primary700
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            question['texto'] ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: Color(0xFF111827), // gray900
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions(Map<String, dynamic> question) {
    final opcionesRaw = question['opciones'];
    List<String> opciones = [];

    if (opcionesRaw is List) {
      opciones = opcionesRaw.map((e) => e.toString()).toList();
    } else if (opcionesRaw is String) {
      try {
        final parsed = json.decode(opcionesRaw);
        if (parsed is List) {
          opciones = parsed.map((e) => e.toString()).toList();
        }
      } catch (e) {
        print('Error parseando opciones: $e');
      }
    }

    // Orden fijo basado en el ID de la pregunta
    final preguntaId = question['id'] ?? '';
    opciones = _getShuffledOptions(opciones, preguntaId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: opciones.asMap().entries.map((entry) {
        final index = entry.key;
        final opcionTexto = entry.value;
        
        String textoLimpio = opcionTexto;
        if (opcionTexto.contains(') ')) {
          textoLimpio = opcionTexto.split(') ').last;
        }
        
        final isSelected = _selectedAnswer == textoLimpio;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedAnswer = textoLimpio;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFDBEAFE) // primary100
                    : const Color(0xFFFFFFFF), // white
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2563EB) // primary600
                      : const Color(0xFFD1D5DB), // gray300
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF2563EB) // primary600
                            : const Color(0xFF9CA3AF), // gray400
                        width: 2,
                      ),
                      color: isSelected
                          ? const Color(0xFF2563EB) // primary600
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Color(0xFFFFFFFF), // white
                            size: 14,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      textoLimpio,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF1E40AF) // primary700
                            : const Color(0xFF111827), // gray900
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _selectedAnswer != null ? _submitAnswer : null,
        icon: const Icon(Icons.arrow_forward),
        label: const Text('Siguiente'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB), // primary600
          foregroundColor: const Color(0xFFFFFFFF), // white
          disabledBackgroundColor: const Color(0xFFD1D5DB), // gray300
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
          ElevatedButton(
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