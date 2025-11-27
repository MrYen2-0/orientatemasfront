import 'dart:convert';
import 'package:integradorfront/domain/entities/questionnaire_session.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QuestionnaireLocalStorage {
  static final QuestionnaireLocalStorage _instance =
      QuestionnaireLocalStorage._internal();
  factory QuestionnaireLocalStorage() => _instance;
  QuestionnaireLocalStorage._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'questionnaire.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla para sesiones
    await db.execute('''
      CREATE TABLE sessions (
        id TEXT PRIMARY KEY,
        session_data TEXT NOT NULL,
        estado TEXT NOT NULL,
        timestamp_inicio TEXT NOT NULL,
        timestamp_fin TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Tabla para resultados
    await db.execute('''
      CREATE TABLE results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id TEXT NOT NULL,
        results_data TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (session_id) REFERENCES sessions (id) ON DELETE CASCADE
      )
    ''');

    // Índices para mejor performance
    await db.execute('''
      CREATE INDEX idx_sessions_estado ON sessions(estado)
    ''');

    await db.execute('''
      CREATE INDEX idx_sessions_timestamp ON sessions(timestamp_inicio)
    ''');
  }

  // ==================== SESIONES ====================

  /// Guarda o actualiza una sesión
  Future<bool> saveSession(QuestionnaireSession session) async {
    try {
      final db = await database;
      final now = DateTime.now().toIso8601String();

      await db.insert(
        'sessions',
        {
          'id': session.sessionId,
          'session_data': jsonEncode(session.toJson()),
          'estado': session.estado,
          'timestamp_inicio': session.timestampInicio.toIso8601String(),
          'timestamp_fin': session.timestampFin?.toIso8601String(),
          'created_at': now,
          'updated_at': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return true;
    } catch (e) {
      print('❌ Error guardando sesión: $e');
      return false;
    }
  }

  /// Obtiene una sesión por ID
  Future<QuestionnaireSession?> getSession(String sessionId) async {
    try {
      final db = await database;
      final maps = await db.query(
        'sessions',
        where: 'id = ?',
        whereArgs: [sessionId],
      );

      if (maps.isEmpty) return null;

      final sessionData = jsonDecode(maps.first['session_data'] as String);
      return QuestionnaireSession.fromJson(sessionData);
    } catch (e) {
      print('❌ Error obteniendo sesión: $e');
      return null;
    }
  }

  /// Obtiene todas las sesiones
  Future<List<QuestionnaireSession>> getAllSessions() async {
    try {
      final db = await database;
      final maps = await db.query(
        'sessions',
        orderBy: 'timestamp_inicio DESC',
      );

      return maps.map((map) {
        final sessionData = jsonDecode(map['session_data'] as String);
        return QuestionnaireSession.fromJson(sessionData);
      }).toList();
    } catch (e) {
      print('❌ Error obteniendo sesiones: $e');
      return [];
    }
  }

  /// Obtiene sesiones por estado
  Future<List<QuestionnaireSession>> getSessionsByEstado(String estado) async {
    try {
      final db = await database;
      final maps = await db.query(
        'sessions',
        where: 'estado = ?',
        whereArgs: [estado],
        orderBy: 'timestamp_inicio DESC',
      );

      return maps.map((map) {
        final sessionData = jsonDecode(map['session_data'] as String);
        return QuestionnaireSession.fromJson(sessionData);
      }).toList();
    } catch (e) {
      print('❌ Error obteniendo sesiones por estado: $e');
      return [];
    }
  }

  /// Obtiene la sesión más reciente en progreso (si existe)
  Future<QuestionnaireSession?> getLatestInProgressSession() async {
    try {
      final db = await database;
      final maps = await db.query(
        'sessions',
        where: 'estado IN (?, ?)',
        whereArgs: ['iniciado', 'en_progreso'],
        orderBy: 'timestamp_inicio DESC',
        limit: 1,
      );

      if (maps.isEmpty) return null;

      final sessionData = jsonDecode(maps.first['session_data'] as String);
      return QuestionnaireSession.fromJson(sessionData);
    } catch (e) {
      print('❌ Error obteniendo sesión en progreso: $e');
      return null;
    }
  }

  /// Elimina una sesión
  Future<bool> deleteSession(String sessionId) async {
    try {
      final db = await database;
      await db.delete(
        'sessions',
        where: 'id = ?',
        whereArgs: [sessionId],
      );
      return true;
    } catch (e) {
      print('❌ Error eliminando sesión: $e');
      return false;
    }
  }

  /// Elimina todas las sesiones
  Future<bool> deleteAllSessions() async {
    try {
      final db = await database;
      await db.delete('sessions');
      return true;
    } catch (e) {
      print('❌ Error eliminando todas las sesiones: $e');
      return false;
    }
  }

  // ==================== RESULTADOS ====================

  /// Guarda resultados de una sesión
  Future<bool> saveResults(QuestionnaireResults results) async {
    try {
      final db = await database;
      final now = DateTime.now().toIso8601String();

      await db.insert(
        'results',
        {
          'session_id': results.sessionId,
          'results_data': jsonEncode(results.toJson()),
          'created_at': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return true;
    } catch (e) {
      print('❌ Error guardando resultados: $e');
      return false;
    }
  }

  /// Obtiene resultados de una sesión
  Future<QuestionnaireResults?> getResults(String sessionId) async {
    try {
      final db = await database;
      final maps = await db.query(
        'results',
        where: 'session_id = ?',
        whereArgs: [sessionId],
      );

      if (maps.isEmpty) return null;

      final resultsData = jsonDecode(maps.first['results_data'] as String);
      return QuestionnaireResults.fromJson(resultsData);
    } catch (e) {
      print('❌ Error obteniendo resultados: $e');
      return null;
    }
  }

  /// Obtiene todos los resultados guardados
  Future<List<QuestionnaireResults>> getAllResults() async {
    try {
      final db = await database;
      final maps = await db.query(
        'results',
        orderBy: 'created_at DESC',
      );

      return maps.map((map) {
        final resultsData = jsonDecode(map['results_data'] as String);
        return QuestionnaireResults.fromJson(resultsData);
      }).toList();
    } catch (e) {
      print('❌ Error obteniendo todos los resultados: $e');
      return [];
    }
  }

  /// Elimina resultados de una sesión
  Future<bool> deleteResults(String sessionId) async {
    try {
      final db = await database;
      await db.delete(
        'results',
        where: 'session_id = ?',
        whereArgs: [sessionId],
      );
      return true;
    } catch (e) {
      print('❌ Error eliminando resultados: $e');
      return false;
    }
  }

  // ==================== UTILIDADES ====================

  /// Obtiene estadísticas de uso
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final db = await database;

      final totalSessions = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM sessions'),
      );

      final completedSessions = Sqflite.firstIntValue(
        await db.rawQuery(
            'SELECT COUNT(*) FROM sessions WHERE estado = ?', ['completado']),
      );

      final inProgressSessions = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM sessions WHERE estado IN (?, ?)',
            ['iniciado', 'en_progreso']),
      );

      final totalResults = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM results'),
      );

      return {
        'total_sesiones': totalSessions ?? 0,
        'sesiones_completadas': completedSessions ?? 0,
        'sesiones_en_progreso': inProgressSessions ?? 0,
        'total_resultados': totalResults ?? 0,
      };
    } catch (e) {
      print('❌ Error obteniendo estadísticas: $e');
      return {};
    }
  }

  /// Limpia sesiones antiguas (más de 30 días)
  Future<int> cleanOldSessions({int daysOld = 30}) async {
    try {
      final db = await database;
      final cutoffDate =
          DateTime.now().subtract(Duration(days: daysOld)).toIso8601String();

      final deletedCount = await db.delete(
        'sessions',
        where: 'timestamp_inicio < ? AND estado = ?',
        whereArgs: [cutoffDate, 'completado'],
      );

      return deletedCount;
    } catch (e) {
      print('❌ Error limpiando sesiones antiguas: $e');
      return 0;
    }
  }

  /// Cierra la base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}