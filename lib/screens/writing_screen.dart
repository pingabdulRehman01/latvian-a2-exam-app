import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/writing_provider.dart';
import '../services/scoring_service.dart';
import '../app_theme.dart';

class WritingScreen extends StatefulWidget {
  const WritingScreen({super.key});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _showModelAnswer = false;
  bool _showPromptLv = false;
  int? _score;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    context.read<WritingProvider>().loadPrompts();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Latvian special characters for the helper row
  static const List<String> _lvChars = [
    'ā', 'č', 'ē', 'ģ', 'ī', 'ķ', 'ļ', 'ņ', 'š', 'ū', 'ž',
    'Ā', 'Č', 'Ē', 'Ģ', 'Ī', 'Ķ', 'Ļ', 'Ņ', 'Š', 'Ū', 'Ž',
  ];

  void _insertChar(String char) {
    final text = _controller.text;
    final selection = _controller.selection;
    final cursorPos = selection.baseOffset;
    if (cursorPos < 0) {
      _controller.text = text + char;
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
    } else {
      final newText = text.substring(0, cursorPos) + char + text.substring(cursorPos);
      _controller.text = newText;
      _controller.selection = TextSelection.collapsed(offset: cursorPos + 1);
    }
  }

  void _saveAndCheck() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final provider = context.read<WritingProvider>();
    final prompt = provider.currentPrompt;
    if (prompt == null) return;

    provider.saveWriting(text);

    final score = ScoringService.calculateScore(text, prompt.modelAnswer);
    final feedback = ScoringService.getDetailedFeedback(text, prompt.modelAnswer);

