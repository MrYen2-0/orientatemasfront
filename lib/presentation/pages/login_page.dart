import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _errorShown = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            // Mostrar errores si existen
            if (authProvider.errorMessage != null && !_errorShown) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(authProvider.errorMessage!),
                    backgroundColor: AppColors.error600,
                  ),
                );
                setState(() => _errorShown = true);
                authProvider.clearError();
              });
            }

            // Navegar a home si está autenticado
            if (authProvider.isAuthenticated) {
              final user = authProvider.user;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (user != null && user.isTutor && !user.isRegistrationComplete) {
                  // Si es tutor sin registro completo, ir a registro de estudiante
                  Navigator.of(context).pushReplacementNamed('/student-register');
                } else {
                  // Si registro está completo, ir al home
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              });
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),

                      // Logo
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.primary50,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.primary600,
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'O+',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      Text(
                        'Bienvenido de nuevo',
                        style: AppTextStyles.h2,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Inicia sesión para continuar',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.gray600,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Email
                      Text('Correo electrónico', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'tu@email.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Email inválido';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password
                      Text('Contraseña', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          if (value.length < 6) {
                            return 'Mínimo 6 caracteres';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Recuperar contraseña
                          },
                          child: const Text('¿Olvidaste tu contraseña?'),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Login button
                      ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _errorShown = false);

                            final success = await authProvider.login(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );

                            if (!success && mounted) {
                              // El error se muestra automáticamente por el Consumer
                            }
                          }
                        },
                        child: authProvider.isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.white,
                            ),
                          ),
                        )
                            : const Text('Iniciar Sesión'),
                      ),

                      const SizedBox(height: 24),

                      // Divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'O',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.gray500,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),

                      // Después del botón de login, busca donde dice "¿No tienes cuenta?" o similar
// y reemplaza con esto:

                      const SizedBox(height: 24),

// Solo botón de registro de tutor
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿No tienes cuenta? ',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.gray600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/tutor-register');
                            },
                            child: Text(
                              'Regístrate aquí',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ✅ SECCIÓN DEMO
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Desarrollo',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.gray500,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ✅ BOTÓN DEMO
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.warning600,
                              AppColors.warning700,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.warning600.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                            final success = await authProvider.loginDemo();

                            if (success && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.science, color: Colors.white),
                                      SizedBox(width: 12),
                                      Text('¡Bienvenido al modo DEMO!'),
                                    ],
                                  ),
                                  backgroundColor: AppColors.warning600,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.science_outlined),
                          label: const Text('Entrar en Modo DEMO'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: AppColors.white,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Texto informativo
                      Text(
                        '🚀 Acceso directo sin credenciales para pruebas',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray500,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}