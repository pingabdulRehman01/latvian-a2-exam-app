import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/phrase.dart';
import '../providers/lesson_provider.dart';
import '../providers/practice_provider.dart';
import '../services/speech_service.dart';
import '../services/scoring_service.dart';
import '../app_theme.dart';

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
  bool _isWordBankMode = true;
  int _lives = 5;

  // Word Bank states
  List<String> _wordBank = [];
  List<int> _selectedIndices = [];

  // Check state
  bool _answerChecked = false;
  bool _isCorrect = false;
  int _score = 0;

  // Index tracking
  Phrase? _lastPhrase;

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

  void _setupWordBank(Phrase phrase) {
    _selectedIndices.clear();
    _answerChecked = false;
    _isCorrect = false;
    _score = 0;

    // Get the target Latvian phrase and clean punctuation
    final cleanLv = phrase.phraseLv.replaceAll(RegExp(r'[.,!?:]'), '');
    final lvWords = cleanLv.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    // Distractor list of common Latvian words
    final distractors = ['un', 'ir', 'nav', 'tas', 'ar', 'es', 'tu', 'mēs', 'no', 'uz', 'arī', 'var'];

    final List<String> bank = [];
    bank.addAll(lvWords);

    // Add distractors to make the bank size at least 8
    for (final dist in distractors) {
      if (bank.length >= 8) break;
      final lowerDist = dist.toLowerCase();
      // Check if target phrase already contains the distractor
      bool contains = lvWords.any((w) => w.toLowerCase() == lowerDist);
      if (!contains) {
        bank.add(dist);
      }
    }

    bank.shuffle(Random());
    setState(() {
      _wordBank = bank;
    });
  }

  Future<void> _checkAnswer(Phrase phrase) async {
    String userPhrase = '';
    if (_isWordBankMode) {
      userPhrase = _selectedIndices.map((idx) => _wordBank[idx]).join(' ');
    } else {
      userPhrase = context.read<PracticeProvider>().userTranscript;
    }

    if (userPhrase.trim().isEmpty) return;

    final score = ScoringService.calculateScore(userPhrase, phrase.phraseLv);
    final isCorrect = score >= 80;

    setState(() {
      _score = score;
      _isCorrect = isCorrect;
      _answerChecked = true;
      if (!isCorrect) {
        _lives--;
      }
    });

    // Submit log attempt to db
    await context.read<PracticeProvider>().submitAttempt(
      phrase.id,
      userPhrase,
      phrase.phraseLv,
    );
  }

  void _onContinue() {
    if (_lives <= 0) {
      return;
    }
    setState(() {
      _answerChecked = false;
    });
    context.read<PracticeProvider>().setUserTranscript('');
    context.read<PracticeProvider>().nextPhrase();
  }

  @override
  void dispose() {
    _speechService.cancelListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LessonProvider, PracticeProvider>(
      builder: (context, lessonProvider, practiceProvider, child) {
        if (lessonProvider.currentPhrases.isEmpty) {
          if (lessonProvider.errorMessage != null) {
            return Scaffold(
              backgroundColor: kBackground,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline_rounded, color: kDanger, size: 56),
                      const SizedBox(height: 16),
                      Text(
                        lessonProvider.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: kTextDark, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => _loadPhrases(),
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: const Text('RETRY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimary),
              ),
            ),
          );
        }

        final phrases = lessonProvider.currentPhrases;
        final currentIndex = practiceProvider.currentPhraseIndex;

        // Lesson Complete state
        if (currentIndex >= phrases.length) {
          return _buildLessonComplete(phrases.length);
        }

        // Game Over state
        if (_lives <= 0) {
          return _buildGameOver();
        }

        final currentPhrase = phrases[currentIndex];

        // Trigger word bank setup on index change
        if (_lastPhrase != currentPhrase) {
          _lastPhrase = currentPhrase;
          // Set micro-delay to avoid build-phase state updates
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _setupWordBank(currentPhrase);
          });
        }

        final progress = phrases.isEmpty ? 0.0 : currentIndex / phrases.length;

        return Scaffold(
          backgroundColor: kBackground,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Status Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Exit
                      IconButton(
                        icon: const Icon(Icons.close, color: kTextDark, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      // Rounded Progress Bar
                      Expanded(
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: kBorder,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Stack(
                            children: [
                              FractionallySizedBox(
                                widthFactor: progress,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kPrimary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Streak Fire
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: kAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kAccent, width: 1),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_fire_department, color: kAccent, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '+3 Days',
                              style: TextStyle(
                                color: kTextDark,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Hearts left
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: kDanger.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kDanger, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.favorite, color: kDanger, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '$_lives',
                              style: const TextStyle(
                                color: kTextDark,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 2. Main Content Area (Mascot & Speak Bubble)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mascot & speech bubble row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const MascotWidget(),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SpeechBubble(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Translate this sentence into Latvian:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      currentPhrase.phraseEn,
                                      style: const TextStyle(
                                      color: kTextDark,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // 3. Interaction Zone
                        if (_isWordBankMode) ...[
                          // Word Bank Mode UI
                          // Drop zone
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(minHeight: 120),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: kCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: kBorder,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: _selectedIndices.isEmpty
                                ? Center(
                                    child: Text(
                                      'Tap words to translate',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : Wrap(
                                    spacing: 8.0,
                                    runSpacing: 4.0,
                                    children: List.generate(_selectedIndices.length, (index) {
                                      final wordIdx = _selectedIndices[index];
                                      final word = _wordBank[wordIdx];
                                      return _buildWordCapsule(
                                        text: word,
                                        onTap: _answerChecked
                                            ? () {}
                                            : () {
                                                setState(() {
                                                  _selectedIndices.removeAt(index);
                                                });
                                              },
                                      );
                                    }),
                                  ),
                          ),

                          const SizedBox(height: 32),

                          // Word capsules bank
                          Center(
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              alignment: WrapAlignment.center,
                              children: List.generate(_wordBank.length, (index) {
                                final word = _wordBank[index];
                                final isSelected = _selectedIndices.contains(index);

                                return _buildWordCapsule(
                                  text: word,
                                  isPlaceholder: isSelected,
                                  onTap: _answerChecked
                                      ? () {}
                                      : () {
                                          setState(() {
                                            if (!isSelected) {
                                              _selectedIndices.add(index);
                                            }
                                          });
                                        },
                                );
                              }),
                            ),
                          ),
                        ] else ...[
                          // Voice Mode UI
                          Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 24),
                                GestureDetector(
                                  onLongPress: _answerChecked ? null : _startListening,
                                  onLongPressEnd: _answerChecked ? null : (_) => _stopListening(),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: practiceProvider.isRecording
                                          ? kDanger
                                          : kPrimary,
                                      boxShadow: [
                                        BoxShadow(
                                          color: (practiceProvider.isRecording
                                                  ? kDanger
                                                  : kPrimary)
                                              .withValues(alpha: 0.3),
                                          spreadRadius: 6,
                                          blurRadius: 12,
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
                                const SizedBox(height: 16),
                                Text(
                                  practiceProvider.isRecording
                                      ? 'Listening... Release to stop'
                                      : 'Hold button to record voice',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                // Display spoken transcript
                                if (practiceProvider.userTranscript.isNotEmpty)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: kBorder,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Speech Transcript:',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          practiceProvider.userTranscript,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: kTextDark,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Toggle Mode button
                        if (!_answerChecked)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _isWordBankMode = !_isWordBankMode;
                                    _selectedIndices.clear();
                                    _speechService.cancelListening();
                                    practiceProvider.setUserTranscript('');
                                  });
                                },
                                icon: Icon(
                                  _isWordBankMode ? Icons.mic : Icons.grid_view,
                                  color: kPrimary,
                                  size: 18,
                                ),
                                label: Text(
                                  _isWordBankMode ? 'Switch to Voice Mode' : 'Switch to Word Bank',
                                  style: const TextStyle(
                                    color: kPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                // 4. Bottom Navigation & Action Bar
                _buildBottomActionBar(currentPhrase, practiceProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWordCapsule({
    required String text,
    required VoidCallback onTap,
    bool isPlaceholder = false,
  }) {
    if (isPlaceholder) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(                                  color: kBorder,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.transparent, // Keeps capsule dimensions stable
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(                              color: kBorder, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: kTextDark,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(Phrase currentPhrase, PracticeProvider practiceProvider) {
    bool canCheck = false;
    if (_isWordBankMode) {
      canCheck = _selectedIndices.isNotEmpty;
    } else {
      canCheck = practiceProvider.userTranscript.isNotEmpty;
    }

    if (!_answerChecked) {
      // 1. Initial State before checking
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: kBorder, width: 1.5),
          ),
        ),
        child: ElevatedButton(
          onPressed: canCheck ? () => _checkAnswer(currentPhrase) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimary,
            disabledBackgroundColor: kBorder,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            'CHECK ANSWER',
            style: TextStyle(
              color: canCheck ? Colors.white : Colors.grey[500],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    // 2. State after checking (Success or Error notification banner)
    final bannerColor = _isCorrect
        ? kSuccess.withValues(alpha: 0.15)
        : kDanger.withValues(alpha: 0.15);
    final iconColor = _isCorrect ? kSuccess : kDanger;
    final buttonColor = _isCorrect ? kSuccess : kDanger;
    final grammarRule = context.read<LessonProvider>().currentGrammarRule;

    return Container(
      width: double.infinity,
      color: bannerColor,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isCorrect ? Icons.check_circle : Icons.error,
                  color: iconColor,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  _isCorrect ? 'Excellent! ($_score%)' : 'Incorrect ($_score%)',
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (!_isCorrect) ...[
              Text(
                'Correct translation:',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                currentPhrase.phraseLv,
                style: const TextStyle(
                  color: kTextDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
            ],
            // ── Grammar hint card ──────────────────────────────────
            if (grammarRule != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: kPrimary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kPrimary.withValues(alpha: 0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: kPrimary, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          grammarRule.title,
                          style: const TextStyle(
                            color: kPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      grammarRule.explanation,
                      style: TextStyle(
                        color: kTextDark.withValues(alpha: 0.85),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      grammarRule.examples.join('  •  '),
                      style: TextStyle(
                        color: kTextGrey,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            ElevatedButton(
              onPressed: _onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'CONTINUE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonComplete(int totalPhrases) {
    return Scaffold(
      body: Container(
        color: kBackground,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events,
                size: 100,
                color: kAccent,
              ),
              const SizedBox(height: 24),
              const Text(
                'Lesson Complete!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Fantastic work! You completed all $totalPhrases phrases in this lesson with $_lives/5 lives remaining.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'BACK TO LESSONS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOver() {
    return Scaffold(
      body: Container(
        color: kBackground,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.heart_broken,
                size: 100,
                color: kDanger,
              ),
              const SizedBox(height: 24),
              const Text(
                'No Lives Left!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Don't worry, mistakes are part of learning! Would you like to try again?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _lives = 5;
                    });
                    context.read<PracticeProvider>().resetPhraseIndex();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'RETRY LESSON',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Exit Lesson',
                    style: TextStyle(
                      color: kPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MascotWidget extends StatelessWidget {
  const MascotWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: kSuccess.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: kSuccess, width: 1.5),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Body
            Container(
              width: 40,
              height: 44,
              decoration: BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            // Face
            Positioned(
              top: 12,
              child: Container(
                width: 30,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            // Eye left
            Positioned(
              top: 18,
              left: 21,
              child: Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1C1E),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Eye right
            Positioned(
              top: 18,
              right: 21,
              child: Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1C1E),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Nose / Beak
            Positioned(
              top: 22,
              child: CustomPaint(
                size: const Size(6, 4),
                painter: TrianglePainter(color: kAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SpeechBubble extends StatelessWidget {
  final Widget child;
  const SpeechBubble({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SpeechBubblePainter(),
      child: Container(
        padding: const EdgeInsets.only(left: 28, top: 16, right: 16, bottom: 16),
        child: child,
      ),
    );
  }
}

class SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = kBorder
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(15, 12)
      // Triangle pointer
      ..lineTo(5, 18)
      ..lineTo(15, 24)
      // Body card
      ..lineTo(15, size.height - 12)
      ..quadraticBezierTo(15, size.height, 27, size.height)
      ..lineTo(size.width - 12, size.height)
      ..quadraticBezierTo(size.width, size.height, size.width, size.height - 12)
      ..lineTo(size.width, 12)
      ..quadraticBezierTo(size.width, 0, size.width - 12, 0)
      ..lineTo(27, 0)
      ..quadraticBezierTo(15, 0, 15, 12)
      ..close();

    canvas.drawPath(path.shift(const Offset(0, 3)), shadowPaint);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
