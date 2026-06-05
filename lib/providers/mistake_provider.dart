import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/mistake.dart';
import '../models/phrase.dart';

class MistakeProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Mistake> _mistakes = [];
  Map<int, Phrase?> _phraseCache = {};

  List<Mistake> get mistakes => _mistakes;

  /// Load all mistakes
  Future<void> loadMistakes() async {
    try {
      final mistakeMaps = await _db.getAllMistakes();
      _mistakes = mistakeMaps.map((map) => Mistake.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading mistakes: $e');
    }
  }

  /// Get phrase by ID (with caching)
  Future<Phrase?> getPhraseById(int phraseId) async {
    if (_phraseCache.containsKey(phraseId)) {
      return _phraseCache[phraseId];
    }
    try {
      final phraseMap = await _db.getPhraseById(phraseId);
      if (phraseMap != null) {
        final phrase = Phrase.fromMap(phraseMap);
        _phraseCache[phraseId] = phrase;
        return phrase;
      }
    } catch (e) {
      print('Error getting phrase: $e');
    }
    return null;
  }

  /// Update retry count
  Future<void> updateRetryCount(int phraseId, int newCount) async {
    try {
      await _db.updateMistakeRetryCount(phraseId, newCount);
      await loadMistakes();
    } catch (e) {
      print('Error updating retry count: $e');
    }
  }

  /// Remove mistake from list
  Future<void> removeMistake(int phraseId) async {
    try {
      await _db.deleteMistake(phraseId);
      await loadMistakes();
    } catch (e) {
      print('Error removing mistake: $e');
    }
  }
}
