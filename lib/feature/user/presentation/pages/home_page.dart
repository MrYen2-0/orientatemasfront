import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/questionnaire_provider.dart';
import '../providers/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForExistingSession();
    });
  }

  Future<void> _checkForExistingSession() async {
    if (!mounted) return;

    try {
      final provider = context.read<QuestionnaireProvider>();
      final completedSessions = await provider.getCompletedSessions();
      if (completedSessions.isNotEmpty && mounted) {
        final lastSession = completedSessions.first;
        await provider.loadResults(lastSession.sessionId);
      }
    } catch (e) {
      print('Error checking existing session: $e');
    }
  }

  Future<void> _startEvaluation() async {
    print('🚀 Botón "Comenzar Evaluación" presionado');

    try {
      final provider = context.read<QuestionnaireProvider>();
      print('📋 Provider obtenido: ${provider.runtimeType}');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
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
              content: Text(
                'Error al iniciar evaluación: ${provider.errorMessage}',
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          return;
        }
      }

      Navigator.pop(context);

      if (mounted) {
        print('Navegando a QuestionnairePage...');
        context.push('/questionnaire');
        print('Navegación ejecutada');
      }
    } catch (e) {
      Navigator.pop(context);
      print('Error en _startEvaluation: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final questionnaireProvider = context.watch<QuestionnaireProvider>();
    final user = authProvider.user;
    final hasCompletedEvaluation = questionnaireProvider.isCompleted;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (user != null && user.isTutor && !user.isRegistrationComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/student-register');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colorScheme.primary, width: 1.5),
              ),
              child: Center(
                child: Text(
                  'O+',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'ORIENTATE+',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido, ${user?.name ?? 'Usuario'}',
                    style: textTheme.displayMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Descubre tu carrera ideal',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: hasCompletedEvaluation
                  ? _buildCompletedEvaluationCard(questionnaireProvider)
                  : _buildStartEvaluationCard(),
            ),

            if (hasCompletedEvaluation &&
                questionnaireProvider.results != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Tus Resultados Vocacionales',
                  style: textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildTopCareers(questionnaireProvider),
              ),

              const SizedBox(height: 24),
            ],

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Recursos Útiles', style: textTheme.headlineMedium),
            ),
            const SizedBox(height: 16),

            _buildResourceCard(
              'Universidades recomendadas',
              'Explora opciones en tu estado',
              Icons.apartment,
              () => context.push('/universities'),
            ),
            _buildResourceCard(
              'Guía de preparación',
              'Tips para elegir tu carrera perfecta',
              Icons.lightbulb_outline,
              () => context.push('/preparation-guide'),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              context.push('/explore-careers');
              break;
            case 1:
              context.push('/settings');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }

  Widget _buildStartEvaluationCard() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.primary, width: 2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.assignment_outlined,
                    size: 32,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Evaluación Vocacional',
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Descubre tu carrera ideal',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _startEvaluation,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Comenzar Evaluación'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedEvaluationCard(QuestionnaireProvider provider) {
    final carrerasCount = provider.results?.recomendaciones.length ?? 3;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: colorScheme.onPrimary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Evaluación Completada',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Tienes $carrerasCount carreras altamente compatibles',
              style: TextStyle(fontSize: 14, color: colorScheme.onPrimary),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (provider.results == null &&
                      provider.currentSession != null) {
                    await provider.loadResults(
                      provider.currentSession!.sessionId,
                    );
                  }

                  if (provider.results != null && mounted) {
                    context.push('/questionnaire-results');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.surface,
                  foregroundColor: colorScheme.primary,
                ),
                child: const Text('Ver Resultados Completos'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCareers(QuestionnaireProvider provider) {
    final recomendaciones = provider.results?.recomendaciones ?? [];

    if (recomendaciones.isEmpty) {
      return const SizedBox.shrink();
    }

    final top3 = recomendaciones.take(3).toList();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final icons = [Icons.computer, Icons.analytics, Icons.developer_board];

    return Container(
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
              const SizedBox(width: 12),
              Text(
                'Top 3 Carreras Recomendadas',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ...top3.asMap().entries.map((entry) {
            final index = entry.key;
            final carrera = entry.value;

            return _buildCareerRankItem(
              carrera.ranking,
              carrera.carrera,
              (carrera.matchScore * 100).toInt(),
              icons[index % icons.length],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCareerRankItem(
    int rank,
    String name,
    int compatibility,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: colorScheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$compatibility% de compatibilidad',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: colorScheme.primary),
        ),
        title: Text(
          title,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }
}
