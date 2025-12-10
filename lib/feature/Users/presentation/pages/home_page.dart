import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/questionnaire_provider.dart';
import '../providers/auth_provider.dart';
import 'notifications_page.dart';
//import 'profile_page.dart';
import 'settings_page.dart';
import 'explore_careers_page.dart';
import 'universities_page.dart';
import 'preparation_guide_page.dart';
import 'questionnaire_page.dart';
import 'questionnaire_results_page.dart';

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
      
      // Mostrar loading
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
          Navigator.pop(context); // Cerrar loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al iniciar evaluación: ${provider.errorMessage}'),
              backgroundColor: AppColors.error600,
            ),
          );
          return;
        }
      }

      Navigator.pop(context); // Cerrar loading

      if (mounted) {
        print('🎯 Navegando a QuestionnaireePage...');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const QuestionnairePage(),
          ),
        );
        print('✅ Navegación ejecutada');
      }
    } catch (e) {
      Navigator.pop(context); // Cerrar loading si está abierto
      print('❌ Error en _startEvaluation: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error600,
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

    if (user != null && user.isTutor && !user.isRegistrationComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/student-register');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary600, width: 1.5),
              ),
              child: const Center(
                child: Text(
                  'O+',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'ORIENTATE+',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.primary600,
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary50, AppColors.white],
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido, ${user?.name ?? 'Usuario'}',
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Descubre tu carrera ideal',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.gray600,
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
                child: Row(
                  children: [
                    Text(
                      'Tus Resultados Vocacionales',
                      style: AppTextStyles.h3,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        final sessions = await questionnaireProvider
                            .getCompletedSessions();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${sessions.length} evaluaciones completadas',
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Ver todo',
                        style: TextStyle(color: AppColors.primary600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCompatibilityChart(questionnaireProvider),
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
              child: Text('Recursos Útiles', style: AppTextStyles.h3),
            ),
            const SizedBox(height: 16),

            _buildResourceCard(
              'Universidades recomendadas',
              'Explora opciones en tu estado',
              Icons.apartment,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const UniversitiesPage()),
                );
              },
            ),
            _buildResourceCard(
              'Guía de preparación',
              'Tips para elegir tu carrera perfecta',
              Icons.lightbulb_outline,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PreparationGuidePage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary600,
        unselectedItemColor: AppColors.gray400,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ExploreCareersPage()),
              );
              break;
            case 2:
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.primary600, width: 2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
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
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    size: 32,
                    color: AppColors.primary600,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Evaluación Vocacional', style: AppTextStyles.h4),
                      const SizedBox(height: 4),
                      Text(
                        'Descubre tu carrera ideal',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray600,
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
                onPressed: _startEvaluation, // Usar función separada
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

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary600, AppColors.primary700],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary600.withOpacity(0.3),
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
            const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.white, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Evaluación Completada',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Tienes $carrerasCount carreras altamente compatibles',
              style: const TextStyle(fontSize: 14, color: AppColors.white),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuestionnaireResultsPage(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.primary600,
                ),
                child: const Text('Ver Resultados Completos'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompatibilityChart(QuestionnaireProvider provider) {
    final metadata = provider.results?.metadata ?? {};
    final areaDetectada = metadata['area_detectada'] ?? 'Tecnología';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: AppColors.primary600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Tu Perfil Vocacional',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildSkillBar('Tecnología', 0.92, AppColors.primary600),
          _buildSkillBar('Ciencias', 0.78, AppColors.secondary600),
          _buildSkillBar('Negocios', 0.65, AppColors.accent600),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.success600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tu perfil muestra alta compatibilidad con carreras de $areaDetectada',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success700,
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

  Widget _buildSkillBar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(value * 100).toInt()}%',
                style: AppTextStyles.bodySmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: AppColors.gray200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCareers(QuestionnaireProvider provider) {
    final recomendaciones = provider.results?.recomendaciones ?? [];

    if (recomendaciones.isEmpty) {
      return const SizedBox.shrink();
    }

    final top3 = recomendaciones.take(3).toList();
    final icons = [Icons.computer, Icons.analytics, Icons.developer_board];
    final colors = [
      AppColors.primary600,
      AppColors.secondary600,
      AppColors.accent600,
    ];

    return Container(
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: AppColors.warning600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Top 3 Carreras Recomendadas',
                style: AppTextStyles.bodyLarge.copyWith(
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
              colors[index % colors.length],
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
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$compatibility% de compatibilidad',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.gray400),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary600),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray600),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.gray400),
        onTap: onTap,
      ),
    );
  }
}