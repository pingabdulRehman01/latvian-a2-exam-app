class Lesson {
  final int id;
  final String title;
  final int dayNumber;
  final String topic;
  final DateTime createdAt;
  bool isCompleted;
  int? completionPercentage;

  Lesson({
    required this.id,
    required this.title,
    required this.dayNumber,
    required this.topic,
    required this.createdAt,
    this.isCompleted = false,
    this.completionPercentage = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dayNumber': dayNumber,
      'topic': topic,
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'],
      title: map['title'],
      dayNumber: map['dayNumber'],
      topic: map['topic'],
      createdAt: DateTime.parse(map['createdAt']),
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
