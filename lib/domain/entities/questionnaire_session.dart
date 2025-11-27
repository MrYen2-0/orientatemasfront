class QuestionnaireSession {
  final String sessionId;
  final Map<String, String> respuestas;
  final String? areaDetectada;
  final List<QuestionResponse> preguntasRespondidas;
  final String estado;
  final String fase; 
  final DateTime timestampInicio;
  final DateTime? timestampFin;
  final SessionStatistics estadisticas;

  QuestionnaireSession({
    required this.sessionId,
    required this.respuestas,
    this.areaDetectada,
    required this.preguntasRespondidas,
    required this.estado,
    required this.fase,
    required this.timestampInicio,
    this.timestampFin,
    required this.estadisticas,
  });

  factory QuestionnaireSession.initial(String sessionId) {
    return QuestionnaireSession(
      sessionId: sessionId,
      respuestas: {},
      preguntasRespondidas: [],
      estado: 'iniciado',
      fase: 'universal',
      timestampInicio: DateTime.now(),
      estadisticas: SessionStatistics.initial(),
    );
  }

  QuestionnaireSession copyWith({
    String? sessionId,
    Map<String, String>? respuestas,
    String? areaDetectada,
    List<QuestionResponse>? preguntasRespondidas,
    String? estado,
    String? fase,
    DateTime? timestampInicio,
    DateTime? timestampFin,
    SessionStatistics? estadisticas,
  }) {
    return QuestionnaireSession(
      sessionId: sessionId ?? this.sessionId,
      respuestas: respuestas ?? this.respuestas,
      areaDetectada: areaDetectada ?? this.areaDetectada,
      preguntasRespondidas: preguntasRespondidas ?? this.preguntasRespondidas,
      estado: estado ?? this.estado,
      fase: fase ?? this.fase,
      timestampInicio: timestampInicio ?? this.timestampInicio,
      timestampFin: timestampFin ?? this.timestampFin,
      estadisticas: estadisticas ?? this.estadisticas,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'respuestas': respuestas,
      'areaDetectada': areaDetectada,
      'preguntasRespondidas': preguntasRespondidas.map((q) => q.toJson()).toList(),
      'estado': estado,
      'fase': fase,
      'timestampInicio': timestampInicio.toIso8601String(),
      'timestampFin': timestampFin?.toIso8601String(),
      'estadisticas': estadisticas.toJson(),
    };
  }

  factory QuestionnaireSession.fromJson(Map<String, dynamic> json) {
    return QuestionnaireSession(
      sessionId: json['sessionId'] ?? '',
      respuestas: Map<String, String>.from(json['respuestas'] ?? {}),
      areaDetectada: json['areaDetectada'],
      preguntasRespondidas: (json['preguntasRespondidas'] as List?)
              ?.map((q) => QuestionResponse.fromJson(q))
              .toList() ??
          [],
      estado: json['estado'] ?? 'iniciado',
      fase: json['fase'] ?? 'universal',
      timestampInicio: DateTime.parse(json['timestampInicio']),
      timestampFin: json['timestampFin'] != null
          ? DateTime.parse(json['timestampFin'])
          : null,
      estadisticas: SessionStatistics.fromJson(
          json['estadisticas'] ?? SessionStatistics.initial().toJson()),
    );
  }
}

class QuestionResponse {
  final String preguntaId;
  final String preguntaTexto;
  final String respuesta;
  final DateTime timestamp;

