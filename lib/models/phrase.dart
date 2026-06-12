class Phrase {
  final int id;
  final int lessonId;
  final String phraseLv;
  final String phraseEn;
  final String difficultyLevel;

  Phrase({
    required this.id,
    required this.lessonId,
    required this.phraseLv,
    required this.phraseEn,
    this.difficultyLevel = 'A2',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lessonId': lessonId,
      'phraseLv': phraseLv,
      'phraseEn': phraseEn,
      'difficultyLevel': difficultyLevel,
    };
  }

  factory Phrase.fromMap(Map<String, dynamic> map) {
    return Phrase(
      id: map['id'],
      lessonId: map['lessonId'],
      phraseLv: map['phraseLv'],
      phraseEn: map['phraseEn'],
      difficultyLevel: map['difficultyLevel'] ?? 'A2',
    );
  }
}
