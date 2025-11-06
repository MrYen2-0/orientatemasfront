import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../bloc/auth/auth_bloc.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error600,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Logo corporativo
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

                  // Título
                  Text(
                    'Iniciar Sesión',
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Accede a tu cuenta profesional',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.gray600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),

                  // Email Field
                  Text(
                    'Correo Electrónico',
                    style: AppTextStyles.label,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'correo@ejemplo.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      prefixIconColor: AppColors.gray400,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su correo electrónico';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Formato de correo inválido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Password Field
                  Text(
                    'Contraseña',
                    style: AppTextStyles.label,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline),
                      prefixIconColor: AppColors.gray400,
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
                        return 'Por favor ingrese su contraseña';
                      }
                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Remember me & Forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() => _rememberMe = value ?? false);
                              },
                              activeColor: AppColors.primary600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Recordar sesión',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.gray600,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          '¿Olvidó su contraseña?',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Login Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return ElevatedButton(
                        onPressed: isLoading ? null : _handleLogin,
                        child: isLoading
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
                      );
                    },
                  ),
                  const SizedBox(height: 16),

// Botón Entrar como Invitado
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Entrar como Invitado (Demo)'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondary600,
                      side: const BorderSide(color: AppColors.secondary600, width: 2),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tiene una cuenta?',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(left: 4),
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Regístrese',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Footer profesional
                  Text(
                    'Sistema de Orientación Vocacional Profesional',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gray400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
