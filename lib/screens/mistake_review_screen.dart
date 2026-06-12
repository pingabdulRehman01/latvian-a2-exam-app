import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/phrase.dart';
import '../providers/mistake_provider.dart';
import '../app_theme.dart';
import 'practice_screen.dart';

class MistakeReviewScreen extends StatefulWidget {
  const MistakeReviewScreen({super.key});

  @override
  State<MistakeReviewScreen> createState() => _MistakeReviewScreenState();
}

class _MistakeReviewScreenState extends State<MistakeReviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MistakeProvider>().loadMistakes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Review Mistakes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: kPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: kBorder),
        ),
      ),
      body: Consumer<MistakeProvider>(
        builder: (context, mistakeProvider, _) {
          if (mistakeProvider.mistakes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF30D158).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_rounded,
                          color: Color(0xFF30D158), size: 52),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Clean Slate! 🎉',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: kTextDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'No mistakes to review.\nKeep up the great work!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: kTextGrey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              // Summary banner
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kDanger.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: kDanger.withValues(alpha: 0.25), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: kDanger, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      '${mistakeProvider.mistakes.length} phrase${mistakeProvider.mistakes.length == 1 ? '' : 's'} to review',
                      style: const TextStyle(
                        color: kTextDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: mistakeProvider.mistakes.length,
                  itemBuilder: (context, index) {
                    final mistake = mistakeProvider.mistakes[index];
                    return FutureBuilder<Phrase?>(
                      future: mistakeProvider.getPhraseById(mistake.phraseId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox.shrink();
                        final phrase = snapshot.data!;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: kCard,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: kBorder, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Latvian phrase
                                Text(
                                  phrase.phraseLv,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // English translation
                                Text(
                                  phrase.phraseEn,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: kTextGrey,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const Divider(color: kBorder, height: 1),
                                const SizedBox(height: 14),
                                // Stats + actions row
                                Row(
                                  children: [
                                    // Retry count chip
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: kAccent.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.replay_rounded,
                                              size: 13, color: kAccent),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${mistake.retryCount} retries',
                                            style: const TextStyle(
                                              color: kTextDark,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    // Remove button
                                    TextButton.icon(
                                      onPressed: () async {
                                        await mistakeProvider
                                            .removeMistake(phrase.id);
                                      },
                                      icon: const Icon(Icons.delete_outline,
                                          size: 16),
                                      label: const Text('Remove'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: kDanger,
                                        textStyle: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    // Retry button
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PracticeScreen(
                                              lessonId: phrase.lessonId,
                                              lessonTitle: 'Retry Mistake',
                                            ),
                                          ),
                                        ).then((_) async {
                                          await mistakeProvider
                                              .updateRetryCount(
                                            phrase.id,
                                            mistake.retryCount + 1,
                                          );
                                        });
                                      },
                                      icon: const Icon(Icons.play_arrow_rounded,
                                          size: 16),
                                      label: const Text('Retry'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kPrimary,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        visualDensity: VisualDensity.compact,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
