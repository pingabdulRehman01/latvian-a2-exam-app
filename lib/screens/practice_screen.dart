import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/phrase.dart';
import '../providers/lesson_provider.dart';
import '../providers/practice_provider.dart';
import '../services/speech_service.dart';
import '../services/scoring_service.dart';

class PracticeScreen extends StatefulWidget {
  final int lessonId;
  final String lessonTitle;

  const PracticeScreen({
    Key? key,
    required this.lessonId,
    required this.lessonTitle,
  }) : super(key: key);

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late SpeechService _speechService;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _speechService = SpeechService();
    _initializeSpeech();
    _loadPhrases();
  }

  Future<void> _initializeSpeech() async {
    await _speechService.initializeSpeech();
  }

  Future<void> _loadPhrases() async {
    await context.read<LessonProvider>().loadPhrasesForLesson(widget.lessonId);
    context.read<PracticeProvider>().resetPhraseIndex();
  }

  Future<void> _startListening() async {
    context.read<PracticeProvider>().setRecordingState(true);
    await _speechService.startListening();
  }

  Future<void> _stopListening() async {
    await _speechService.stopListening();
    context.read<PracticeProvider>().setRecordingState(false);
    context.read<PracticeProvider>().setUserTranscript(_speechService.lastWords);
  }

  Future<void> _submitAnswer(
    int phraseId,
    String userPhrase,
    String targetPhrase,
  ) async {
    if (userPhrase.isNotEmpty) {
      await context.read<PracticeProvider>().submitAttempt(
        phraseId,
        userPhrase,
        targetPhrase,
      );
      setState(() {
        _isAnswered = true;
      });
    }
  }

  @override
  void dispose() {
    _speechService.cancelListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lessonTitle),
        centerTitle: true,
      ),
      body: Consumer2<LessonProvider, PracticeProvider>(
        builder: (context, lessonProvider, practiceProvider, child) {
          if (lessonProvider.currentPhrases.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final phrases = lessonProvider.currentPhrases;
          final currentIndex = practiceProvider.currentPhraseIndex;

          if (currentIndex >= phrases.length) {
            return _buildLessonComplete();
          }

          final currentPhrase = phrases[currentIndex];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                LinearProgressIndicator(
                  value: (currentIndex + 1) / phrases.length,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 16),

                // Phrase counter
                Text(
                  'Phrase ${currentIndex + 1} of ${phrases.length}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),

                // Latvian phrase
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Say this phrase:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentPhrase.phraseLv,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // English translation
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Meaning:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentPhrase.phraseEn,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Microphone button
                if (!_isAnswered)
                  Center(
                    child: GestureDetector(
                      onLongPress: _startListening,
                      onLongPressEnd: (_) => _stopListening(),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: practiceProvider.isRecording ? Colors.red : Colors.blue,
                          boxShadow: [
                            BoxShadow(
                              color: (practiceProvider.isRecording ? Colors.red : Colors.blue)
                                  .withOpacity(0.3),
                              spreadRadius: 4,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          practiceProvider.isRecording ? Icons.stop : Icons.mic,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                if (!_isAnswered && practiceProvider.userTranscript.isNotEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'You said:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              practiceProvider.userTranscript,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _submitAnswer(
                          currentPhrase.id,
                          practiceProvider.userTranscript,
                          currentPhrase.phraseLv,
                        ),
                        icon: const Icon(Icons.check),
                        label: const Text('Check Answer'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),

                // Feedback
                if (_isAnswered)
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildFeedbackBox(practiceProvider.currentScore),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Feedback:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              practiceProvider.currentFeedback,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isAnswered = false;
                              });
                              context.read<PracticeProvider>().previousPhrase();
                            },
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Previous'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isAnswered = false;
                              });
                              context.read<PracticeProvider>().nextPhrase();
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Next'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedbackBox(int score) {
    final feedback = ScoringService.getScoreFeedback(score);
    final color = _getScoreColor(score);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Icon(
            score >= 80 ? Icons.check_circle : score >= 60 ? Icons.info : Icons.close,
            color: color,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            feedback,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Score: $score%',
            style: TextStyle(
              fontSize: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) {
      return Colors.green;
    } else if (score >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _buildLessonComplete() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            size: 80,
            color: Colors.green,
          ),
          const SizedBox(height: 24),
          const Text(
            'Lesson Complete!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Great job! You\'ve completed all phrases in this lesson.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Back to Lessons'),
          ),
        ],
      ),
    );
  }
}
