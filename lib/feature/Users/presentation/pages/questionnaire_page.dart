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
    
   print('DEBUG - progreso completo: $progreso');
  print('DEBUG - keys disponibles: ${progreso.keys}');
  
  final preguntaActual = provider.preguntasRespondidas + 1;
  final porcentajeEstimado = (progreso['porcentaje_estimado'] ?? 0.0).toDouble();
  
  print('DEBUG - porcentajeEstimado: $porcentajeEstimado');
  print('DEBUG - preguntaActual: $preguntaActual');

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
                    'Pregunta $preguntaActual',
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
          const SizedBox(height: 5),
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
  List<MapEntry<String, String>> opciones = [];

  if (opcionesRaw is Map) {
    opciones = opcionesRaw.entries
        .map((e) => MapEntry(e.key.toString(), e.value.toString()))
        .toList();
  } else if (opcionesRaw is List) {
    for (int i = 0; i < opcionesRaw.length; i++) {
      final letra = String.fromCharCode(65 + i);
      opciones.add(MapEntry(letra, opcionesRaw[i].toString()));
    }
  } else if (opcionesRaw is String) {
    try {
      final parsed = json.decode(opcionesRaw);
      if (parsed is Map) {
        opciones = parsed.entries
            .map((e) => MapEntry(e.key.toString(), e.value.toString()))
            .toList();
      }
    } catch (e) {
      print('Error parseando opciones: $e');
    }
  }

  if (opciones.isEmpty) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Error: No se pudieron cargar las opciones de respuesta',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  final preguntaId = question['id'] ?? '';
  final seed = preguntaId.hashCode;
  final random = Random(seed);
  opciones.shuffle(random);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: opciones.map((entry) {
      final letra = entry.key;
      final texto = entry.value;
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
                  ? const Color(0xFFDBEAFE)
                  : const Color(0xFFFFFFFF),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFD1D5DB),
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
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF9CA3AF),
                      width: 2,
                    ),
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Color(0xFFFFFFFF),
                          size: 14,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    texto,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF1E40AF)
                          : const Color(0xFF111827),
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