  QuestionResponse({
    required this.preguntaId,
    required this.preguntaTexto,
    required this.respuesta,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'preguntaId': preguntaId,
      'preguntaTexto': preguntaTexto,
      'respuesta': respuesta,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory QuestionResponse.fromJson(Map<String, dynamic> json) {
    return QuestionResponse(
      preguntaId: json['preguntaId'] ?? '',
      preguntaTexto: json['preguntaTexto'] ?? '',
      respuesta: json['respuesta'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class SessionStatistics {
  final int preguntaActual;
  final bool debeContinuar;
  final String razonEstado;
  final double confianzaActual;
  final double entropia;
  final int reevaluaciones;
  final String? areaAnterior;

  SessionStatistics({
    required this.preguntaActual,
    required this.debeContinuar,
    required this.razonEstado,
    required this.confianzaActual,
    required this.entropia,
    required this.reevaluaciones,
    this.areaAnterior,
  });

  factory SessionStatistics.initial() {
    return SessionStatistics(
      preguntaActual: 0,
      debeContinuar: true,
      razonEstado: 'Iniciando cuestionario',
      confianzaActual: 0.0,
      entropia: 1.0,
      reevaluaciones: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preguntaActual': preguntaActual,
      'debeContinuar': debeContinuar,
      'razonEstado': razonEstado,
      'confianzaActual': confianzaActual,
      'entropia': entropia,
      'reevaluaciones': reevaluaciones,
      'areaAnterior': areaAnterior,
    };
  }

  factory SessionStatistics.fromJson(Map<String, dynamic> json) {
    return SessionStatistics(
      preguntaActual: json['preguntaActual'] ?? 0,
      debeContinuar: json['debeContinuar'] ?? true,
      razonEstado: json['razonEstado'] ?? '',
      confianzaActual: (json['confianzaActual'] ?? 0.0).toDouble(),
      entropia: (json['entropia'] ?? 1.0).toDouble(),
      reevaluaciones: json['reevaluaciones'] ?? 0,
      areaAnterior: json['areaAnterior'],
    );
  }
}

class CareerRecommendation {
  final String carrera;
  final double matchScore;
  final int ranking;
  final String explicacion;
  final List<String> fortalezas;
  final List<String> consideraciones;
  final Map<String, dynamic> infoAdicional;

  CareerRecommendation({
    required this.carrera,
    required this.matchScore,
    required this.ranking,
    required this.explicacion,
    required this.fortalezas,
    required this.consideraciones,
    required this.infoAdicional,
  });

  factory CareerRecommendation.fromJson(Map<String, dynamic> json) {
    return CareerRecommendation(
      carrera: json['carrera'] ?? '',
      matchScore: (json['match_score'] ?? 0.0).toDouble(),
      ranking: json['ranking'] ?? 0,
      explicacion: json['explicacion'] ?? '',
      fortalezas: List<String>.from(json['fortalezas'] ?? []),
      consideraciones: List<String>.from(json['consideraciones'] ?? []),
      infoAdicional: Map<String, dynamic>.from(json['info_adicional'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carrera': carrera,
      'match_score': matchScore,
      'ranking': ranking,
      'explicacion': explicacion,
      'fortalezas': fortalezas,
      'consideraciones': consideraciones,
      'info_adicional': infoAdicional,
    };
  }
}

class QuestionnaireResults {
  final String sessionId;
  final DateTime fechaEvaluacion;
  final String? resumenEjecutivo;
  final List<CareerRecommendation> recomendaciones;
  final Map<String, dynamic> metadata;

  QuestionnaireResults({
    required this.sessionId,
    required this.fechaEvaluacion,
    this.resumenEjecutivo,
    required this.recomendaciones,
    required this.metadata,
  });

  factory QuestionnaireResults.fromJson(Map<String, dynamic> json) {
    return QuestionnaireResults(
      sessionId: json['session_id'] ?? '',
      fechaEvaluacion: DateTime.parse(json['fecha_evaluacion']),
      resumenEjecutivo: json['resumen_ejecutivo'],
      recomendaciones: (json['recomendaciones'] as List)
          .map((r) => CareerRecommendation.fromJson(r))
          .toList(),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'fecha_evaluacion': fechaEvaluacion.toIso8601String(),
      'resumen_ejecutivo': resumenEjecutivo,
      'recomendaciones': recomendaciones.map((r) => r.toJson()).toList(),
      'metadata': metadata,
    };
  }
}