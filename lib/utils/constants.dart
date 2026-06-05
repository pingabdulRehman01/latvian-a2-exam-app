class AppConstants {
  // Database
  static const String dbName = 'latvian_a2.db';
  static const int dbVersion = 1;

  // Tables
  static const String lessonsTable = 'lessons';
  static const String phrasesTable = 'phrases';
  static const String attemptsTable = 'attempts';
  static const String mistakesTable = 'mistakes';

  // Scoring thresholds
  static const int scoreCorrect = 80; // 80-100%
  static const int scoreAlmostCorrect = 60; // 60-79%
  // Below 60% = Needs work

  // Total lessons
  static const int totalLessons = 10;
}
