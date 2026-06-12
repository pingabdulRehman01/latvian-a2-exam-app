import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  /// Initialize TTS with Latvian language settings
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await _tts.setLanguage('lv-LV');
      await _tts.setSpeechRate(0.45); // Slower for learners
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);

      // Listen for completion
      _tts.setCompletionHandler(() {
        _isPlaying = false;
      });

      _isInitialized = true;
      debugPrint('TTS initialized for Latvian');
    } catch (e) {
      debugPrint('Error initializing TTS: $e');
    }
  }

  /// Speak Latvian text aloud
  Future<void> speak(String text) async {
    try {
      if (!_isInitialized) await initialize();
      _isPlaying = true;
      await _tts.speak(text);
    } catch (e) {
      debugPrint('Error speaking text: $e');
      _isPlaying = false;
    }
  }

  /// Stop current speech
  Future<void> stop() async {
    try {
      await _tts.stop();
      _isPlaying = false;
    } catch (e) {
      debugPrint('Error stopping TTS: $e');
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    await stop();
    _tts.setCompletionHandler(() {});
  }
}
