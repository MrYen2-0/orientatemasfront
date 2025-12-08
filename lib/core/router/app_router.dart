import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'app_routes.dart';
import '../../feature/Users/presentation/providers/auth_provider.dart';
import '../../feature/Users/presentation/pages/splash_page.dart';
import '../../feature/Users/presentation/pages/login_page.dart';
import '../../feature/Users/presentation/pages/register_page.dart';
import '../../feature/Users/presentation/pages/tutor_register_page.dart';
import '../../feature/Users/presentation/pages/student_register_page.dart';
import '../../feature/Users/presentation/pages/home_page.dart';
import '../../feature/Users/presentation/pages/questionnaire_page.dart';
import '../../feature/Users/presentation/pages/questionnaire_results_page.dart';
import '../../feature/Users/presentation/pages/profile_page.dart';
import '../../feature/Users/presentation/pages/settings_page.dart';
import '../../feature/Users/presentation/pages/explore_careers_page.dart';
import '../../feature/Users/presentation/pages/universities_page.dart';
import '../../feature/Users/presentation/pages/preparation_guide_page.dart';
import '../../feature/Users/presentation/pages/notifications_page.dart';
import '../../feature/Users/presentation/pages/edit_profile_page.dart';
import '../../feature/Users/presentation/pages/change_password_page.dart';
import '../../feature/Users/presentation/pages/help_center_page.dart';
import '../../feature/Users/presentation/pages/contact_support_page.dart';
import '../../feature/Users/presentation/pages/report_problem_page.dart';
import '../../feature/Users/presentation/pages/app_info_page.dart';
import '../../feature/Users/presentation/pages/terms_conditions_page.dart';
import '../../feature/Users/presentation/pages/forgot_password_page.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: AppRoutes.splashPath,
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final user = authProvider.user;
        final currentLocation = state.uri.path;

        // Si estamos en splash, permitir que se muestre
        if (currentLocation == AppRoutes.splashPath) {
          return null;
        }

        // Si no está autenticado y está intentando acceder a rutas protegidas
        if (!isAuthenticated) {
          final publicRoutes = [
            AppRoutes.loginPath,
            AppRoutes.registerPath,
            AppRoutes.tutorRegisterPath,
            AppRoutes.forgotPasswordPath,
            AppRoutes.termsConditionsPath,
          ];
          
          if (!publicRoutes.contains(currentLocation)) {
            return AppRoutes.loginPath;
          }
          return null;
        }

        // Si está autenticado pero es tutor sin registro completo
        if (user != null && user.isTutor && !user.isRegistrationComplete) {
          if (currentLocation != AppRoutes.studentRegisterPath) {
            return AppRoutes.studentRegisterPath;
          }
          return null;
        }

        // Si está autenticado y está en rutas públicas, redirigir a home
        if (isAuthenticated && (currentLocation == AppRoutes.loginPath || 
                                 currentLocation == AppRoutes.registerPath ||
                                 currentLocation == AppRoutes.tutorRegisterPath)) {
          return AppRoutes.homePath;
        }

        return null;
      },
      routes: [
        // Splash
        GoRoute(
          path: AppRoutes.splashPath,
          name: AppRoutes.splash,
          builder: (context, state) => const SplashPage(),
        ),

        // Rutas públicas (autenticación)
        GoRoute(
          path: AppRoutes.loginPath,
          name: AppRoutes.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.registerPath,
          name: AppRoutes.register,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: AppRoutes.tutorRegisterPath,
          name: AppRoutes.tutorRegister,
          builder: (context, state) => const TutorRegisterPage(),
        ),
        GoRoute(
          path: AppRoutes.forgotPasswordPath,
          name: AppRoutes.forgotPassword,
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: AppRoutes.termsConditionsPath,
          name: AppRoutes.termsConditions,
          builder: (context, state) => const TermsConditionsPage(),
        ),

        // Registro de estudiante (requiere ser tutor autenticado)
        GoRoute(
          path: AppRoutes.studentRegisterPath,
          name: AppRoutes.studentRegister,
          builder: (context, state) => const StudentRegisterPage(),
        ),

        // Rutas protegidas (requieren autenticación)
        GoRoute(
          path: AppRoutes.homePath,
          name: AppRoutes.home,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoutes.questionnairiePath,
          name: AppRoutes.questionnaire,
          builder: (context, state) => const QuestionnairePage(),
        ),
        GoRoute(
          path: AppRoutes.questionnaireResultsPath,
          name: AppRoutes.questionnaireResults,
          builder: (context, state) => const QuestionnaireResultsPage(),
        ),
        GoRoute(
          path: AppRoutes.profilePath,
          name: AppRoutes.profile,
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: AppRoutes.settingsPath,
          name: AppRoutes.settings,
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: AppRoutes.exploreCareersPath,
          name: AppRoutes.exploreCareers,
          builder: (context, state) => const ExploreCareersPage(),
        ),
        GoRoute(
          path: AppRoutes.universitiesPath,
          name: AppRoutes.universities,
          builder: (context, state) => const UniversitiesPage(),
        ),
        GoRoute(
          path: AppRoutes.preparationGuidePath,
          name: AppRoutes.preparationGuide,
          builder: (context, state) => const PreparationGuidePage(),
        ),
        GoRoute(
          path: AppRoutes.notificationsPath,
          name: AppRoutes.notifications,
          builder: (context, state) => const NotificationsPage(),
        ),
        GoRoute(
          path: AppRoutes.editProfilePath,
          name: AppRoutes.editProfile,
          builder: (context, state) => const EditProfilePage(),
        ),
        GoRoute(
          path: AppRoutes.changePasswordPath,
          name: AppRoutes.changePassword,
          builder: (context, state) => const ChangePasswordPage(),
        ),
        GoRoute(
          path: AppRoutes.helpCenterPath,
          name: AppRoutes.helpCenter,
          builder: (context, state) => const HelpCenterPage(),
        ),
        GoRoute(
          path: AppRoutes.contactSupportPath,
          name: AppRoutes.contactSupport,
          builder: (context, state) => const ContactSupportPage(),
        ),
        GoRoute(
          path: AppRoutes.reportProblemPath,
          name: AppRoutes.reportProblem,
          builder: (context, state) => const ReportProblemPage(),
        ),
        GoRoute(
          path: AppRoutes.appInfoPath,
          name: AppRoutes.appInfo,
          builder: (context, state) => const AppInfoPage(),
        ),
      ],
    );
  }
}