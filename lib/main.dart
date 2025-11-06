import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Core
import 'core/theme/app_theme.dart';

// Data - Dependency Injection
import 'data/di.dart' as di;

// Presentation - BLoCs
import 'presentation/bloc/auth/auth_bloc.dart';

// Presentation - Pages
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/home_page.dart';

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
    return BlocProvider(
      create: (_) => di.sl<AuthBloc>(),
      child: MaterialApp(
        title: 'Orienta+ | Sistema Profesional de Orientación Vocacional',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
        routes: {
          '/login': (_) => const LoginPage(),
          '/home': (_) => const HomePage(),
        },
      ),
    );
  }
}
