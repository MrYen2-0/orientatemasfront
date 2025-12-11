import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
          _emailSent = true;
        });
      }
    }
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
        title: Text(
          'Recuperar Contraseña',
          style: AppTextStyles.h4,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: _emailSent ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),

          // Icono
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.lock_reset,
                size: 40,
                color: AppColors.primary600,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Título
          Text(
            '¿Olvidó su contraseña?',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Descripción
          Text(
            'Ingrese su correo electrónico y le enviaremos instrucciones para restablecer su contraseña.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // Email Field
          Text(
            'Correo Electrónico',
            style: AppTextStyles.label,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'correo@ejemplo.com',
              prefixIcon: Icon(Icons.email_outlined),
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

          const SizedBox(height: 32),

          // Botón Enviar
          ElevatedButton(
            onPressed: _isLoading ? null : _handleResetPassword,
            child: _isLoading
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
                : const Text('Enviar Instrucciones'),
          ),

          const SizedBox(height: 24),

          // Botón Volver
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Volver al inicio de sesión',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),

        // Icono de éxito
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.success50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 60,
              color: AppColors.success600,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Título
        Text(
          '¡Correo Enviado!',
          style: AppTextStyles.h2,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        // Descripción
        Text(
          'Hemos enviado las instrucciones para restablecer su contraseña a:',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.gray600,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          _emailController.text,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.primary600,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        // Información adicional
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
                  'Revise su bandeja de entrada y spam. El correo puede tardar unos minutos en llegar.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary700,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Botón Volver al Login
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Volver al Inicio de Sesión'),
        ),

        const SizedBox(height: 16),

        // Reenviar correo
        TextButton(
          onPressed: () {
            setState(() => _emailSent = false);
          },
          child: Text(
            '¿No recibió el correo? Reenviar',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}