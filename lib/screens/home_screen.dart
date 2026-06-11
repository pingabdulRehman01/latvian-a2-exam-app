import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lesson_provider.dart';
import '../providers/mistake_provider.dart';
import '../services/progress_service.dart';
import 'lesson_list_screen.dart';
import 'mistake_review_screen.dart';

// App-wide design tokens
const kPrimary = Color(0xFF5E5CE6);
const kSuccess = Color(0xFF30D158);
const kAccent = Color(0xFFFFD60A);
const kDanger = Color(0xFFFF453A);
const kBackground = Color(0xFFF9FAFB);
const kCard = Colors.white;
const kBorder = Color(0xFFE5E5EA);
const kTextDark = Color(0xFF1C1C1E);
const kTextGrey = Color(0xFF8E8E93);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
    if (mounted) {
      setState(() {
        _totalAttempts = totalAttempts;
        _accuracy = accuracy;
        _mistakeCount = mistakeCount;
      });
    }
  }

  Future<void> _loadLessons() async {
    await context.read<LessonProvider>().loadLessons();
  }

  Future<void> _loadMistakes() async {
    await context.read<MistakeProvider>().loadMistakes();
  }

  @override
  Widget build(BuildContext context) {
    final overallProgress = ((_totalAttempts / 30 * 100).toInt()).clamp(0, 100);

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top greeting row ──────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good evening! 👋',
                        style: TextStyle(
                          color: kTextGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Latvian A2',
                        style: TextStyle(
                          color: kTextDark,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Streak badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: kAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kAccent, width: 1),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_fire_department,
                            color: kAccent, size: 18),
                        SizedBox(width: 4),
                        Text(
                          '3 Day Streak',
                          style: TextStyle(
                            color: kTextDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Overall progress card ─────────────────────
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
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.emoji_events, color: kAccent, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Overall Progress',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$overallProgress%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: overallProgress / 100,
                        minHeight: 8,
                        backgroundColor: Colors.white.withValues(alpha: 0.25),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(kAccent),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_totalAttempts of 30 phrases attempted',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Stats row ─────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.check_circle_outline,
                      iconColor: kSuccess,
                      label: 'Accuracy',
                      value: '$_accuracy%',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.repeat_rounded,
                      iconColor: kPrimary,
                      label: 'Attempts',
                      value: '$_totalAttempts',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.error_outline_rounded,
                      iconColor: kDanger,
                      label: 'Mistakes',
                      value: '$_mistakeCount',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Section title ─────────────────────────────
              const Text(
                'Continue Learning',
                style: TextStyle(
                  color: kTextDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              // ── Start Practice button ─────────────────────
              _buildActionCard(
                title: 'Start Practice',
                subtitle: 'Translate Latvian phrases',
                icon: Icons.play_circle_fill_rounded,
                iconBg: kPrimary,
                arrowColor: kPrimary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LessonListScreen()),
                ),
              ),

              const SizedBox(height: 12),

              // ── Review Mistakes button ────────────────────
              _buildActionCard(
                title: 'Review Mistakes',
                subtitle: 'Practice your weak phrases',
                icon: Icons.replay_circle_filled_rounded,
                iconBg: kDanger,
                arrowColor: kDanger,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MistakeReviewScreen()),
                ),
              ),

              const SizedBox(height: 28),

              // ── Tip card ──────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kSuccess.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: kSuccess.withValues(alpha: 0.3), width: 1),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: kSuccess, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tip: Practice for 10 minutes daily to hit A2 fluency in 10 days!',
                        style: TextStyle(
                          color: kTextDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorder, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: iconColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: kTextGrey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color arrowColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconBg, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: kTextDark,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: kTextGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: arrowColor, size: 24),
          ],
        ),
      ),
    );
  }
}
