import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import '../../feature/user/presentation/providers/auth_provider.dart';
import '../../feature/user/presentation/pages/splash_page.dart';
import '../../feature/user/presentation/pages/login_page.dart';
import '../../feature/user/presentation/pages/register_adult_page.dart';
import '../../feature/user/presentation/pages/tutor_register_page.dart';
import '../../feature/user/presentation/pages/student_register_page.dart';
import '../../feature/user/presentation/pages/home_page.dart';
import '../../feature/user/presentation/pages/settings_page.dart';
import '../../feature/user/presentation/pages/explore_careers_page.dart';
import '../../feature/user/presentation/pages/universities_page.dart';
import '../../feature/user/presentation/pages/preparation_guide_page.dart';
import '../../feature/user/presentation/pages/questionnaire_page.dart';
import '../../feature/user/presentation/pages/terms_conditions_page.dart';
import '../../feature/user/presentation/pages/questionnaire_results_page.dart';
import '../../feature/setting/presentation/pages/help_center_page.dart';
import '../../feature/setting/presentation/pages/report_problem_page.dart';
import '../../feature/setting/presentation/pages/contact_support_page.dart';
import '../../feature/setting/presentation/pages/app_info_page.dart';

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

        if (isAuthenticated &&
            (currentLocation == AppRoutes.loginPath ||
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
          path: AppRoutes.questionnairePath,
          name: AppRoutes.questionnaire,
          builder: (context, state) => const QuestionnairePage(),
        ),
        GoRoute(
          path: AppRoutes.questionnaireResultsPath,
          name: AppRoutes.questionnaireResults,
          builder: (context, state) => const QuestionnaireResultsPage(),
        ),
        GoRoute(
          path: AppRoutes.helpCenterPath,
          name: AppRoutes.helpCenter,
          builder: (context, state) => const HelpCenterPage(),
        ),
        GoRoute(
          path: AppRoutes.reportProblemPath,
          name: AppRoutes.reportProblem,
          builder: (context, state) => const ReportProblemPage(),
        ),
        GoRoute(
          path: AppRoutes.contactSupportPath,
          name: AppRoutes.contactSupport,
          builder: (context, state) => const ContactSupportPage(),
        ),
        GoRoute(
          path: AppRoutes.appInfoPath,
          name: AppRoutes.appInfo,
          builder: (context, state) => const AppInfoPage(),
        ),
        GoRoute(
          path: AppRoutes.termsConditionsPath,
          name: AppRoutes.termsConditions,
          builder: (context, state) => const TermsConditionsPage(),
        ),
      ],
    );
  }
}
