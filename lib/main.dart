import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Core
import 'core/theme/app_theme.dart';

// Data - Dependency Injection
import 'feature/Users/data/di.dart' as di;

import 'feature/Users/presentation/providers/auth_provider.dart';
import 'feature/Users/presentation/providers/evaluation_provider.dart';
import 'feature/Users/presentation/providers/career_provider.dart';
import 'feature/Users/presentation/providers/profile_provider.dart';
import 'feature/Users/presentation/providers/notification_provider.dart';
import 'feature/Users/presentation/providers/questionnaire_provider.dart';

// Presentation - Pages
import 'feature/Users/presentation/widgets/auth_guard.dart';
import 'feature/Users/presentation/pages/splash_page.dart';
import 'feature/Users/presentation/pages/login_page.dart';
import 'feature/Users/presentation/pages/register_page.dart';  // ← NUEVO
import 'feature/Users/presentation/pages/home_page.dart';
import 'feature/Users/presentation/pages/tutor_register_page.dart';
import 'feature/Users/presentation/pages/student_register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar dependencias (GetIt)
  print('🚀 Inicializando dependencias...');
  await di.initializeDependencies();
  print('✅ Dependencias inicializadas');

  // Configurar orientación (solo portrait)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configurar status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const OrientaApp());
}

class OrientaApp extends StatelessWidget {
  const OrientaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider
        ChangeNotifierProvider(
          create: (_) => di.sl<AuthProvider>()..initialize(),
        ),

        // Evaluation Provider
        ChangeNotifierProvider(create: (_) => di.sl<EvaluationProvider>()),

        // Career Provider
        ChangeNotifierProvider(create: (_) => di.sl<CareerProvider>()),

        // Profile Provider
        ChangeNotifierProvider(create: (_) => di.sl<ProfileProvider>()),

        // Notification Provider
        ChangeNotifierProvider(create: (_) => di.sl<NotificationProvider>()),

        // Questionnaire Provider
        ChangeNotifierProvider(create: (_) => QuestionnaireProvider()),
      ],
      child: MaterialApp(
        title: 'Orientate+ | Sistema de Orientación Vocacional',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
        routes: {
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),  
          '/tutor-register': (context) => const TutorRegisterPage(),
          '/student-register': (context) => const StudentRegisterPage(),
          '/home': (context) => AuthGuard(child: const HomePage()),
        },
      ),
    );
  }
}