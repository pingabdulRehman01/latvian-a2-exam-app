class ScoringService {
  /// Calculate similarity score between two phrases (0-100)
  static int calculateScore(String userPhrase, String targetPhrase) {
    // Normalize phrases
    final userNormalized = _normalize(userPhrase);
    final targetNormalized = _normalize(targetPhrase);

    // Split into words
    final userWords = userNormalized.split(RegExp(r'\s+'));
    final targetWords = targetNormalized.split(RegExp(r'\s+'));

    // Calculate word match percentage
    int matchCount = 0;
    for (final word in userWords) {
      if (targetWords.contains(word)) {
        matchCount++;
      }
    }

    // Calculate score based on matches and total target words
    if (targetWords.isEmpty) return 0;
    
    // Penalize for missing words or wrong length ratio
    final lengthRatio = userWords.length / targetWords.length;
    final scoreraw = (matchCount / targetWords.length * 100).toInt();
    int penalty = 0;
    if (lengthRatio < 0.5) penalty = 20;
    else if (lengthRatio < 0.75) penalty = 10;
    final score = (scoreraw - penalty).clamp(0, 100);
    return score;
  }

  /// Get feedback based on score
  static String getScoreFeedback(int score) {
    if (score >= 80) {
      return 'Correct';
    } else if (score >= 60) {
      return 'Almost correct';
    } else {
      return 'Needs work';
    }
  }

  /// Get result color based on score
  static String getResultColor(int score) {
    if (score >= 80) {
      return 'green'; // Correct
    } else if (score >= 60) {
      return 'yellow'; // Almost correct
    } else {
      return 'red'; // Needs work
    }
  }

  /// Get detailed feedback
  static String getDetailedFeedback(String userPhrase, String targetPhrase) {
    final userNormalized = _normalize(userPhrase);
    final targetNormalized = _normalize(targetPhrase);

    final userWords = userNormalized.split(RegExp(r'\s+'));
    final targetWords = targetNormalized.split(RegExp(r'\s+'));

    final missingWords = <String>[];
    for (final word in targetWords) {
      if (!userWords.contains(word)) {
        missingWords.add(word);
      }
    }

    final extraWords = <String>[];
    for (final word in userWords) {
      if (!targetWords.contains(word)) {
        extraWords.add(word);
      }
    }

    String feedback = '';
    if (missingWords.isNotEmpty) {
      feedback += 'Missing: ${missingWords.join(", ")}. ';
    }
    if (extraWords.isNotEmpty) {
      feedback += 'Extra: ${extraWords.join(", ")}.';
    }
    if (feedback.isEmpty) {
      feedback = 'Perfect match!';
    }

    return feedback.trim();
  }

  /// Normalize text for comparison, preserving Latvian diacritics
  static String _normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9āčēģīķļņšūž\s]'), '') // Keep Latvian chars
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
