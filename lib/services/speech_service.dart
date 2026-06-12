import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _lastWords = '';
  double _speechConfidence = 0.0;

  bool get isListening => _isListening;
  String get lastWords => _lastWords;
  double get speechConfidence => _speechConfidence;

  Future<bool> initializeSpeech() async {
    try {
      bool available = await _speechToText.initialize(
        onError: (error) => print('Error: $error'),
        onStatus: (status) => print('Status: $status'),
      );
      return available;
    } catch (e) {
      print('Error initializing speech: $e');
      return false;
    }
  }

  Future<void> startListening() async {
    if (!_isListening) {
      bool available = await initializeSpeech();
      if (available) {
        _isListening = true;
        _speechToText.listen(
          onResult: (result) {
            _lastWords = result.recognizedWords;
            _speechConfidence = result.confidence;
          },
          localeId: 'lv_LV', // Latvian language
        );
      }
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      _isListening = false;
    }
  }

  Future<void> cancelListening() async {
    await _speechToText.cancel();
    _isListening = false;
    _lastWords = '';
    _speechConfidence = 0.0;
  }
}
