import 'package:flutter/material.dart';

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
  String get salary => '\$${salario.inicial} - \$${salario.experimentado} MXN';
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