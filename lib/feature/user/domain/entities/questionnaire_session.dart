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
  final int ranking;
  final String codigo;
  final String carrera;
  final String nombreCompleto;
  final double matchScore;
  final String matchScorePorcentaje;
  final String categoria;
  final String? rama;
  final String explicacion;
  final String explicacionPersonalizada;
  final bool explicacionGenerada;
  final Map<String, dynamic> infoBasica;
  final Map<String, dynamic> mercadoLaboral;
  final List<String> fortalezas;
  final List<String> consideraciones;
  final Map<String, dynamic> infoAdicional;

  CareerRecommendation({
    required this.ranking,
    required this.codigo,
    required this.carrera,
    required this.nombreCompleto,
    required this.matchScore,
    required this.matchScorePorcentaje,
    required this.categoria,
    this.rama,
    required this.explicacion,
    required this.explicacionPersonalizada,
    required this.explicacionGenerada,
    required this.infoBasica,
    required this.mercadoLaboral,
    required this.fortalezas,
    required this.consideraciones,
    required this.infoAdicional,
  });

  factory CareerRecommendation.fromJson(Map<String, dynamic> json) {
    return CareerRecommendation(
      ranking: json['ranking'] ?? 0,
      codigo: json['codigo'] ?? '',
      carrera: json['nombre'] ?? json['carrera'] ?? '',
      nombreCompleto: json['nombre_completo'] ?? json['nombre'] ?? '',
      matchScore: (json['match_score'] ?? 0.0).toDouble(),
      matchScorePorcentaje: json['match_porcentaje'] ?? json['match_score_porcentaje'] ?? '0%',
      categoria: json['categoria'] ?? '',
      rama: json['rama'],
      explicacion: json['explicacion_llm'] ?? json['explicacion_personalizada'] ?? json['explicacion'] ?? 'Sin explicacion disponible',
      explicacionPersonalizada: json['explicacion_llm'] ?? json['explicacion_personalizada'] ?? 'Sin explicacion personalizada disponible',
      explicacionGenerada: json['explicacion_generada_por_ia'] ?? json['explicacion_generada'] ?? false,
      infoBasica: json['info_basica'] ?? {},
      mercadoLaboral: json['mercado_laboral'] ?? {},
      fortalezas: List<String>.from(json['ventajas'] ?? json['fortalezas'] ?? []),
      consideraciones: List<String>.from(json['desafios'] ?? json['consideraciones'] ?? []),
      infoAdicional: _buildInfoAdicional(json),
    );
  }

  static Map<String, dynamic> _buildInfoAdicional(Map<String, dynamic> json) {
    final infoBasica = json['info_basica'] ?? {};
    final mercado = json['mercado_laboral'] ?? {};
    
    return {
      'area': json['rama'] ?? json['categoria'] ?? 'N/A',
      'duracion_años': infoBasica['años_estudio'] ?? infoBasica['anos_estudio'] ?? 'N/A',
      'dificultad': infoBasica['dificultad'] ?? 'N/A',
      'salario_promedio_mxn': infoBasica['salario_promedio'] ?? mercado['salario_promedio'] ?? 0,
      'nivel_educativo': infoBasica['nivel_educativo'] ?? 'N/A',
      'demanda_laboral': mercado['demanda'] ?? 'N/A',
      'crecimiento': mercado['crecimiento'] ?? 'N/A',
      'oportunidades': mercado['oportunidades'] ?? [],
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'ranking': ranking,
      'codigo': codigo,
      'nombre': carrera,
      'nombre_completo': nombreCompleto,
      'match_score': matchScore,
      'match_porcentaje': matchScorePorcentaje,
      'categoria': categoria,
      'rama': rama,
      'explicacion_llm': explicacionPersonalizada,
      'explicacion_generada_por_ia': explicacionGenerada,
      'info_basica': infoBasica,
      'mercado_laboral': mercadoLaboral,
      'ventajas': fortalezas,
      'desafios': consideraciones,
    };
  }
}

class QuestionnaireResults {
  final String sessionId;
  final List<CareerRecommendation> recomendaciones;
  final String? resumenEjecutivo;
  final String? mensajeMotivacional;
  final double capacidadAcademica;
  final String categoria;
  final String? ramaUniversitaria;
  final DateTime fechaEvaluacion;
  final Map<String, dynamic> metadata;

  QuestionnaireResults({
    required this.sessionId,
    required this.recomendaciones,
    this.resumenEjecutivo,
    this.mensajeMotivacional,
    required this.capacidadAcademica,
    required this.categoria,
    this.ramaUniversitaria,
    required this.fechaEvaluacion,
    required this.metadata,
  });

  factory QuestionnaireResults.fromJson(Map<String, dynamic> json) {
    return QuestionnaireResults(
      sessionId: json['session_metadata']?['session_id'] ?? json['session_id'] ?? '',
      recomendaciones: (json['recomendaciones'] as List<dynamic>?)
              ?.map((item) => CareerRecommendation.fromJson(item))
              .toList() ??
          [],
      resumenEjecutivo: json['resumen_ejecutivo'],
      mensajeMotivacional: json['mensaje_motivacional'],
      capacidadAcademica: (json['capacidad_academica']?['score'] ?? 0.0).toDouble(),
      categoria: json['capacidad_academica']?['categoria'] ?? 'N/A',
      ramaUniversitaria: json['rama_universitaria'],
      fechaEvaluacion: DateTime.tryParse(json['fecha_evaluacion'] ?? '') ?? DateTime.now(),
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'recomendaciones': recomendaciones.map((r) => r.toJson()).toList(),
      'resumen_ejecutivo': resumenEjecutivo,
      'mensaje_motivacional': mensajeMotivacional,
      'capacidad_academica': {
        'score': capacidadAcademica,
        'categoria': categoria,
      },
      'rama_universitaria': ramaUniversitaria,
      'fecha_evaluacion': fechaEvaluacion.toIso8601String(),
      'metadata': metadata,
    };
  }
}

enum QuestionnaireStatus {
  idle,
  loading,
  active,
  completed,
  error,
}

class Question {
  final String id;
  final String pregunta;
  final List<String> opciones;
  final Map<String, dynamic>? metadata;

  Question({
    required this.id,
    required this.pregunta,
    required this.opciones,
    this.metadata,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      pregunta: json['pregunta'] ?? '',
      opciones: List<String>.from(json['opciones'] ?? []),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pregunta': pregunta,
      'opciones': opciones,
      'metadata': metadata,
    };
  }
}