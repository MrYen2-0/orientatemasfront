import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _getPasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 6) return 'Débil';
    if (password.length < 10) return 'Media';
    return 'Fuerte';
  }

  Color _getPasswordStrengthColor(String password) {
    if (password.isEmpty) return AppColors.gray300;
    if (password.length < 6) return AppColors.error600;
    if (password.length < 10) return AppColors.warning600;
    return AppColors.success600;
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simular cambio de contraseña
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppColors.success600,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Contraseña Actualizada'),
              ],
            ),
            content: const Text(
              'Tu contraseña ha sido cambiada exitosamente. Úsala en tu próximo inicio de sesión.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Entendido'),
              ),
            ],
          ),
        );
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
        title: Text('Cambiar Contraseña', style: AppTextStyles.h4),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
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
                  Icons.lock_outline,
                  size: 40,
                  color: AppColors.primary600,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Actualiza tu contraseña',
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Asegúrate de que sea una contraseña fuerte y única.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Contraseña actual
            Text('Contraseña actual', style: AppTextStyles.label),
            const SizedBox(height: 8),
            TextFormField(
              controller: _currentPasswordController,
              obscureText: _obscureCurrentPassword,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureCurrentPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu contraseña actual';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Nueva contraseña
            Text('Nueva contraseña', style: AppTextStyles.label),
            const SizedBox(height: 8),
            TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
              ),
              onChanged: (value) => setState(() {}),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa una nueva contraseña';
                }
                if (value.length < 8) {
                  return 'Mínimo 8 caracteres';
                }
                if (value == _currentPasswordController.text) {
                  return 'Debe ser diferente a la actual';
                }
                return null;
              },
            ),

            // Indicador de fuerza
            if (_newPasswordController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: _newPasswordController.text.length / 12,
                      backgroundColor: AppColors.gray200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getPasswordStrengthColor(_newPasswordController.text),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _getPasswordStrength(_newPasswordController.text),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _getPasswordStrengthColor(_newPasswordController.text),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 20),

            // Confirmar contraseña
            Text('Confirmar nueva contraseña', style: AppTextStyles.label),
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
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirma tu nueva contraseña';
                }
                if (value != _newPasswordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Requisitos de contraseña
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary700),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 20,
                        color: AppColors.primary600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Requisitos de contraseña',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildRequirement('Mínimo 8 caracteres'),
                  _buildRequirement('Al menos una letra mayúscula'),
                  _buildRequirement('Al menos un número'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Botón
            ElevatedButton(
              onPressed: _isLoading ? null : _changePassword,
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
                  : const Text('Cambiar Contraseña'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            size: 16,
            color: AppColors.primary600,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary700,
            ),
          ),
        ],
      ),
    );
  }
}