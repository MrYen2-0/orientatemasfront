import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import '../../feature/Users/presentation/providers/auth_provider.dart';
import '../../feature/Users/presentation/pages/splash_page.dart';
import '../../feature/Users/presentation/pages/login_page.dart';
import '../../feature/Users/presentation/pages/register_adult_page.dart';
import '../../feature/Users/presentation/pages/tutor_register_page.dart';
import '../../feature/Users/presentation/pages/student_register_page.dart';
import '../../feature/Users/presentation/pages/home_page.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: AppRoutes.splashPath,
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final hasTutorId = authProvider.tutorId != null;
        final currentLocation = state.uri.path;

        if (currentLocation == AppRoutes.splashPath) {
          return null;
        }

        if (hasTutorId && !isAuthenticated) {
          if (currentLocation != AppRoutes.studentRegisterPath) {
            return AppRoutes.studentRegisterPath;
          }
          return null;
        }

        if (!isAuthenticated) {
          final publicRoutes = [
            AppRoutes.loginPath,
            AppRoutes.registerPath,
            AppRoutes.tutorRegisterPath,
          ];
          
          if (!publicRoutes.contains(currentLocation)) {
            return AppRoutes.loginPath;
          }
          return null;
        }

        if (isAuthenticated && (currentLocation == AppRoutes.loginPath || 
                                 currentLocation == AppRoutes.registerPath ||
                                 currentLocation == AppRoutes.tutorRegisterPath ||
                                 currentLocation == AppRoutes.studentRegisterPath)) {
          return AppRoutes.homePath;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.splashPath,
          name: AppRoutes.splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: AppRoutes.loginPath,
          name: AppRoutes.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.registerPath,
          name: AppRoutes.register,
          builder: (context, state) => const RegisterAdultPage(),
        ),
        GoRoute(
          path: AppRoutes.tutorRegisterPath,
          name: AppRoutes.tutorRegister,
          builder: (context, state) => const RegisterTutorPage(),
        ),
        GoRoute(
          path: AppRoutes.studentRegisterPath,
          name: AppRoutes.studentRegister,
          builder: (context, state) => const RegisterMinorPage(),
        ),
        GoRoute(
          path: AppRoutes.homePath,
          name: AppRoutes.home,
          builder: (context, state) => const HomePage(),
        ),
      ],
    );
  }
}