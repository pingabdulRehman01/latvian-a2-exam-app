import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reading_provider.dart';
import '../app_theme.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  bool _showTranslation = false;
  bool _answersSubmitted = false;
  int _passageScore = 0;

  @override
  void initState() {
    super.initState();
    context.read<ReadingProvider>().loadPassages();
  }

  void _submitAnswers() {
    final provider = context.read<ReadingProvider>();
    final passage = provider.currentPassage;
    if (passage == null) return;

    int correct = 0;
    for (int i = 0; i < passage.questions.length; i++) {
      final selected = provider.getSelectedAnswer(i);
      if (selected != null && selected == passage.questions[i].correctIndex) {
        correct++;
      }
    }

    setState(() {
      _passageScore = (correct / passage.questions.length * 100).round();
      _answersSubmitted = true;
    });

    provider.checkCurrentPassage();
  }

  void _nextPassage() {
    setState(() {
      _showTranslation = false;
      _answersSubmitted = false;
      _passageScore = 0;
    });
    context.read<ReadingProvider>().nextPassage();
  }

  void _retryPassage() {
    setState(() {
      _answersSubmitted = false;
      _passageScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadingProvider>(
      builder: (context, provider, child) {
        if (provider.passages.isEmpty) {
          if (provider.errorMessage != null) {
            return Scaffold(
              backgroundColor: kBackground,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: const Text('Reading Practice'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPrimary, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline_rounded, color: kDanger, size: 56),
                      const SizedBox(height: 16),
                      Text(
                        provider.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: kTextDark, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => provider.loadPassages(),
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
          return Scaffold(
            backgroundColor: kBackground,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text('Reading Practice'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: kPrimary, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimary),
              ),
            ),
          );
        }

        if (provider.isCompleted) {
          return _buildCompletionScreen(provider);
        }

        final passage = provider.currentPassage!;
        final progress = provider.currentIndex / provider.totalPassages;

        return Scaffold(
          backgroundColor: kBackground,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Reading (${provider.currentIndex + 1}/${provider.totalPassages})'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: kPrimary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(6),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: kBorder,
                valueColor: const AlwaysStoppedAnimation<Color>(kPrimary),
                minHeight: 4,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Topic chip ─────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: kPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    passage.topic,
                    style: const TextStyle(
                      color: kPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Title ──────────────────────────────────────
                Text(
                  passage.title,
                  style: const TextStyle(
                    color: kTextDark,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // ── Latvian text card ──────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kPrimary.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimary.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.menu_book_rounded,
                              color: kPrimary, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Read the text below:',
                            style: TextStyle(
                              color: kPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        passage.textLv,
                        style: const TextStyle(
                          color: kTextDark,
                          fontSize: 15,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Show translation toggle ────────────────────
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() => _showTranslation = !_showTranslation);
                        },
                        icon: Icon(
                          _showTranslation
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: kTextGrey,
                          size: 18,
                        ),
                        label: Text(
                          _showTranslation ? 'Hide translation' : 'Show translation',
                          style: const TextStyle(color: kTextGrey, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),

                if (_showTranslation) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kSuccess.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kSuccess.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.translate, color: kSuccess, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'English translation:',
                              style: TextStyle(
                                color: kSuccess,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          passage.textEn,
                          style: const TextStyle(
                            color: kTextDark,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ] else ...[
                  const SizedBox(height: 8),
                ],

                // ── Vocabulary card ────────────────────────────
                if (passage.vocabulary.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: kAccent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kAccent.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.spellcheck, color: kAccent, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Key Vocabulary',
                              style: TextStyle(
                                color: kAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: passage.vocabulary.map((word) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: kCard,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: kAccent.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                word,
                                style: const TextStyle(
                                  color: kTextDark,
                                  fontSize: 11,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // ── Questions section ──────────────────────────
                if (!_answersSubmitted) ...[
                  const Text(
                    'Comprehension Questions',
                    style: TextStyle(
                      color: kTextDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...List.generate(passage.questions.length, (qIndex) {
                    final question = passage.questions[qIndex];
                    final selected = provider.getSelectedAnswer(qIndex);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${qIndex + 1}. ${question.question}',
                            style: const TextStyle(
                              color: kTextDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...List.generate(question.options.length, (oIndex) {
                            final isSelected = selected == oIndex;
                            return GestureDetector(
                              onTap: () => provider.selectAnswer(qIndex, oIndex),
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? kPrimary.withValues(alpha: 0.1)
                                      : kBackground,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? kPrimary : kBorder,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? kPrimary
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected ? kPrimary : kTextGrey,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(Icons.check,
                                              size: 16, color: Colors.white)
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        question.options[oIndex],
                                        style: TextStyle(
                                          color: isSelected ? kPrimary : kTextDark,
                                          fontSize: 13,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),
                ],

                // ── After submission: results ──────────────────
                if (_answersSubmitted) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _passageScore >= 80
                          ? kSuccess.withValues(alpha: 0.1)
                          : kDanger.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _passageScore >= 80
                            ? kSuccess.withValues(alpha: 0.3)
                            : kDanger.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _passageScore >= 80
                              ? Icons.check_circle_rounded
                              : Icons.rate_review_rounded,
                          color: _passageScore >= 80 ? kSuccess : kDanger,
                          size: 36,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _passageScore >= 80
                                    ? 'Great reading!'
                                    : 'Need more practice',
                                style: TextStyle(
                                  color: _passageScore >= 80 ? kSuccess : kDanger,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$_passageScore% correct',
                                style: TextStyle(
                                  color: _passageScore >= 80 ? kSuccess : kDanger,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Review your answers:',
                    style: TextStyle(
                      color: kTextDark,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(passage.questions.length, (qIndex) {
                    final question = passage.questions[qIndex];
                    final selected = provider.getSelectedAnswer(qIndex);
                    final isCorrect = selected == question.correctIndex;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: kCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCorrect
                              ? kSuccess.withValues(alpha: 0.5)
                              : kDanger.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isCorrect
                                    ? Icons.check_circle
                                    : Icons.cancel_rounded,
                                color: isCorrect ? kSuccess : kDanger,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  question.question,
                                  style: const TextStyle(
                                    color: kTextDark,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your answer: ${selected != null ? question.options[selected] : "Not answered"}',
                            style: TextStyle(
                              color: isCorrect ? kSuccess : kDanger,
                              fontSize: 12,
                            ),
                          ),
                          if (!isCorrect) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Correct: ${question.options[question.correctIndex]}',
                              style: const TextStyle(
                                color: kSuccess,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],

                const SizedBox(height: 20),

                // ── Action buttons ─────────────────────────────
                if (!_answersSubmitted) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        bool hasAnswer = false;
                        for (int i = 0; i < passage.questions.length; i++) {
                          if (provider.getSelectedAnswer(i) != null) {
                            hasAnswer = true;
                            break;
                          }
                        }
                        if (!hasAnswer) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please answer at least one question!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                        _submitAnswers();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'SUBMIT ANSWERS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _retryPassage,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: kPrimary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'RETRY',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _nextPassage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            provider.currentIndex < provider.totalPassages - 1
                                ? 'NEXT'
                                : 'FINISH',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletionScreen(ReadingProvider provider) {
    final totalQ = provider.totalQuestionsAnswered;
    final correct = provider.correctCount;
    final overallScore = totalQ > 0 ? (correct / totalQ * 100).round() : 0;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Reading Complete'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: kPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: overallScore >= 75
                      ? kSuccess.withValues(alpha: 0.12)
                      : kAccent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: overallScore >= 75 ? kSuccess : kAccent,
                  size: 52,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                overallScore >= 75 ? 'Excellent Reading! 📖' : 'Keep Reading! 📖',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You answered $correct out of $totalQ questions correctly',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: kTextGrey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kBorder),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Overall Score',
                      style: TextStyle(
                        color: kTextGrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$overallScore%',
                      style: TextStyle(
                        color: overallScore >= 75 ? kSuccess : kAccent,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: overallScore / 100,
                        minHeight: 8,
                        backgroundColor: kBorder,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          overallScore >= 75 ? kSuccess : kAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      overallScore >= 75
                          ? 'Passed! Ready for the A2 exam 🎉'
                          : 'A passing score is 75% — keep trying!',
                      style: TextStyle(
                        color: overallScore >= 75 ? kSuccess : kTextGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    provider.reset();
                    provider.loadPassages();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'TRY AGAIN',
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
                    'Back to Home',
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
