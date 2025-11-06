import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class TestimonialsPage extends StatelessWidget {
  const TestimonialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final testimonials = [
      Testimonial(
        name: 'María González',
        career: 'Ingeniería en Software',
        university: 'UNAM',
        year: '2020',
        avatar: 'MG',
        rating: 5,
        testimonialText:
        'Orienta+ fue fundamental para mi decisión. La evaluación mostró que tenía alta compatibilidad con carreras tecnológicas. Hoy trabajo en una empresa internacional y amo lo que hago. Los resultados fueron muy acertados.',
        currentRole: 'Desarrolladora Full-Stack en Google',
        salary: '\$85,000 MXN/mes',
      ),
      Testimonial(
        name: 'Carlos Ramírez',
        career: 'Medicina',
        university: 'ITESM',
        year: '2019',
        avatar: 'CR',
        rating: 5,
        testimonialText:
        'Siempre tuve dudas entre medicina e ingeniería. La plataforma me ayudó a identificar que mi verdadera pasión era ayudar a las personas. Hoy soy médico y no podría estar más feliz con mi elección.',
        currentRole: 'Médico General - Hospital ABC',
        salary: '\$45,000 MXN/mes',
      ),
      Testimonial(
        name: 'Ana Martínez',
        career: 'Administración de Empresas',
        university: 'UDLAP',
        year: '2021',
        avatar: 'AM',
        rating: 4,
        testimonialText:
        'Los testimonios de otros egresados me inspiraron. La información sobre el mercado laboral fue muy útil para tomar mi decisión. Ahora dirijo mi propia startup.',
        currentRole: 'CEO de TechStart MX',
        salary: '\$120,000 MXN/mes',
      ),
      Testimonial(
        name: 'Luis Hernández',
        career: 'Diseño Gráfico',
        university: 'UAM',
        year: '2022',
        avatar: 'LH',
        rating: 5,
        testimonialText:
        'Nunca pensé que mi creatividad podría convertirse en una carrera exitosa. La plataforma me mostró opciones que no conocía. Ahora trabajo para marcas internacionales haciendo lo que amo.',
        currentRole: 'Director Creativo en Ogilvy',
        salary: '\$55,000 MXN/mes',
      ),
      Testimonial(
        name: 'Sofia Torres',
        career: 'Psicología',
        university: 'UANL',
        year: '2020',
        avatar: 'ST',
        rating: 5,
        testimonialText:
        'La evaluación identificó perfectamente mi empatía y habilidades interpersonales. Hoy ayudo a cientos de personas como terapeuta y me siento realizada profesionalmente.',
        currentRole: 'Psicóloga Clínica',
        salary: '\$32,000 MXN/mes',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gray900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Testimonios de Egresados', style: AppTextStyles.h4),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary600, AppColors.primary700],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.format_quote,
                  color: AppColors.white,
                  size: 40,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Historias Reales de Éxito',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Conoce las experiencias de quienes ya eligieron su carrera',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Estadísticas
          Row(
            children: [
              Expanded(
                child: _buildStatCard('95%', 'Satisfacción', Icons.sentiment_very_satisfied),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('500+', 'Testimonios', Icons.people),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('4.8', 'Calificación', Icons.star),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Testimonios
          ...testimonials.map((testimonial) {
            return _buildTestimonialCard(testimonial);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary600, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.primary600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(Testimonial testimonial) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con avatar y nombre
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary600,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    testimonial.avatar,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${testimonial.career} • ${testimonial.university}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Rating
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < testimonial.rating ? Icons.star : Icons.star_border,
                color: AppColors.warning600,
                size: 20,
              );
            }),
          ),

          const SizedBox(height: 12),

          // Testimonio
          Text(
            testimonial.testimonialText,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.gray700,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 16),

          // Información actual
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.work_outline,
                      size: 16,
                      color: AppColors.primary600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        testimonial.currentRole,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.attach_money,
                      size: 16,
                      color: AppColors.success600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Salario: ${testimonial.salary}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.success700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppColors.gray600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Egresado en ${testimonial.year}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Testimonial {
  final String name;
  final String career;
  final String university;
  final String year;
  final String avatar;
  final int rating;
  final String testimonialText;
  final String currentRole;
  final String salary;

  Testimonial({
    required this.name,
    required this.career,
    required this.university,
    required this.year,
    required this.avatar,
    required this.rating,
    required this.testimonialText,
    required this.currentRole,
    required this.salary,
  });
}