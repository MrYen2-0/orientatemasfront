class PredictionResponse {
  final String sessionId;
  final CapacidadAcademica capacidadAcademica;
  final String? ramaUniversitaria;
  final List<CarreraRecomendacion> top3Recomendaciones;
  final String resumenEjecutivo;
  final String mensajeMotivacional;
  final int totalRespuestas;
  final DateTime timestamp;
  final bool llmDisponible;

  PredictionResponse({
    required this.sessionId,
    required this.capacidadAcademica,
    this.ramaUniversitaria,
    required this.top3Recomendaciones,
    required this.resumenEjecutivo,
    required this.mensajeMotivacional,
    required this.totalRespuestas,
    required this.timestamp,
    required this.llmDisponible,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      sessionId: json['session_id'],
      capacidadAcademica: CapacidadAcademica.fromJson(json['capacidad_academica']),
      ramaUniversitaria: json['rama_universitaria'],
      top3Recomendaciones: (json['top_3_recomendaciones'] as List)
          .map((e) => CarreraRecomendacion.fromJson(e))
          .toList(),
      resumenEjecutivo: json['resumen_ejecutivo'] ?? '',
      mensajeMotivacional: json['mensaje_motivacional'] ?? '',
      totalRespuestas: json['total_respuestas'],
      timestamp: DateTime.parse(json['timestamp']),
      llmDisponible: json['llm_disponible'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'capacidad_academica': capacidadAcademica.toJson(),
      'rama_universitaria': ramaUniversitaria,
      'top_3_recomendaciones': top3Recomendaciones.map((e) => e.toJson()).toList(),
      'resumen_ejecutivo': resumenEjecutivo,
      'mensaje_motivacional': mensajeMotivacional,
      'total_respuestas': totalRespuestas,
      'timestamp': timestamp.toIso8601String(),
      'llm_disponible': llmDisponible,
    };
  }
}

class CapacidadAcademica {
  final double score;
  final String categoria;
  final String descripcion;

  CapacidadAcademica({
    required this.score,
    required this.categoria,
    required this.descripcion,
  });

  factory CapacidadAcademica.fromJson(Map<String, dynamic> json) {
    return CapacidadAcademica(
      score: json['score']?.toDouble() ?? 0.0,
      categoria: json['categoria'] ?? '',
      descripcion: json['descripcion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'categoria': categoria,
      'descripcion': descripcion,
    };
  }
}

class CarreraRecomendacion {
  final int ranking;
  final String nombre;
  final String codigo;
  final double matchScore;
  final String matchPorcentaje;
  final String categoria;
  final String? rama;
  final InfoBasica infoBasica;
  final String explicacionLlm;
  final bool explicacionGeneradaPorIa;

  CarreraRecomendacion({
    required this.ranking,
    required this.nombre,
    required this.codigo,
    required this.matchScore,
    required this.matchPorcentaje,
    required this.categoria,
    this.rama,
    required this.infoBasica,
    required this.explicacionLlm,
    required this.explicacionGeneradaPorIa,
  });

  factory CarreraRecomendacion.fromJson(Map<String, dynamic> json) {
    return CarreraRecomendacion(
      ranking: json['ranking'],
      nombre: json['nombre'],
      codigo: json['codigo'],
      matchScore: json['match_score']?.toDouble() ?? 0.0,
      matchPorcentaje: json['match_porcentaje'] ?? '',
      categoria: json['categoria'],
      rama: json['rama'],
      infoBasica: InfoBasica.fromJson(json['info_basica']),
      explicacionLlm: json['explicacion_llm'] ?? '',
      explicacionGeneradaPorIa: json['explicacion_generada_por_ia'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ranking': ranking,
      'nombre': nombre,
      'codigo': codigo,
      'match_score': matchScore,
      'match_porcentaje': matchPorcentaje,
      'categoria': categoria,
      'rama': rama,
      'info_basica': infoBasica.toJson(),
      'explicacion_llm': explicacionLlm,
      'explicacion_generada_por_ia': explicacionGeneradaPorIa,
    };
  }
}

class InfoBasica {
  final dynamic anosEstudio;
  final String nivelEducativo;
  final String dificultad;
  final dynamic salarioPromedio;

  InfoBasica({
    required this.anosEstudio,
    required this.nivelEducativo,
    required this.dificultad,
    required this.salarioPromedio,
  });

  factory InfoBasica.fromJson(Map<String, dynamic> json) {
    return InfoBasica(
      anosEstudio: json['anos_estudio'] ?? json['años_estudio'],
      nivelEducativo: json['nivel_educativo'] ?? '',
      dificultad: json['dificultad'] ?? '',
      salarioPromedio: json['salario_promedio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'anos_estudio': anosEstudio,
      'nivel_educativo': nivelEducativo,
      'dificultad': dificultad,
      'salario_promedio': salarioPromedio,
    };
  }
}