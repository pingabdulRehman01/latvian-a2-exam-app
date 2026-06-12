import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../services/scoring_service.dart';

class PracticeProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  int _currentPhraseIndex = 0;
  String _userTranscript = '';
  int _currentScore = 0;
  String _currentFeedback = '';
  bool _isRecording = false;

  int get currentPhraseIndex => _currentPhraseIndex;
  String get userTranscript => _userTranscript;
  int get currentScore => _currentScore;
  String get currentFeedback => _currentFeedback;
  bool get isRecording => _isRecording;

  void setRecordingState(bool state) {
    _isRecording = state;
    notifyListeners();
  }

  void setUserTranscript(String transcript) {
    _userTranscript = transcript;
    notifyListeners();
  }

  void resetPhraseIndex() {
    _currentPhraseIndex = 0;
    _userTranscript = '';
    _currentScore = 0;
    _currentFeedback = '';
    notifyListeners();
  }

  void nextPhrase() {
    _currentPhraseIndex++;
    _userTranscript = '';
    _currentScore = 0;
    _currentFeedback = '';
    notifyListeners();
  }

  void previousPhrase() {
    if (_currentPhraseIndex > 0) {
      _currentPhraseIndex--;
      _userTranscript = '';
      _currentScore = 0;
      _currentFeedback = '';
      notifyListeners();
    }
  }

  /// Calculate and save attempt
  Future<void> submitAttempt(int phraseId, String userPhrase, String targetPhrase) async {
    try {
      final score = ScoringService.calculateScore(userPhrase, targetPhrase);
      final feedback = ScoringService.getScoreFeedback(score);
      final detailedFeedback = ScoringService.getDetailedFeedback(userPhrase, targetPhrase);

      _currentScore = score;
      _currentFeedback = '$feedback\n$detailedFeedback';

      // Save attempt to database
      await _db.insertAttempt({
        'id': null,
        'phraseId': phraseId,
        'userTranscript': userPhrase,
        'targetPhrase': targetPhrase,
        'score': score,
        'result': feedback,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Save to mistakes if score is low
      if (score < 80) {
        await _db.insertMistake({
          'id': null,
          'phraseId': phraseId,
          'retryCount': 0,
          'lastAttempted': DateTime.now().toIso8601String(),
          'isResolved': 0,
        });
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error submitting attempt: $e');
    }
  }
}
