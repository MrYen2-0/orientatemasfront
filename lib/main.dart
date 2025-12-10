import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'feature/Users/data/di.dart' as di;
import 'feature/Users/presentation/providers/auth_provider.dart';
import 'feature/Users/presentation/providers/evaluation_provider.dart';
import 'feature/Users/presentation/providers/career_provider.dart';
import 'feature/Users/presentation/providers/profile_provider.dart';
import 'feature/Users/presentation/providers/notification_provider.dart';
import 'feature/Users/presentation/providers/questionnaire_provider.dart';
import 'myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.initializeDependencies();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.sl<AuthProvider>()..initialize(),
        ),
        ChangeNotifierProvider(create: (_) => di.sl<EvaluationProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<CareerProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProfileProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<NotificationProvider>()),
        ChangeNotifierProxyProvider<AuthProvider, QuestionnaireProvider>(
          create: (context) => QuestionnaireProvider(),
          update: (context, authProvider, previous) {
            if (previous != null) {
              previous.updateTokenGetter(
                () => authProvider.authToken,
              );
              return previous;
            }
            return QuestionnaireProvider(
              getToken: () => authProvider.authToken,
            );
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}
