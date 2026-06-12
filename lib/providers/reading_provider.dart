import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/reading_passage.dart';

class ReadingProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<ReadingPassage> _passages = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  int _totalQuestionsAnswered = 0;
  bool _isCompleted = false;
  String? _errorMessage;

  final Set<int> _scoredPassages = {};
  final Map<String, int> _selectedAnswers = {};

  List<ReadingPassage> get passages => _passages;
  int get currentIndex => _currentIndex;
  int get correctCount => _correctCount;
  int get totalQuestionsAnswered => _totalQuestionsAnswered;
  bool get isCompleted => _isCompleted;
  int get totalPassages => _passages.length;
  String? get errorMessage => _errorMessage;

  /// Load all reading passages
  Future<void> loadPassages() async {
    try {
      _errorMessage = null;
      final passageMaps = await _db.getAllReadingPassages();
      _passages = passageMaps.map((map) => ReadingPassage.fromMap(map)).toList();
      _currentIndex = 0;
      _correctCount = 0;
      _totalQuestionsAnswered = 0;
      _isCompleted = false;
      _selectedAnswers.clear();
      _scoredPassages.clear();
    } catch (e) {
      debugPrint('Error loading reading passages: $e');
      _errorMessage = 'Failed to load reading passages. Please try again.';
    }
    notifyListeners();
  }

  /// Get current passage
  ReadingPassage? get currentPassage {
    if (_currentIndex < _passages.length) {
      return _passages[_currentIndex];
    }
    return null;
  }

  /// Select an answer
  void selectAnswer(int questionIndex, int optionIndex) {
    final key = '$_currentIndex-$questionIndex';
    _selectedAnswers[key] = optionIndex;
    notifyListeners();
  }

  /// Get selected answer
  int? getSelectedAnswer(int questionIndex) {
    final key = '$_currentIndex-$questionIndex';
    return _selectedAnswers[key];
  }

  /// Score the current passage (only once)
  bool checkCurrentPassage() {
    final passage = currentPassage;
    if (passage == null) return false;

    if (_scoredPassages.contains(_currentIndex)) return false;
    _scoredPassages.add(_currentIndex);

    bool allCorrect = true;
    for (int i = 0; i < passage.questions.length; i++) {
      final key = '$_currentIndex-$i';
      final selected = _selectedAnswers[key];
      if (selected != null && selected == passage.questions[i].correctIndex) {
        _correctCount++;
      } else {
        allCorrect = false;
      }
      _totalQuestionsAnswered++;
    }
    notifyListeners();
    return allCorrect;
  }

  /// Move to the next passage
  void nextPassage() {
    if (_currentIndex < _passages.length - 1) {
      _currentIndex++;
      notifyListeners();
    } else {
      _isCompleted = true;
      notifyListeners();
    }
  }

  /// Reset the session
  void reset() {
    _currentIndex = 0;
    _correctCount = 0;
    _totalQuestionsAnswered = 0;
    _isCompleted = false;
    _selectedAnswers.clear();
    _scoredPassages.clear();
    notifyListeners();
  }
}
