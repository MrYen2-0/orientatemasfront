import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ReportProblemPage extends StatefulWidget {
  const ReportProblemPage({super.key});

  @override
  State<ReportProblemPage> createState() => _ReportProblemPageState();
}

class _ReportProblemPageState extends State<ReportProblemPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Error técnico';
  bool _isLoading = false;

  final List<String> _categories = [
    'Error técnico',
    'Problema con evaluación',
    'Error en resultados',
    'Problema de cuenta',
    'Error de visualización',
    'Otro',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
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
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Flexible(
                  child: Text('Reporte Enviado'),
                ),
              ],
            ),
            content: const Text(
              '¡Gracias por tu reporte! Nuestro equipo técnico lo revisará y trabajará en una solución lo antes posible.',
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
        title: Text('Reportar un Problema', style: AppTextStyles.h4),
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
                  color: AppColors.error50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.bug_report_outlined,
                  size: 40,
                  color: AppColors.error600,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Ayúdanos a mejorar',
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Reporta cualquier problema o error que encuentres. Tu feedback es muy valioso.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Categoría
            Text('Categoría del problema', style: AppTextStyles.label),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
            ),

            const SizedBox(height: 20),

            // Título
            Text('Título del problema', style: AppTextStyles.label),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Ej: No puedo ver mis resultados',
                prefixIcon: Icon(Icons.title_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un título';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Descripción
            Text('Descripción detallada', style: AppTextStyles.label),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Describe el problema con el mayor detalle posible:\n'
                    '• ¿Qué estabas haciendo?\n'
                    '• ¿Qué esperabas que pasara?\n'
                    '• ¿Qué pasó en realidad?',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor describe el problema';
                }
                if (value.length < 20) {
                  return 'Por favor proporciona más detalles (mínimo 20 caracteres)';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Tips para reportar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info700),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.tips_and_updates_outlined,
                        color: AppColors.info600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tips para un buen reporte',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.info700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildTip('Sé específico sobre el problema'),
                  _buildTip('Menciona los pasos para reproducirlo'),
                  _buildTip('Incluye capturas de pantalla si es posible'),
                  _buildTip('Indica tu dispositivo y sistema operativo'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Información del sistema
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información del Sistema',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Esta información se incluirá automáticamente:',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSystemInfo('Versión de la app', '1.0.0'),
                  _buildSystemInfo('Sistema operativo', 'Android 14'),
                  _buildSystemInfo('Dispositivo', 'Xiaomi Redmi Note 12'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Botón enviar
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _submitReport,
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
              label: Text(_isLoading ? 'Enviando...' : 'Enviar Reporte'),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.info700)),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.info700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.gray600,
            ),
          ),
          Text(
            value,
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