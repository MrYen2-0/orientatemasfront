import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Nombre del usuario');
  final _emailController = TextEditingController(text: 'correo@ejemplo.com');
  final _phoneController = TextEditingController(text: '961 300 8534');
  final _birthdateController = TextEditingController(text: '15/05/2006');

  String _selectedSemester = '5° Semestre';
  String _selectedState = 'Chiapas';

  final List<String> _semesters = [
    '1° Semestre',
    '2° Semestre',
    '3° Semestre',
    '4° Semestre',
    '5° Semestre',
    '6° Semestre',
  ];

  final List<String> _states = [
    'Aguascalientes', 'Baja California', 'Baja California Sur', 'Campeche',
    'Chiapas', 'Chihuahua', 'Ciudad de México', 'Coahuila', 'Colima',
    'Durango', 'Estado de México', 'Guanajuato', 'Guerrero', 'Hidalgo',
    'Jalisco', 'Michoacán', 'Morelos', 'Nayarit', 'Nuevo León', 'Oaxaca',
    'Puebla', 'Querétaro', 'Quintana Roo', 'San Luis Potosí', 'Sinaloa',
    'Sonora', 'Tabasco', 'Tamaulipas', 'Tlaxcala', 'Veracruz', 'Yucatán',
    'Zacatecas',
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2006, 5, 15),
      firstDate: DateTime(1990),
      lastDate: DateTime(2010),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary600,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _birthdateController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simular guardado
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Información actualizada correctamente'),
            backgroundColor: AppColors.success600,
          ),
        );

        Navigator.of(context).pop();
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
        title: Text('Editar Información Personal', style: AppTextStyles.h4),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary600,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 4),
                    ),
                    child: const Center(
                      child: Text(
                        'CJ',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary600,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: AppColors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Nombre completo
            Text('Nombre completo', style: AppTextStyles.label),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Tu nombre completo',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu nombre';
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
                hintText: 'tu@email.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Email inválido';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Teléfono
            Text('Teléfono', style: AppTextStyles.label),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '961 123 4567',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),

            const SizedBox(height: 20),

            // Fecha de nacimiento
            Text('Fecha de nacimiento', style: AppTextStyles.label),
            const SizedBox(height: 8),
            TextFormField(
              controller: _birthdateController,
              readOnly: true,
              onTap: _selectDate,
              decoration: const InputDecoration(
                hintText: 'DD/MM/AAAA',
                prefixIcon: Icon(Icons.calendar_today_outlined),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
            ),

            const SizedBox(height: 20),

            // Semestre
            Text('Semestre actual', style: AppTextStyles.label),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedSemester,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.school_outlined),
              ),
              items: _semesters.map((semester) {
                return DropdownMenuItem(
                  value: semester,
                  child: Text(semester),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedSemester = value!);
              },
            ),

            const SizedBox(height: 20),

            // Estado
            Text('Estado', style: AppTextStyles.label),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedState,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              items: _states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedState = value!);
              },
            ),

            const SizedBox(height: 32),

            // Botón guardar
            ElevatedButton(
              onPressed: _isLoading ? null : _saveChanges,
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
                  : const Text('Guardar Cambios'),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}