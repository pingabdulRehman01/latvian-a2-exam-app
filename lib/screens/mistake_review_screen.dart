import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/phrase.dart';
import '../providers/mistake_provider.dart';
import 'practice_screen.dart';

class MistakeReviewScreen extends StatefulWidget {
  const MistakeReviewScreen({Key? key}) : super(key: key);

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
      appBar: AppBar(
        title: const Text('Review Mistakes'),
        centerTitle: true,
      ),
      body: Consumer<MistakeProvider>(
        builder: (context, mistakeProvider, child) {
          if (mistakeProvider.mistakes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.green[300],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No mistakes yet!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keep practicing to get better.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: mistakeProvider.mistakes.length,
            itemBuilder: (context, index) {
              final mistake = mistakeProvider.mistakes[index];
              return FutureBuilder<Phrase?>(
                future: mistakeProvider.getPhraseById(mistake.phraseId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  final phrase = snapshot.data!;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Latvian phrase
                          Text(
                            phrase.phraseLv,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // English translation
                          Text(
                            phrase.phraseEn,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Chip(
                                avatar: const Icon(
                                  Icons.repeat,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                                label: Text('${mistake.retryCount} retries'),
                                backgroundColor: Colors.orange[50],
                              ),
                              Text(
                                'Attempted: ${mistake.lastAttempted.toString().split('.')[0]}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Action buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () async {
                                  await mistakeProvider.removeMistake(phrase.id);
                                },
                                icon: const Icon(Icons.delete),
                                label: const Text('Remove'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PracticeScreen(
                                        lessonId: phrase.lessonId,
                                        lessonTitle: 'Retry Mistake',
                                      ),
                                    ),
                                  ).then((_) async {
                                    await mistakeProvider.updateRetryCount(
                                      phrase.id,
                                      mistake.retryCount + 1,
                                    );
                                  });
                                },
                                icon: const Icon(Icons.replay),
                                label: const Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
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
          );
        },
      ),
    );
  }
}
