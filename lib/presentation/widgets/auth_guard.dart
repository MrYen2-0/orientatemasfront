import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../pages/login_page.dart';
import '../pages/student_register_page.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Si no está autenticado, mostrar login
        if (!authProvider.isAuthenticated) {
          return const LoginPage();
        }

        final user = authProvider.user;

        // Si es tutor y no ha completado el registro del menor
        if (user != null && user.isTutor && !user.isRegistrationComplete) {
          return const StudentRegisterPage();
        }

        // Usuario completo, mostrar la página solicitada
        return child;
      },
    );
  }
}