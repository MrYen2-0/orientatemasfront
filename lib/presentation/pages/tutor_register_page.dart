import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';

class TutorRegisterPage extends StatefulWidget {
  const TutorRegisterPage({super.key});

  @override
  State<TutorRegisterPage> createState() => _TutorRegisterPageState();
}

class _TutorRegisterPageState extends State<TutorRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _errorShown = false;

  String? _selectedRelationship;

  final List<String> _relationships = [
    'Padre',
    'Madre',
    'Tutor Legal',
    'Abuelo/a',
    'Tío/a',
    'Otro familiar',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gray900),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            // Mostrar errores
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

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Título
                      Text(
                        'Registro de Tutor',
                        style: AppTextStyles.h2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Registra tus datos como tutor o responsable del menor',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.gray600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Nombre completo del tutor
                      Text('Nombre completo del tutor', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Juan Pérez García',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu nombre completo';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Relación con el menor
                      Text('Relación con el menor', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedRelationship,
                        decoration: const InputDecoration(
                          hintText: 'Selecciona tu relación',
                          prefixIcon: Icon(Icons.family_restroom_outlined),
                        ),
                        items: _relationships.map((relationship) {
                          return DropdownMenuItem(
                            value: relationship,
                            child: Text(relationship),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedRelationship = value);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor selecciona tu relación con el menor';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Teléfono
                      Text('Teléfono de contacto', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: '961 123 4567',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu teléfono';
                          }
                          if (value.length < 10) {
                            return 'Teléfono inválido';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Email
                      Text('Correo electrónico', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'tutor@email.com',
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

                      // Contraseña
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
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una contraseña';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Confirmar contraseña
                      Text('Confirmar contraseña', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(
                                      () => _obscureConfirmPassword = !_obscureConfirmPassword);
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor confirma tu contraseña';
                          }
                          if (value != _passwordController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),

                      // Aviso importante
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary700),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppColors.primary600,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Después del registro, podrás registrar al menor bajo tu tutela.',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      // Botón registrar tutor
                      // Botón registrar tutor
                      ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _errorShown = false);

                            print('🔵 Iniciando registro de tutor...'); // DEBUG

                            final success = await authProvider.registerTutor(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                              name: _nameController.text.trim(),
                              phone: _phoneController.text.trim(),
                              relationship: _selectedRelationship!,
                            );

                            print('🔵 Registro completado. Success: $success'); // DEBUG
                            print('🔵 Mounted: $mounted'); // DEBUG

                            if (success && mounted) {
                              print('🔵 Navegando a /student-register'); // DEBUG

                              // Navegar a la página de registro del estudiante
                              Navigator.of(context).pushReplacementNamed(
                                '/student-register',
                              );

                              print('🔵 Navegación ejecutada'); // DEBUG
                            } else {
                              print('🔴 No se navegó. Success: $success, Mounted: $mounted'); // DEBUG
                            }
                          } else {
                            print('🔴 Formulario no válido'); // DEBUG
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
                            : const Text('Continuar'),
                      ),

                      const SizedBox(height: 16),

                      // Link a login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿Ya tienes cuenta? ',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.gray600,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Inicia sesión',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
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