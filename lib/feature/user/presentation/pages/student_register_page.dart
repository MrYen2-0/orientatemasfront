import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterMinorPage extends StatefulWidget {
  const RegisterMinorPage({super.key});

  @override
  State<RegisterMinorPage> createState() => _RegisterMinorPageState();
}

class _RegisterMinorPageState extends State<RegisterMinorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthdateController = TextEditingController();

  String? _selectedSemester;
  String? _selectedState;
  String? _selectedRelationship;
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

  final List<String> _relationships = [
    'Hijo',
    'Hija',
    'Primo',
    'Prima',
    'Hermano',
    'Hermana',
    'Otro',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final colorScheme = Theme.of(context).colorScheme;
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2006, 1, 1),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _birthdateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
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
                      final authProvider = context.read<AuthProvider>();
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
            if (authProvider.errorMessage != null && !_errorShown) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(authProvider.errorMessage!),
                    backgroundColor: colorScheme.error,
                  ),
                );
                setState(() => _errorShown = true);
                authProvider.clearError();
              });
            }

            if (authProvider.isAuthenticated && authProvider.user != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home',
                  (route) => false,
                );
              });
            }

            final tutorUser = authProvider.user;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Registro del Estudiante',
                        style: textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Completa la información del estudiante bajo tu tutela',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      if (tutorUser != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.primary),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: colorScheme.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Tutor registrado:',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tutorUser.name,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 32),

                      Text('Nombre completo del estudiante', style: textTheme.labelLarge),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Pedro González',
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

                      Text('Correo electrónico', style: textTheme.labelLarge),
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

                      Text('Fecha de nacimiento', style: textTheme.labelLarge),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _birthdateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'AAAA-MM-DD',
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

                      Text('Relación con el estudiante', style: textTheme.labelLarge),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedRelationship,
                        decoration: const InputDecoration(
                          hintText: 'Selecciona la relación',
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
                            return 'Por favor selecciona la relación';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      Text('Semestre actual', style: textTheme.labelLarge),
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

                      Text('Estado', style: textTheme.labelLarge),
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

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorScheme.secondary),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              color: colorScheme.secondary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Los datos del estudiante estarán vinculados a tu cuenta de tutor. Podrás supervisar su progreso en cualquier momento.',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

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
                                    relationship: _selectedRelationship!,
                                  );

                                  if (!success && mounted) {
                                    // Error se muestra automáticamente
                                  }
                                }
                              },
                        child: authProvider.isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : const Text('Finalizar Registro'),
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