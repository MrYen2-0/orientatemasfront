import 'package:flutter/material.dart';
import '../model/career_models.dart';
import 'detail_section_widget.dart';

class CareerDetailSheet extends StatelessWidget {
  final CareerItem career;

  const CareerDetailSheet({
    super.key,
    required this.career,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                  color: colorScheme.outline,
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
              style: textTheme.displayMedium,
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
                  style: textTheme.bodyMedium?.copyWith(
                    color: career.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Descripción', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              career.description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            DetailSectionWidget(
              title: 'Información Académica',
              items: [
                DetailItem('Nivel Educativo', career.nivelEducativo),
                DetailItem('Duración', '${career.aosEstudio} años'),
                DetailItem('Dificultad', '${career.dificultad}/10'),
                DetailItem('Costo Aproximado', '\$${career.costoAproximado} MXN'),
                DetailItem('Capacidad Requerida', career.capacidadRequerida.toString()),
              ],
            ),
            const SizedBox(height: 24),
            DetailSectionWidget(
              title: 'Información Salarial',
              items: [
                DetailItem('Salario Inicial', '\$${career.salario.inicial} MXN'),
                DetailItem('Salario Promedio', '\$${career.salario.promedio} MXN'),
                DetailItem('Salario Experimentado', '\$${career.salario.experimentado} MXN'),
                DetailItem('Salario Especialista', '\$${career.salario.especialista} MXN'),
                DetailItem('Nota Salarial', career.salario.nota),
              ],
            ),
            // Continúa con las demás secciones...
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}