import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary600,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  'O+',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'ORIENTA+',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sistema Profesional de Orientación Vocacional',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
