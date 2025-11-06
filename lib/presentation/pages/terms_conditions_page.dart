import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

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
          'Términos y Condiciones',
          style: AppTextStyles.h4,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Última actualización
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.primary600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Última actualización: Noviembre 2025',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Introducción
            Text(
              'Bienvenido a Orienta+',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 12),
            Text(
              'Al acceder y utilizar el Sistema Profesional de Orientación Vocacional Orienta+, usted acepta estar sujeto a los siguientes términos y condiciones de uso.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray700,
              ),
            ),

            const SizedBox(height: 24),
            const Divider(color: AppColors.gray200),
            const SizedBox(height: 24),

            // Sección 1
            _buildSection(
              '1. Aceptación de los Términos',
              'Al registrarse y utilizar Orienta+, usted acepta cumplir con estos términos y condiciones, así como con nuestra política de privacidad. Si no está de acuerdo con alguno de estos términos, no debe utilizar nuestro servicio.',
            ),

            // Sección 2
            _buildSection(
              '2. Uso del Servicio',
              'Orienta+ es un sistema de orientación vocacional diseñado para ayudar a estudiantes de preparatoria a identificar carreras profesionales acordes a sus aptitudes e intereses.\n\nUsted se compromete a:\n• Proporcionar información verídica y actualizada\n• Utilizar el servicio de manera responsable\n• No compartir su cuenta con terceros\n• No manipular o alterar los resultados de las evaluaciones',
            ),

            // Sección 3
            _buildSection(
              '3. Evaluaciones y Resultados',
              'Las evaluaciones vocacionales proporcionadas son herramientas de orientación basadas en algoritmos y no sustituyen la asesoría profesional personalizada. Los resultados son indicativos y no garantizan el éxito en una carrera específica.\n\nLos resultados se basan en:\n• Cuestionarios de aptitudes\n• Análisis de intereses\n• Perfiles vocacionales\n• Datos estadísticos del mercado laboral',
            ),

            // Sección 4
            _buildSection(
              '4. Privacidad y Protección de Datos',
              'Nos comprometemos a proteger su información personal de acuerdo con la legislación mexicana vigente (LFPDPPP) y regulaciones internacionales aplicables.\n\nRecopilamos:\n• Datos personales básicos (nombre, correo, semestre)\n• Respuestas a evaluaciones\n• Preferencias de carrera\n• Datos de uso del sistema\n\nNo compartimos su información con terceros sin su consentimiento explícito.',
            ),

            // Sección 5
            _buildSection(
              '5. Propiedad Intelectual',
              'Todo el contenido de Orienta+, incluyendo textos, gráficos, logos, algoritmos y software, es propiedad exclusiva de Orienta+ y está protegido por las leyes de propiedad intelectual.\n\nQueda prohibido:\n• Copiar o reproducir el contenido sin autorización\n• Realizar ingeniería inversa del software\n• Utilizar el sistema con fines comerciales sin licencia',
            ),

            // Sección 6
            _buildSection(
              '6. Responsabilidades del Usuario',
              'El usuario es responsable de:\n• Mantener la confidencialidad de su contraseña\n• Todas las actividades realizadas bajo su cuenta\n• Responder honestamente a las evaluaciones\n• Notificar cualquier uso no autorizado de su cuenta',
            ),

            // Sección 7
            _buildSection(
              '7. Limitación de Responsabilidad',
              'Orienta+ no se hace responsable por:\n• Decisiones académicas o profesionales basadas únicamente en nuestras recomendaciones\n• Interrupciones del servicio por mantenimiento o causas técnicas\n• Pérdida de datos debido a problemas técnicos del usuario\n• Contenido de sitios web de terceros enlazados',
            ),

            // Sección 8
            _buildSection(
              '8. Modificaciones del Servicio',
              'Nos reservamos el derecho de:\n• Modificar o actualizar estos términos en cualquier momento\n• Agregar o eliminar funcionalidades del servicio\n• Suspender temporalmente el servicio por mantenimiento\n• Cancelar cuentas que violen estos términos',
            ),

            // Sección 9
            _buildSection(
              '9. Terminación de Cuenta',
              'Usted puede solicitar la eliminación de su cuenta en cualquier momento desde la configuración. Al eliminar su cuenta:\n• Se borrarán permanentemente todos sus datos personales\n• Perderá acceso a sus resultados y evaluaciones\n• Esta acción es irreversible',
            ),

            // Sección 10
            _buildSection(
              '10. Ley Aplicable',
              'Estos términos se rigen por las leyes de los Estados Unidos Mexicanos. Cualquier disputa se resolverá en los tribunales competentes de México.',
            ),

            const SizedBox(height: 24),
            const Divider(color: AppColors.gray200),
            const SizedBox(height: 24),

            // Contacto
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.contact_support_outlined,
                        color: AppColors.primary600,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Contacto',
                        style: AppTextStyles.h4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Para preguntas sobre estos términos o el uso del servicio, contáctenos en:',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.gray700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildContactItem(Icons.email, 'soporte@orientaplus.com'),
                  _buildContactItem(Icons.language, 'www.orientaplus.com'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Botón de aceptar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('He Leído y Acepto'),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h4.copyWith(
              color: AppColors.primary600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.gray700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primary600,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}