import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';

class StudentRegisterPage extends StatefulWidget {
  const StudentRegisterPage({super.key});

  @override
  State<StudentRegisterPage> createState() => _StudentRegisterPageState();
}

class _StudentRegisterPageState extends State<StudentRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthdateController = TextEditingController();

  String? _selectedSemester;
  String? _selectedState;
  bool _errorShown = false;

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2006, 1, 1),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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
        _birthdateController.text =
        '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>(); // ✅ CAMBIAR
    final tutorUser = authProvider.user;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gray900),
          onPressed: () {
            // Mostrar diálogo de confirmación
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('¿Cancelar registro?'),
                content: const Text(
                  'Si regresas ahora, perderás el registro del tutor. ¿Estás seguro?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Cerrar sesión del tutor
                      await authProvider.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login',
                              (route) => false,
                        );
                      }
                    },
                    child: const Text('Sí, cancelar'),
                  ),
                ],
              ),
            );
          },
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
                        'Registro del Estudiante',
                        style: AppTextStyles.h2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Completa la información del estudiante bajo tu tutela',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.gray600,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Info del tutor
                      if (tutorUser != null)
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
                                    Icons.person_outline,
                                    color: AppColors.primary600,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Tutor registrado:',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.primary700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tutorUser.name,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.primary700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (tutorUser.relationship != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  tutorUser.relationship!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primary700,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                      const SizedBox(height: 32),

                      // Nombre del estudiante
                      Text('Nombre completo del estudiante', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'María López Hernández',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el nombre del estudiante';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Email del estudiante (opcional)
                      Text('Correo electrónico (opcional)', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'estudiante@email.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Email inválido';
                            }
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Fecha de nacimiento
                      Text('Fecha de nacimiento', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _birthdateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'DD/MM/AAAA',
                          prefixIcon: Icon(Icons.calendar_today_outlined),
                        ),
                        onTap: _selectDate,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor selecciona la fecha de nacimiento';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Semestre
                      Text('Semestre actual', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedSemester,
                        decoration: const InputDecoration(
                          hintText: 'Selecciona el semestre',
                          prefixIcon: Icon(Icons.school_outlined),
                        ),
                        items: _semesters.map((semester) {
                          return DropdownMenuItem(
                            value: semester,
                            child: Text(semester),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedSemester = value);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor selecciona el semestre';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Estado
                      Text('Estado', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedState,
                        decoration: const InputDecoration(
                          hintText: 'Selecciona el estado',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                        items: _states.map((state) {
                          return DropdownMenuItem(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedState = value);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor selecciona el estado';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),

                      // Información importante
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.success50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.success700),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.verified_user_outlined,
                              color: AppColors.success600,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Los datos del estudiante estarán vinculados a tu cuenta de tutor. Podrás supervisar su progreso en cualquier momento.',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.success700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Botón finalizar registro
                      ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _errorShown = false);

                            final success = await authProvider.registerMinor(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim().isEmpty
                                  ? null
                                  : _emailController.text.trim(),
                              birthdate: _birthdateController.text,
                              semester: _selectedSemester!,
                              state: _selectedState!,
                            );

                            if (success && mounted) {
                              // Navegar a la página principal
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home',
                                    (route) => false,
                              );
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
                            : const Text('Finalizar Registro'),
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