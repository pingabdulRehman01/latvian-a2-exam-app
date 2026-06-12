class Mistake {
  final int id;
  final int phraseId;
  int retryCount;
  final DateTime lastAttempted;
  bool isResolved;

  Mistake({
    required this.id,
    required this.phraseId,
    this.retryCount = 0,
    required this.lastAttempted,
    this.isResolved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phraseId': phraseId,
      'retryCount': retryCount,
      'lastAttempted': lastAttempted.toIso8601String(),
      'isResolved': isResolved ? 1 : 0,
    };
  }

  factory Mistake.fromMap(Map<String, dynamic> map) {
    return Mistake(
      id: map['id'],
      phraseId: map['phraseId'],
      retryCount: map['retryCount'],
      lastAttempted: DateTime.parse(map['lastAttempted']),
      isResolved: map['isResolved'] == 1,
    );
  }
}
