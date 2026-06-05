import '../database/database_helper.dart';

class ProgressService {
  final DatabaseHelper _db = DatabaseHelper.instance;

  /// Get total attempts count
  Future<int> getTotalAttempts() async {
    return await _db.getAttemptCount();
  }

  /// Get average score
  Future<double> getAverageScore() async {
    return await _db.getAverageScore();
  }

  /// Get lessons completed count
  Future<int> getCompletedLessonsCount() async {
    final lessons = await _db.getAllLessons();
    return lessons.where((lesson) => lesson['isCompleted'] == 1).length;
  }

  /// Calculate accuracy percentage
  Future<int> getAccuracyPercentage() async {
    final average = await getAverageScore();
    return average.toInt();
  }

  /// Get mistakes count
  Future<int> getMistakesCount() async {
    final mistakes = await _db.getAllMistakes();
    return mistakes.length;
  }
}
