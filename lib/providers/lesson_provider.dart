import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/lesson.dart';
import '../models/phrase.dart';

class LessonProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Lesson> _lessons = [];
  List<Phrase> _currentPhrases = [];
  int _currentLessonId = 0;

  List<Lesson> get lessons => _lessons;
  List<Phrase> get currentPhrases => _currentPhrases;
  int get currentLessonId => _currentLessonId;

  /// Load all lessons
  Future<void> loadLessons() async {
    try {
      final lessonMaps = await _db.getAllLessons();
      _lessons = lessonMaps.map((map) => Lesson.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading lessons: $e');
    }
  }

  /// Load phrases for a specific lesson
  Future<void> loadPhrasesForLesson(int lessonId) async {
    try {
      _currentLessonId = lessonId;
      final phraseMaps = await _db.getPhrasesByLesson(lessonId);
      _currentPhrases = phraseMaps.map((map) => Phrase.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading phrases: $e');
    }
  }

  /// Get lesson by ID
  Lesson? getLessonById(int id) {
    try {
      return _lessons.firstWhere((lesson) => lesson.id == id);
    } catch (e) {
      return null;
    }
  }
}