    setState(() {
      _score = score;
      _feedback = feedback;
    });
  }

  void _nextPrompt() {
    setState(() {
      _showModelAnswer = false;
      _showPromptLv = false;
      _score = null;
      _feedback = null;
    });
    _controller.clear();
    context.read<WritingProvider>().nextPrompt();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WritingProvider>(
      builder: (context, provider, child) {
        if (provider.prompts.isEmpty) {
          if (provider.errorMessage != null) {
            return Scaffold(
              backgroundColor: kBackground,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: const Text('Writing Practice'),
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
                        onPressed: () => provider.loadPrompts(),
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
              title: const Text('Writing Practice'),
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

        final prompt = provider.currentPrompt!;
        final progress = provider.currentIndex / provider.totalPrompts;

        return Scaffold(
          backgroundColor: kBackground,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Writing (${provider.currentIndex + 1}/${provider.totalPrompts})'),
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
                    prompt.topic,
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
                  prompt.title,
                  style: const TextStyle(
                    color: kTextDark,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // ── Prompt card ────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5E5CE6), Color(0xFF7B6FE8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.edit_note_rounded,
                              color: Colors.white, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Write in Latvian:',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        prompt.promptEn,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () {
                          setState(() => _showPromptLv = !_showPromptLv);
                        },
                        icon: Icon(
                          _showPromptLv
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white70,
                          size: 16,
                        ),
                        label: Text(
                          _showPromptLv ? 'Hide Latvian prompt' : 'Show in Latvian',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (_showPromptLv) ...[
                        const SizedBox(height: 4),
                        Text(
                          prompt.promptLv,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Vocabulary card ────────────────────────────
                if (prompt.vocabulary.isNotEmpty) ...[
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
                              'Helpful Vocabulary',
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
                          children: prompt.vocabulary.map((word) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: kCard,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: kAccent.withValues(alpha: 0.3)),
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

                // ── Latvian character helper ─────────────────
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  decoration: BoxDecoration(
                    color: kPrimary.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Wrap(
                    spacing: 2,
                    runSpacing: 2,
                    alignment: WrapAlignment.center,
                    children: _lvChars.map((char) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () => _insertChar(char),
                          child: Container(
                            width: 32,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: kCard,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: kBorder.withValues(alpha: 0.5)),
                            ),
                            child: Text(
                              char,
                              style: const TextStyle(
                                fontSize: 13,
                                color: kTextDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),

                // ── Text input area ───────────────────────────
                const Text(
                  'Your Latvian text:',
                  style: TextStyle(
                    color: kTextDark,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: kCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kBorder),
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: 6,
                    minLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Type your Latvian translation here...',
                      hintStyle: TextStyle(
                        color: kTextGrey.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    style: const TextStyle(
                      color: kTextDark,
                      fontSize: 15,
                      height: 1.5,
                    ),
                    textInputAction: TextInputAction.newline,
                  ),
                ),

                const SizedBox(height: 20),

                // ── Check button ──────────────────────────────
                if (_score == null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _controller.text.trim().isEmpty
                          ? null
                          : _saveAndCheck,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        disabledBackgroundColor: kBorder,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'CHECK YOUR WRITING',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],

                // ── Score and feedback ────────────────────────
                if (_score != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _score! >= 60
                          ? kSuccess.withValues(alpha: 0.1)
                          : kDanger.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _score! >= 60
                            ? kSuccess.withValues(alpha: 0.3)
                            : kDanger.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _score! >= 60
                                  ? Icons.check_circle_rounded
                                  : Icons.rate_review_rounded,
                              color: _score! >= 60 ? kSuccess : kDanger,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _score! >= 80
                                      ? 'Great job!'
                                      : _score! >= 60
                                          ? 'Good effort!'
                                          : 'Keep trying!',
                                  style: TextStyle(
                                    color: _score! >= 60 ? kSuccess : kDanger,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Match score: $_score%',
                                  style: TextStyle(
                                    color: _score! >= 60 ? kSuccess : kDanger,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (_feedback != null && _feedback!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Divider(color: kBorder, height: 1),
                          const SizedBox(height: 12),
                          Text(
                            'Feedback: $_feedback',
                            style: const TextStyle(
                              color: kTextDark,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Toggle model answer ──────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            setState(
                                () => _showModelAnswer = !_showModelAnswer);
                          },
                          icon: Icon(
                            _showModelAnswer
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: kTextGrey,
                            size: 18,
                          ),
                          label: Text(
                            _showModelAnswer
                                ? 'Hide model answer'
                                : 'Show model answer',
                            style:
                                const TextStyle(color: kTextGrey, fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (_showModelAnswer) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kSuccess.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: kSuccess.withValues(alpha: 0.25)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.lightbulb_outline,
                                  color: kSuccess, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Model answer:',
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
                            prompt.modelAnswer,
                            style: const TextStyle(
                              color: kTextDark,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Next button ──────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPrompt,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        provider.currentIndex < provider.totalPrompts - 1
                            ? 'NEXT PROMPT'
                            : 'FINISH',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
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

  Widget _buildCompletionScreen(WritingProvider provider) {
    final prompts = provider.allPrompts;
    final writings = provider.userWritings;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Writing Complete'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: kPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Header ────────────────────────────────────────────
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: kSuccess.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    color: kPrimary,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'All Prompts Complete! ✍️',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kTextDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You completed all ${provider.totalPrompts} writing prompts.\nReview your answers below and compare with model answers.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: kTextGrey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── Writing review cards ────────────────────────────
          for (int i = 0; i < prompts.length; i++) ...[
            Container(
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: kPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '#${i + 1}',
                          style: const TextStyle(
                            color: kPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          prompts[i].title,
                          style: const TextStyle(
                            color: kTextDark,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    prompts[i].promptEn,
                    style: const TextStyle(
                      color: kTextGrey,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: kBorder, height: 1),
                  const SizedBox(height: 10),

                  // User's answer
                  const Text(
                    'Your answer:',
                    style: TextStyle(
                      color: kPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kPrimary.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      writings[i]?.isNotEmpty == true
                          ? writings[i]!
                          : '(not answered)',
                      style: TextStyle(
                        color: writings[i]?.isNotEmpty == true
                            ? kTextDark
                            : kTextGrey,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Model answer
                  const Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          color: kSuccess, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Model answer:',
                        style: TextStyle(
                          color: kSuccess,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kSuccess.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      prompts[i].modelAnswer,
                      style: const TextStyle(
                        color: kTextDark,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // ── Action buttons ───────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                provider.reset();
                provider.loadPrompts();
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
