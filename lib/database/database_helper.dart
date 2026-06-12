import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_seed.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('latvian_a2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String path = filePath;
    if (!kIsWeb) {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);
    }

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE lessons (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        dayNumber INTEGER NOT NULL,
        topic TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        isCompleted INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE phrases (
        id INTEGER PRIMARY KEY,
        lessonId INTEGER NOT NULL,
        phraseLv TEXT NOT NULL,
        phraseEn TEXT NOT NULL,
        difficultyLevel TEXT DEFAULT 'A2',
        FOREIGN KEY (lessonId) REFERENCES lessons (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE attempts (
        id INTEGER PRIMARY KEY,
        phraseId INTEGER NOT NULL,
        userTranscript TEXT NOT NULL,
        targetPhrase TEXT NOT NULL,
        score INTEGER NOT NULL,
        result TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (phraseId) REFERENCES phrases (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE mistakes (
        id INTEGER PRIMARY KEY,
        phraseId INTEGER NOT NULL UNIQUE,
        retryCount INTEGER DEFAULT 0,
        lastAttempted TEXT NOT NULL,
        isResolved INTEGER DEFAULT 0,
        FOREIGN KEY (phraseId) REFERENCES phrases (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE grammar_rules (
        id INTEGER PRIMARY KEY,
        lessonId INTEGER NOT NULL,
        title TEXT NOT NULL,
        explanation TEXT NOT NULL,
        examples TEXT NOT NULL,
        category TEXT NOT NULL,
        FOREIGN KEY (lessonId) REFERENCES lessons (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE listening_exercises (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        textLv TEXT NOT NULL,
        textEn TEXT NOT NULL,
        topic TEXT NOT NULL,
        questions TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE reading_passages (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        textLv TEXT NOT NULL,
        textEn TEXT NOT NULL,
        topic TEXT NOT NULL,
        vocabulary TEXT NOT NULL,
        questions TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE writing_prompts (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        promptEn TEXT NOT NULL,
        promptLv TEXT NOT NULL,
        topic TEXT NOT NULL,
        vocabulary TEXT NOT NULL,
        modelAnswer TEXT NOT NULL
      )
    ''');

    await seedDatabase(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // grammar_rules was part of the original schema but missing from upgrades.
    // Table creation is defensive — data already exists from _createDB at v1.
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS grammar_rules (
          id INTEGER PRIMARY KEY,
          lessonId INTEGER NOT NULL,
          title TEXT NOT NULL,
          explanation TEXT NOT NULL,
          examples TEXT NOT NULL,
          category TEXT NOT NULL,
          FOREIGN KEY (lessonId) REFERENCES lessons (id)
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS listening_exercises (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          textLv TEXT NOT NULL,
          textEn TEXT NOT NULL,
          topic TEXT NOT NULL,
          questions TEXT NOT NULL
        )
      ''');
      await seedListeningExercises(db);
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS reading_passages (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          textLv TEXT NOT NULL,
          textEn TEXT NOT NULL,
          topic TEXT NOT NULL,
          vocabulary TEXT NOT NULL,
          questions TEXT NOT NULL
        )
      ''');
      await seedReadingPassages(db);
    }
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS writing_prompts (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          promptEn TEXT NOT NULL,
          promptLv TEXT NOT NULL,
          topic TEXT NOT NULL,
          vocabulary TEXT NOT NULL,
          modelAnswer TEXT NOT NULL
        )
      ''');
      await seedWritingPrompts(db);
    }
  }

  Future<int> insertLesson(Map<String, dynamic> lesson) async {
    final db = await database;
    return await db.insert('lessons', lesson);
  }

  Future<List<Map<String, dynamic>>> getAllLessons() async {
    final db = await database;
    return await db.query('lessons', orderBy: 'dayNumber ASC');
  }

  Future<List<Map<String, dynamic>>> getPhrasesByLesson(int lessonId) async {
    final db = await database;
    return await db.query('phrases', where: 'lessonId = ?', whereArgs: [lessonId]);
  }

  Future<int> insertAttempt(Map<String, dynamic> attempt) async {
    final db = await database;
    return await db.insert('attempts', attempt);
  }

  Future<List<Map<String, dynamic>>> getAttemptsByPhrase(int phraseId) async {
    final db = await database;
    return await db.query('attempts', where: 'phraseId = ?', whereArgs: [phraseId]);
  }

  Future<int> insertMistake(Map<String, dynamic> mistake) async {
    final db = await database;
    return await db.insert(
      'mistakes',
      mistake,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllMistakes() async {
    final db = await database;
    return await db.query('mistakes', where: 'isResolved = 0');
  }

  Future<int> updateMistakeRetryCount(int phraseId, int retryCount) async {
    final db = await database;
    return await db.update(
      'mistakes',
      {'retryCount': retryCount, 'lastAttempted': DateTime.now().toIso8601String()},
      where: 'phraseId = ?',
      whereArgs: [phraseId],
    );
  }

  Future<int> deleteMistake(int phraseId) async {
    final db = await database;
    return await db.delete(
      'mistakes',
      where: 'phraseId = ?',
      whereArgs: [phraseId],
    );
  }

  Future<Map<String, dynamic>?> getPhraseById(int phraseId) async {
    final db = await database;
    final result = await db.query('phrases', where: 'id = ?', whereArgs: [phraseId]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> getAttemptCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM attempts');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<double> getAverageScore() async {
    final db = await database;
    final result = await db.rawQuery('SELECT AVG(score) as avg FROM attempts');
    if (result.isNotEmpty && result.first['avg'] != null) {
      return (result.first['avg'] as num).toDouble();
    }
    return 0.0;
  }

  // ── Grammar rules ────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getGrammarRuleForLesson(int lessonId) async {
    final db = await database;
    final result = await db.query(
      'grammar_rules',
      where: 'lessonId = ?',
      whereArgs: [lessonId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // ── Listening exercises ─────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getAllListeningExercises() async {
    final db = await database;
    return await db.query('listening_exercises');
  }

  Future<Map<String, dynamic>?> getListeningExerciseById(int id) async {
    final db = await database;
    final result = await db.query('listening_exercises', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getListeningExercisesByTopic(String topic) async {
    final db = await database;
    return await db.query('listening_exercises', where: 'topic = ?', whereArgs: [topic]);
  }

  // ── Reading passages ───────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getAllReadingPassages() async {
    final db = await database;
    return await db.query('reading_passages');
  }

  Future<Map<String, dynamic>?> getReadingPassageById(int id) async {
    final db = await database;
    final result = await db.query('reading_passages', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getReadingPassagesByTopic(String topic) async {
    final db = await database;
    return await db.query('reading_passages', where: 'topic = ?', whereArgs: [topic]);
  }

  // ── Writing prompts ─────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getAllWritingPrompts() async {
    final db = await database;
    return await db.query('writing_prompts');
  }

  Future<Map<String, dynamic>?> getWritingPromptById(int id) async {
    final db = await database;
    final result = await db.query('writing_prompts', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }
}
