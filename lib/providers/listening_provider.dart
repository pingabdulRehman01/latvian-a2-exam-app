import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/listening_exercise.dart';
import '../services/tts_service.dart';

class ListeningProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  late TtsService _tts;

  List<ListeningExercise> _exercises = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  int _totalQuestionsAnswered = 0;
  bool _isCompleted = false;
  String? _errorMessage;

  // Tracks whether the current exercise has been scored to prevent double-counting on retry
  final Set<int> _scoredExercises = {};

  // Per-exercise answer tracking: map of (exerciseIndex, questionIndex) -> selectedOptionIndex
  final Map<String, int> _selectedAnswers = {};

  List<ListeningExercise> get exercises => _exercises;
  int get currentIndex => _currentIndex;
  int get correctCount => _correctCount;
  int get totalQuestionsAnswered => _totalQuestionsAnswered;
  bool get isCompleted => _isCompleted;
  int get totalExercises => _exercises.length;
  TtsService get tts => _tts;
  String? get errorMessage => _errorMessage;

  /// Initialize TTS
  Future<void> initTts() async {
    _tts = TtsService();
    await _tts.initialize();
  }

  /// Load all listening exercises
  Future<void> loadExercises() async {
    try {
      _errorMessage = null;
      final exerciseMaps = await _db.getAllListeningExercises();
      _exercises = exerciseMaps.map((map) => ListeningExercise.fromMap(map)).toList();
      _currentIndex = 0;
      _correctCount = 0;
      _totalQuestionsAnswered = 0;
      _isCompleted = false;
      _selectedAnswers.clear();
      _scoredExercises.clear();
    } catch (e) {
      debugPrint('Error loading listening exercises: $e');
      _errorMessage = 'Failed to load listening exercises. Please try again.';
    }
    notifyListeners();
  }

  /// Get current exercise
  ListeningExercise? get currentExercise {
    if (_currentIndex < _exercises.length) {
      return _exercises[_currentIndex];
    }
    return null;
  }

  /// Select an answer for a given question
  void selectAnswer(int questionIndex, int optionIndex) {
    final key = '$_currentIndex-$questionIndex';
    _selectedAnswers[key] = optionIndex;
    notifyListeners();
  }

  /// Get selected answer for a question
  int? getSelectedAnswer(int questionIndex) {
    final key = '$_currentIndex-$questionIndex';
    return _selectedAnswers[key];
  }

  /// Check if a specific answer is correct
  bool isAnswerCorrect(int questionIndex, int optionIndex) {
    final exercise = currentExercise;
    if (exercise == null || questionIndex >= exercise.questions.length) return false;
    return exercise.questions[questionIndex].correctIndex == optionIndex;
  }

  /// Check all questions for the current exercise
  /// Returns true if all questions are correct, false otherwise
  /// Only scores an exercise once to prevent double-counting on retry
  bool checkCurrentExercise() {
    final exercise = currentExercise;
    if (exercise == null) return false;

    // Prevent double-counting if already scored
    if (_scoredExercises.contains(_currentIndex)) return false;
    _scoredExercises.add(_currentIndex);

    bool allCorrect = true;
    for (int i = 0; i < exercise.questions.length; i++) {
      final key = '$_currentIndex-$i';
      final selected = _selectedAnswers[key];
      if (selected != null && selected == exercise.questions[i].correctIndex) {
        _correctCount++;
      } else {
        allCorrect = false;
      }
      _totalQuestionsAnswered++;
    }
    notifyListeners();
    return allCorrect;
  }

  /// Move to the next exercise
  void nextExercise() {
    if (_currentIndex < _exercises.length - 1) {
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
    _scoredExercises.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _tts.dispose();
    super.dispose();
  }
}
