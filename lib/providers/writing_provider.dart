import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/writing_prompt.dart';

class WritingProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<WritingPrompt> _prompts = [];
  int _currentIndex = 0;
  bool _isCompleted = false;
  String? _errorMessage;
  final Map<int, String> _userWritings = {};

  List<WritingPrompt> get prompts => _prompts;
  int get currentIndex => _currentIndex;
  bool get isCompleted => _isCompleted;
  int get totalPrompts => _prompts.length;
  String? get errorMessage => _errorMessage;

  /// Load all writing prompts
  Future<void> loadPrompts() async {
    try {
      _errorMessage = null;
      final promptMaps = await _db.getAllWritingPrompts();
      _prompts = promptMaps.map((map) => WritingPrompt.fromMap(map)).toList();
      _currentIndex = 0;
      _isCompleted = false;
      _userWritings.clear();
    } catch (e) {
      debugPrint('Error loading writing prompts: $e');
      _errorMessage = 'Failed to load writing prompts. Please try again.';
    }
    notifyListeners();
  }

  /// Get current prompt
  WritingPrompt? get currentPrompt {
    if (_currentIndex < _prompts.length) {
      return _prompts[_currentIndex];
    }
    return null;
  }

  /// Save user's writing for current prompt
  void saveWriting(String text) {
    _userWritings[_currentIndex] = text;
  }

  /// Get user's writing for a specific prompt index
  String getWritingFor(int index) => _userWritings[index] ?? '';

  /// Get all user writings
  Map<int, String> get userWritings => Map.unmodifiable(_userWritings);

  /// All prompts for completion screen reference
  List<WritingPrompt> get allPrompts => List.unmodifiable(_prompts);

  /// Get user's writing for current prompt
  String getWriting() {
    return _userWritings[_currentIndex] ?? '';
  }

  /// Move to the next prompt
  void nextPrompt() {
    if (_currentIndex < _prompts.length - 1) {
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
    _isCompleted = false;
    _userWritings.clear();
    notifyListeners();
  }
}
