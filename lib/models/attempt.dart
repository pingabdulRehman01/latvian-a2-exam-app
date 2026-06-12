class Attempt {
  final int id;
  final int phraseId;
  final String userTranscript;
  final String targetPhrase;
  final int score;
  final String result;
  final DateTime createdAt;

  Attempt({
    required this.id,
    required this.phraseId,
    required this.userTranscript,
    required this.targetPhrase,
    required this.score,
    required this.result,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phraseId': phraseId,
      'userTranscript': userTranscript,
      'targetPhrase': targetPhrase,
      'score': score,
      'result': result,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Attempt.fromMap(Map<String, dynamic> map) {
    return Attempt(
      id: map['id'],
      phraseId: map['phraseId'],
      userTranscript: map['userTranscript'],
      targetPhrase: map['targetPhrase'],
      score: map['score'],
      result: map['result'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
