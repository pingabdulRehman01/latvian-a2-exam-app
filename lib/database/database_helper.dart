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
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Create tables
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

    // Seed data
    await seedDatabase(db);
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
}
