import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/lesson.dart';
import '../models/phrase.dart';
import '../models/grammar_rule.dart';

class LessonProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Lesson> _lessons = [];
  List<Phrase> _currentPhrases = [];
  int _currentLessonId = 0;
  GrammarRule? _currentGrammarRule;
  String? _errorMessage;

  List<Lesson> get lessons => _lessons;
  List<Phrase> get currentPhrases => _currentPhrases;
  int get currentLessonId => _currentLessonId;
  GrammarRule? get currentGrammarRule => _currentGrammarRule;
  String? get errorMessage => _errorMessage;

  /// Load all lessons
  Future<void> loadLessons() async {
    try {
      _errorMessage = null;
      final lessonMaps = await _db.getAllLessons();
      _lessons = lessonMaps.map((map) => Lesson.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Error loading lessons: $e');
      _errorMessage = 'Failed to load lessons. Please try again.';
    }
    notifyListeners();
  }

  /// Load phrases for a specific lesson
  Future<void> loadPhrasesForLesson(int lessonId) async {
    try {
      _errorMessage = null;
      _currentLessonId = lessonId;
      final phraseMaps = await _db.getPhrasesByLesson(lessonId);
      _currentPhrases = phraseMaps.map((map) => Phrase.fromMap(map)).toList();
      await _loadGrammarRule(lessonId);
    } catch (e) {
      debugPrint('Error loading phrases: $e');
      _errorMessage = 'Failed to load phrases. Please try again.';
    }
    notifyListeners();
  }

  /// Load grammar rule for the current lesson
  Future<void> _loadGrammarRule(int lessonId) async {
    try {
      final ruleMap = await _db.getGrammarRuleForLesson(lessonId);
      if (ruleMap != null) {
        _currentGrammarRule = GrammarRule.fromMap(ruleMap);
      } else {
        _currentGrammarRule = null;
      }
    } catch (e) {
      print('Error loading grammar rule: $e');
      _currentGrammarRule = null;
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
