import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integradorfront/presentation/providers/questionnaire_provider.dart';
import 'package:provider/provider.dart';

// Core
import 'core/theme/app_theme.dart';

// Data - Dependency Injection
import 'data/di.dart' as di;

import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/evaluation_provider.dart';
import 'presentation/providers/career_provider.dart';
import 'presentation/providers/profile_provider.dart';
import 'presentation/providers/notification_provider.dart';

// Presentation - Pages
import 'presentation/widgets/auth_guard.dart'; // 👈 AGREGAR
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/tutor_register_page.dart';//
import 'presentation/pages/student_register_page.dart'; // 👈 AGREGAR IMPORT
// AGREGAR IMPORT

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar dependencias (GetIt)
  await di.initializeDependencies();

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
        // Auth Provider (REEMPLAZA AuthBloc)
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
        ChangeNotifierProvider(create: (_) => QuestionnaireProvider()),
      ],
      child: MaterialApp(
        title: 'Orientate+ | Sistema de Orientación Vocacional',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
        routes: {
          '/login': (_) => const LoginPage(),
          '/tutor-register': (context) => const TutorRegisterPage(),
          '/student-register': (context) => const StudentRegisterPage(), // 👈 AGREGAR RUTA
          '/home': (context) => AuthGuard(child: const HomePage()),
        },
      ),
    );
  }
}
