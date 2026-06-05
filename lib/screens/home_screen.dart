import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lesson_provider.dart';
import '../providers/mistake_provider.dart';
import '../services/progress_service.dart';
import 'lesson_list_screen.dart';
import 'mistake_review_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProgressService _progressService = ProgressService();
  int _totalAttempts = 0;
  int _accuracy = 0;
  int _mistakeCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _loadLessons();
    _loadMistakes();
  }

  Future<void> _loadProgress() async {
    final totalAttempts = await _progressService.getTotalAttempts();
    final accuracy = await _progressService.getAccuracyPercentage();
    final mistakeCount = await _progressService.getMistakesCount();

    setState(() {
      _totalAttempts = totalAttempts;
      _accuracy = accuracy;
      _mistakeCount = mistakeCount;
    });
  }

  Future<void> _loadLessons() async {
    await context.read<LessonProvider>().loadLessons();
  }

  Future<void> _loadMistakes() async {
    await context.read<MistakeProvider>().loadMistakes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latvian A2 Exam Practice'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Today\'s Progress',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Progress Cards
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildProgressCard(
                  'Total Attempts',
                  '$_totalAttempts',
                  Colors.blue,
                  Icons.repeat,
                ),
                _buildProgressCard(
                  'Accuracy',
                  '$_accuracy%',
                  Colors.green,
                  Icons.check_circle,
                ),
                _buildProgressCard(
                  'Mistakes',
                  '$_mistakeCount',
                  Colors.orange,
                  Icons.warning,
                ),
                _buildProgressCard(
                  'Progress',
                  '${((_totalAttempts / 30 * 100).toInt()).clamp(0, 100)}%',
                  Colors.purple,
                  Icons.trending_up,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Action Buttons
            const Text(
              'Learning',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              'Start Practice',
              'Begin today\'s lesson',
              Colors.blue,
              Icons.play_arrow,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LessonListScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              'Review Mistakes',
              'Practice weak phrases',
              Colors.orange,
              Icons.replay,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MistakeReviewScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    String subtitle,
    Color color,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
