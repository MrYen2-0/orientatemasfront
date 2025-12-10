import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ExploreCareersPage extends StatefulWidget {
  const ExploreCareersPage({super.key});

  @override
  State<ExploreCareersPage> createState() => _ExploreCareersPageState();
}

class _ExploreCareersPageState extends State<ExploreCareersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Todas';

  final List<String> _categories = [
    'Todas',
    'Salud',
    'Ingenieria',
    'Negocios',
    'Oficios Tecnicos',
  ];

  final List<CareerItem> _popularCareers = [
    CareerItem(
      id: '6',
      codigo: 'SW',
      name: 'Ingeniería en Software',
      nombreCompleto: 'Ingeniero en Software',
      category: 'Ingenieria',
      tipo: 'carrera_universitaria',
      nivelEducativo: 'Licenciatura',
      capacidadRequerida: 1.5,
      aosEstudio: 4,
      aosEspecialidad: 0,
      costoAproximado: 450000,
      dificultad: 8,
      description: 'Diseño, desarrollo y mantenimiento de sistemas de software para resolver problemas complejos mediante tecnología.',
      salario: SalarioInfo(
        inicial: 25000,
        promedio: 45000,
        experimentado: 70000,
        especialista: 120000,
        nota: 'Uno de los campos mejor pagados, especialmente en tecnológicas internacionales',
      ),
      mercadoLaboral: MercadoLaboralInfo(
        demanda: 'Muy Alta',
        crecimientoProyectado: '35%',
        empleabilidad: '98%',
        tiempoEncontrarTrabajo: '1-3 meses',
        sectoresPrincipales: ['Tecnología', 'Fintech', 'Startups', 'Empresas multinacionales'],
      ),
      requisitosIngreso: RequisitosIngresoInfo(
        promedioMinimo: '8.5',
        examenAdmision: 'CENEVAL-EXANI II',
        materiasClave: ['Matemáticas', 'Física', 'Lógica'],
        cursoPropedeutico: 'Recomendado',
      ),
      universidadesDestacadas: [
        UniversidadInfo(
          nombre: 'Tecnológico de Monterrey',
          tipo: 'privada',
          prestigio: 10,
          costoSemestral: 180000,
        ),
        UniversidadInfo(
          nombre: 'UNAM - Facultad de Ingeniería',
          tipo: 'pública',
          prestigio: 9,
          costoSemestral: 500,
        ),
        UniversidadInfo(
          nombre: 'IPN - ESCOM',
          tipo: 'pública',
          prestigio: 9,
          costoSemestral: 600,
        ),
      ],
      especializaciones: [
        'Desarrollo Web', 'Inteligencia Artificial', 'Ciberseguridad',
        'Desarrollo Mobile', 'DevOps', 'Data Science', 'Blockchain'
      ],
      competenciasRequeridas: [
        'Pensamiento lógico-matemático',
        'Capacidad de resolución de problemas',
        'Aprendizaje autodidacta',
        'Trabajo en equipo',
        'Adaptabilidad tecnológica'
      ],
      ventajas: [
        'Salarios muy competitivos',
        'Trabajo remoto disponible',
        'Campo en crecimiento acelerado',
        'Oportunidades internacionales',
        'Innovación constante'
      ],
      desafios: [
        'Actualización tecnológica constante',
        'Presión por entregas',
        'Trabajo sedentario',
        'Competencia globalizada'
      ],
      popularityRank: 1,
      icon: Icons.computer,
      color: AppColors.primary600,
    ),
    CareerItem(
      id: '1',
      codigo: 'MED',
      name: 'Medicina',
      nombreCompleto: 'Médico Cirujano',
      category: 'Salud',
      tipo: 'carrera_universitaria',
      nivelEducativo: 'Licenciatura + Especialidad',
      capacidadRequerida: 1.7,
      aosEstudio: 6,
      aosEspecialidad: 4,
      costoAproximado: 800000,
      dificultad: 9,
      description: 'Formación para diagnosticar, tratar y prevenir enfermedades, contribuyendo a la salud y bienestar de las personas.',
      salario: SalarioInfo(
        inicial: 25000,
        promedio: 45000,
        experimentado: 80000,
        especialista: 150000,
        nota: 'Varía significativamente por especialidad y sector (público vs privado)',
      ),
      mercadoLaboral: MercadoLaboralInfo(
        demanda: 'Alta',
        crecimientoProyectado: '15%',
        empleabilidad: '95%',
        tiempoEncontrarTrabajo: '6-12 meses',
        sectoresPrincipales: ['Salud pública', 'Hospitales privados', 'Consulta privada', 'Investigación'],
      ),
      requisitosIngreso: RequisitosIngresoInfo(
        promedioMinimo: '9.0',
        examenAdmision: 'CENEVAL-EXANI II',
        materiasClave: ['Biología', 'Química', 'Matemáticas', 'Física'],
        cursoPropedeutico: 'Requerido en la mayoría',
      ),
      universidadesDestacadas: [
        UniversidadInfo(
          nombre: 'UNAM - Facultad de Medicina',
          tipo: 'pública',
          prestigio: 10,
          costoSemestral: 500,
        ),
        UniversidadInfo(
          nombre: 'IPN - Escuela Superior de Medicina',
          tipo: 'pública',
          prestigio: 9,
          costoSemestral: 600,
        ),
        UniversidadInfo(
          nombre: 'Universidad Panamericana',
          tipo: 'privada',
          prestigio: 8,
          costoSemestral: 120000,
        ),
        UniversidadInfo(
          nombre: 'Tecnológico de Monterrey',
          tipo: 'privada',
          prestigio: 9,
          costoSemestral: 180000,
        ),
      ],
      especializaciones: [
        'Medicina Interna', 'Pediatría', 'Ginecología', 'Cirugía General', 
        'Cardiología', 'Neurología', 'Psiquiatría', 'Medicina Familiar'
      ],
      competenciasRequeridas: [
        'Conocimiento científico sólido',
        'Habilidades de comunicación',
        'Capacidad de trabajo bajo presión',
        'Empatía y sensibilidad social',
        'Pensamiento crítico',
        'Resistencia física y mental'
      ],
      ventajas: [
        'Alto prestigio social',
        'Posibilidad de salvar vidas',
        'Ingresos altos (especialistas)',
        'Múltiples oportunidades de especialización',
        'Demanda laboral constante'
      ],
      desafios: [
        'Carrera muy larga (10+ años)',
        'Alta exigencia académica',
        'Responsabilidad y estrés elevados',
        'Horarios irregulares',
        'Inversión económica considerable'
      ],
      popularityRank: 2,
      icon: Icons.medical_services,
      color: AppColors.error600,
    ),
    CareerItem(
      id: '2',
      codigo: 'PSI',
      name: 'Psicología',
      nombreCompleto: 'Licenciado en Psicología',
      category: 'Salud',
      tipo: 'carrera_universitaria',
      nivelEducativo: 'Licenciatura',
      capacidadRequerida: 1.3,
      aosEstudio: 4,
      aosEspecialidad: 2,
      costoAproximado: 400000,
      dificultad: 7,
      description: 'Estudio del comportamiento humano y procesos mentales para promover el bienestar psicológico.',
      salario: SalarioInfo(
        inicial: 15000,
        promedio: 25000,
        experimentado: 40000,
        especialista: 60000,
        nota: 'Consultorio privado puede generar ingresos variables pero potencialmente altos',
      ),
      mercadoLaboral: MercadoLaboralInfo(
        demanda: 'Alta',
        crecimientoProyectado: '20%',
        empleabilidad: '85%',
        tiempoEncontrarTrabajo: '3-6 meses',
        sectoresPrincipales: ['Salud mental', 'Educación', 'Recursos humanos', 'Consulta privada'],
      ),
      requisitosIngreso: RequisitosIngresoInfo(
        promedioMinimo: '8.0',
        examenAdmision: 'Examen institucional',
        materiasClave: ['Biología', 'Filosofía', 'Ciencias Sociales'],
        cursoPropedeutico: 'En algunas universidades',
      ),
      universidadesDestacadas: [
        UniversidadInfo(
          nombre: 'UNAM - Facultad de Psicología',
          tipo: 'pública',
          prestigio: 10,
          costoSemestral: 500,
        ),
        UniversidadInfo(
          nombre: 'Universidad Iberoamericana',
          tipo: 'privada',
          prestigio: 9,
          costoSemestral: 85000,
        ),
        UniversidadInfo(
          nombre: 'Universidad Anáhuac',
          tipo: 'privada',
          prestigio: 8,
          costoSemestral: 75000,
        ),
      ],
      especializaciones: [
        'Psicología Clínica', 'Psicología Educativa', 'Psicología Organizacional',
        'Neuropsicología', 'Psicología Social', 'Terapia Familiar'
      ],
      competenciasRequeridas: [
        'Excelentes habilidades de comunicación',
        'Empatía y sensibilidad',
        'Capacidad de análisis',
        'Estabilidad emocional',
        'Ética profesional sólida'
      ],
      ventajas: [
        'Campo laboral diverso',
        'Posibilidad de consulta privada',
        'Contribución al bienestar social',
        'Flexibilidad de horarios',
        'Crecimiento personal constante'
      ],
      desafios: [
        'Salarios iniciales relativamente bajos',
        'Carga emocional del trabajo',
        'Competencia en el mercado',
        'Necesidad de capacitación continua'
      ],
      popularityRank: 3,
      icon: Icons.psychology,
      color: AppColors.secondary600,
    ),
    CareerItem(
      id: '11',
      codigo: 'ADM',
      name: 'Administración',
      nombreCompleto: 'Licenciado en Administración',
      category: 'Negocios',
      tipo: 'carrera_universitaria',
      nivelEducativo: 'Licenciatura',
      capacidadRequerida: 1.1,
      aosEstudio: 4,
      aosEspecialidad: 0,
      costoAproximado: 320000,
      dificultad: 5,
      description: 'Gestión eficiente de recursos organizacionales para lograr objetivos empresariales y optimizar procesos.',
      salario: SalarioInfo(
        inicial: 14000,
        promedio: 25000,
        experimentado: 45000,
        especialista: 80000,
        nota: 'Altos ejecutivos y consultores pueden ganar significativamente más',
      ),
      mercadoLaboral: MercadoLaboralInfo(
        demanda: 'Alta',
        crecimientoProyectado: '15%',
        empleabilidad: '85%',
        tiempoEncontrarTrabajo: '3-5 meses',
        sectoresPrincipales: ['Empresas privadas', 'Gobierno', 'Consultoría', 'Emprendimiento'],
      ),
      requisitosIngreso: RequisitosIngresoInfo(
        promedioMinimo: '7.0',
        examenAdmision: 'Examen institucional',
        materiasClave: ['Matemáticas', 'Ciencias Sociales', 'Economía'],
        cursoPropedeutico: 'Opcional',
      ),
      universidadesDestacadas: [
        UniversidadInfo(
          nombre: 'Tecnológico de Monterrey',
          tipo: 'privada',
          prestigio: 10,
          costoSemestral: 180000,
        ),
        UniversidadInfo(
          nombre: 'Universidad Iberoamericana',
          tipo: 'privada',
          prestigio: 9,
          costoSemestral: 85000,
        ),
        UniversidadInfo(
          nombre: 'UNAM - FCA',
          tipo: 'pública',
          prestigio: 8,
          costoSemestral: 500,
        ),
      ],
      especializaciones: [
        'Recursos Humanos', 'Finanzas', 'Marketing', 'Operaciones',
        'Estrategia', 'Emprendimiento', 'Administración Pública'
      ],
      competenciasRequeridas: [
        'Liderazgo y gestión',
        'Comunicación efectiva',
        'Pensamiento analítico',
        'Toma de decisiones',
        'Trabajo en equipo'
      ],
      ventajas: [
        'Campo laboral amplio',
        'Versatilidad profesional',
        'Oportunidades de crecimiento',
        'Base para emprendimiento',
        'Networking extenso'
      ],
      desafios: [
        'Mercado saturado',
        'Competencia intensa',
        'Necesidad de especialización',
        'Presión por resultados'
      ],
      popularityRank: 4,
      icon: Icons.business_center,
      color: AppColors.accent600,
    ),
    CareerItem(
      id: '16',
      codigo: 'TEC_ENF',
      name: 'Técnico en Enfermería',
      nombreCompleto: 'Técnico Superior en Enfermería',
      category: 'Oficios_Tecnicos',
      tipo: 'carrera_tecnica',
      nivelEducativo: 'Técnico Superior',
      capacidadRequerida: 0.7,
      aosEstudio: 3,
      aosEspecialidad: 0,
      costoAproximado: 120000,
      dificultad: 5,
      description: 'Asistencia en el cuidado de pacientes bajo supervisión médica en hospitales, clínicas y centros de salud.',
      salario: SalarioInfo(
        inicial: 12000,
        promedio: 18000,
        experimentado: 25000,
        especialista: 32000,
        nota: 'Sector privado y guardias nocturnas incrementan ingresos',
      ),
      mercadoLaboral: MercadoLaboralInfo(
        demanda: 'Muy Alta',
        crecimientoProyectado: '25%',
        empleabilidad: '95%',
        tiempoEncontrarTrabajo: '1-2 meses',
        sectoresPrincipales: ['Hospitales', 'Clínicas', 'Casas de reposo', 'Atención domiciliaria'],
      ),
      requisitosIngreso: RequisitosIngresoInfo(
        promedioMinimo: '7.0',
        examenAdmision: 'Examen básico',
        materiasClave: ['Biología', 'Química'],
        cursoPropedeutico: 'Básico',
      ),
      universidadesDestacadas: [
        UniversidadInfo(
          nombre: 'CONALEP',
          tipo: 'pública',
          prestigio: 8,
          costoSemestral: 800,
        ),
        UniversidadInfo(
          nombre: 'CECATI',
          tipo: 'pública',
          prestigio: 7,
          costoSemestral: 500,
        ),
        UniversidadInfo(
          nombre: 'Instituto Mexicano del Seguro Social (IMSS)',
          tipo: 'pública',
          prestigio: 9,
          costoSemestral: 0,
        ),
      ],
      especializaciones: [
        'Cuidados Intensivos', 'Pediatría', 'Geriatría',
        'Quirófano', 'Urgencias', 'Rehabilitación'
      ],
      competenciasRequeridas: [
        'Vocación de servicio',
        'Resistencia física',
        'Habilidades de comunicación',
        'Trabajo en equipo',
        'Manejo del estrés'
      ],
      ventajas: [
        'Inserción laboral inmediata',
        'Demanda constante',
        'Trabajo humanitario significativo',
        'Horarios de guardia bien pagados',
        'Posibilidad de continuar estudios'
      ],
      desafios: [
        'Trabajo físicamente demandante',
        'Exposición a enfermedades',
        'Horarios rotativos',
        'Responsabilidad sobre vidas humanas'
      ],
      popularityRank: 5,
      icon: Icons.health_and_safety,
      color: AppColors.gray700,
    ),
  ];

  List<CareerItem> get _filteredCareers {
    if (_selectedCategory == 'Todas') {
      return _popularCareers;
    }
    return _popularCareers
        .where((career) => career.category == _selectedCategory)
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gray900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Explorar Carreras', style: AppTextStyles.h4),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar carreras...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.gray50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            color: AppColors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: AppColors.gray100,
                    selectedColor: AppColors.primary100,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primary700
                          : AppColors.gray700,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredCareers.length,
              itemBuilder: (context, index) {
                final career = _filteredCareers[index];
                return _buildCareerCard(career);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerCard(CareerItem career) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _showCareerDetails(career);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: career.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      career.icon,
                      color: career.color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.trending_up,
                                    size: 14,
                                    color: AppColors.warning700,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '#${career.popularityRank}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.warning700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                career.category,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          career.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                career.description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.gray600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildMetadataChip(
                    Icons.attach_money,
                    career.salary,
                    AppColors.success600,
                  ),
                  _buildMetadataChip(
                    Icons.trending_up,
                    career.demand,
                    _getDemandColor(career.demand),
                  ),
                  _buildMetadataChip(
                    Icons.schedule,
                    career.duration,
                    AppColors.gray600,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    _showCareerDetails(career);
                  },
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Ver detalles completos'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataChip(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.gray600,
          ),
        ),
      ],
    );
  }

  Color _getDemandColor(String demand) {
    switch (demand) {
      case 'Muy Alta':
        return AppColors.success600;
      case 'Alta':
        return AppColors.secondary600;
      case 'Media':
        return AppColors.warning600;
      default:
        return AppColors.gray600;
    }
  }

  void _showCareerDetails(CareerItem career) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: career.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    career.icon,
                    color: career.color,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                career.nombreCompleto,
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: career.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    career.category,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: career.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Descripción',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 8),
              Text(
                career.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray700,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailSection('Información Académica', [
                _buildDetailRow('Nivel Educativo', career.nivelEducativo),
                _buildDetailRow('Duración', '${career.aosEstudio} años'),
                _buildDetailRow('Dificultad', '${career.dificultad}/10'),
                _buildDetailRow('Costo Aproximado', '\$${career.costoAproximado.toString()} MXN'),
                _buildDetailRow('Capacidad Requerida', career.capacidadRequerida.toString()),
              ]),
              const SizedBox(height: 24),
              _buildDetailSection('Información Salarial', [
                _buildDetailRow('Salario Inicial', '\$${career.salario.inicial.toString()} MXN'),
                _buildDetailRow('Salario Promedio', '\$${career.salario.promedio.toString()} MXN'),
                _buildDetailRow('Salario Experimentado', '\$${career.salario.experimentado.toString()} MXN'),
                _buildDetailRow('Salario Especialista', '\$${career.salario.especialista.toString()} MXN'),
                _buildDetailRow('Nota Salarial', career.salario.nota),
              ]),
              const SizedBox(height: 24),
              _buildDetailSection('Mercado Laboral', [
                _buildDetailRow('Demanda', career.mercadoLaboral.demanda),
                _buildDetailRow('Crecimiento Proyectado', career.mercadoLaboral.crecimientoProyectado),
                _buildDetailRow('Empleabilidad', career.mercadoLaboral.empleabilidad),
                _buildDetailRow('Tiempo para Encontrar Trabajo', career.mercadoLaboral.tiempoEncontrarTrabajo),
              ]),
              const SizedBox(height: 24),
              _buildDetailSection('Requisitos de Ingreso', [
                _buildDetailRow('Promedio Mínimo', career.requisitosIngreso.promedioMinimo),
                _buildDetailRow('Examen de Admisión', career.requisitosIngreso.examenAdmision),
                _buildDetailRow('Materias Clave', career.requisitosIngreso.materiasClave.join(', ')),
                _buildDetailRow('Curso Propedéutico', career.requisitosIngreso.cursoPropedeutico),
              ]),
              const SizedBox(height: 24),
              Text(
                'Universidades Destacadas',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 12),
              ...career.universidadesDestacadas.map((uni) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.gray50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gray200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      uni.nombre,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Tipo: ${uni.tipo}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.gray600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Prestigio: ${uni.prestigio}/10',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.gray600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Costo: \$${uni.costoSemestral}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )).toList(),
              const SizedBox(height: 24),
              Text(
                'Sectores Principales',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: career.mercadoLaboral.sectoresPrincipales.map((sector) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.info50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.info700),
                    ),
                    child: Text(
                      sector,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.info700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text(
                'Especializaciones',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: career.especializaciones.map((spec) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.secondary700),
                    ),
                    child: Text(
                      spec,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondary700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text(
                'Competencias Requeridas',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: career.competenciasRequeridas.map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary700),
                    ),
                    child: Text(
                      skill,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text(
                'Ventajas',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 8),
              ...career.ventajas.map((ventaja) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success600,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ventaja,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray700,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
              const SizedBox(height: 24),
              Text(
                'Desafíos',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 8),
              ...career.desafios.map((desafio) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning,
                      color: AppColors.warning600,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        desafio,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray700,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cerrar'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h4,
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.gray900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CareerItem {
  final String id;
  final String codigo;
  final String name;
  final String nombreCompleto;
  final String category;
  final String tipo;
  final String nivelEducativo;
  final double capacidadRequerida;
  final int aosEstudio;
  final int aosEspecialidad;
  final int costoAproximado;
  final int dificultad;
  final String description;
  final SalarioInfo salario;
  final MercadoLaboralInfo mercadoLaboral;
  final RequisitosIngresoInfo requisitosIngreso;
  final List<UniversidadInfo> universidadesDestacadas;
  final List<String> especializaciones;
  final List<String> competenciasRequeridas;
  final List<String> ventajas;
  final List<String> desafios;
  final int popularityRank;
  final IconData icon;
  final Color color;

  CareerItem({
    required this.id,
    required this.codigo,
    required this.name,
    required this.nombreCompleto,
    required this.category,
    required this.tipo,
    required this.nivelEducativo,
    required this.capacidadRequerida,
    required this.aosEstudio,
    required this.aosEspecialidad,
    required this.costoAproximado,
    required this.dificultad,
    required this.description,
    required this.salario,
    required this.mercadoLaboral,
    required this.requisitosIngreso,
    required this.universidadesDestacadas,
    required this.especializaciones,
    required this.competenciasRequeridas,
    required this.ventajas,
    required this.desafios,
    required this.popularityRank,
    required this.icon,
    required this.color,
  });

  String get demand => mercadoLaboral.demanda;
  String get salary => '\$${salario.inicial.toString()} - \$${salario.experimentado.toString()} MXN';
  String get duration => '$aosEstudio años';
  String get jobOpportunities => '${mercadoLaboral.empleabilidad} de empleabilidad';
  List<String> get skills => competenciasRequeridas.take(3).toList();
}

class SalarioInfo {
  final int inicial;
  final int promedio;
  final int experimentado;
  final int especialista;
  final String nota;

  SalarioInfo({
    required this.inicial,
    required this.promedio,
    required this.experimentado,
    required this.especialista,
    required this.nota,
  });
}

class MercadoLaboralInfo {
  final String demanda;
  final String crecimientoProyectado;
  final String empleabilidad;
  final String tiempoEncontrarTrabajo;
  final List<String> sectoresPrincipales;

  MercadoLaboralInfo({
    required this.demanda,
    required this.crecimientoProyectado,
    required this.empleabilidad,
    required this.tiempoEncontrarTrabajo,
    required this.sectoresPrincipales,
  });
}

class RequisitosIngresoInfo {
  final String promedioMinimo;
  final String examenAdmision;
  final List<String> materiasClave;
  final String cursoPropedeutico;

  RequisitosIngresoInfo({
    required this.promedioMinimo,
    required this.examenAdmision,
    required this.materiasClave,
    required this.cursoPropedeutico,
  });
}

class UniversidadInfo {
  final String nombre;
  final String tipo;
  final int prestigio;
  final int costoSemestral;

  UniversidadInfo({
    required this.nombre,
    required this.tipo,
    required this.prestigio,
    required this.costoSemestral,
  });
}