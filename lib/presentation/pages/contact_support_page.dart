import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copiado al portapapeles'),
        backgroundColor: AppColors.success600,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simular envío
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
                const Text('Mensaje Enviado'),
              ],
            ),
            content: const Text(
              'Tu mensaje ha sido enviado exitosamente. Nuestro equipo responderá en menos de 24 horas.',
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
        title: Text('Contactar al Soporte', style: AppTextStyles.h4),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Icono
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.secondary50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.headset_mic,
                size: 40,
                color: AppColors.secondary600,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Estamos aquí para ayudarte',
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'Elige el método de contacto que prefieras o envíanos un mensaje directamente.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Métodos de contacto directo
          Text('Contacto Directo', style: AppTextStyles.h4),
          const SizedBox(height: 16),

          // Email
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary700),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary600,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.email_outlined,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'softcode20246@gmail.com',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: AppColors.primary600),
                  onPressed: () => _copyToClipboard(
                    'softcode20246@gmail.com',
                    'Email',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Teléfono
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.secondary700),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondary600,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.phone_outlined,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Teléfono',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '961 300 8534',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.secondary700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: AppColors.secondary600),
                  onPressed: () => _copyToClipboard(
                    '9613008534',
                    'Teléfono',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Formulario de contacto
          Text('Enviar un Mensaje', style: AppTextStyles.h4),
          const SizedBox(height: 16),

          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Asunto
                Text('Asunto', style: AppTextStyles.label),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    hintText: 'Ej: Problema con mi evaluación',
                    prefixIcon: Icon(Icons.subject_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un asunto';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Mensaje
                Text('Mensaje', style: AppTextStyles.label),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _messageController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'Describe tu problema o pregunta...',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un mensaje';
                    }
                    if (value.length < 10) {
                      return 'El mensaje debe tener al menos 10 caracteres';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Info de respuesta
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.info700),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.info600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Te responderemos en menos de 24 horas',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.info700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Botón enviar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                        : const Icon(Icons.send),
                    label: Text(_isLoading ? 'Enviando...' : 'Enviar Mensaje'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Horario de atención
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gray200),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: AppColors.gray600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Horario de Atención',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildScheduleRow('Lunes - Viernes', '9:00 AM - 6:00 PM'),
                _buildScheduleRow('Sábados', '10:00 AM - 2:00 PM'),
                _buildScheduleRow('Domingos', 'Cerrado'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.gray600,
            ),
          ),
          Text(
            hours,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}