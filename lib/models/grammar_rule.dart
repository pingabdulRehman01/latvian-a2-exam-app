class GrammarRule {
  final int id;
  final int lessonId;
  final String title;
  final String explanation;
  final List<String> examples;
  final String category;

  GrammarRule({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.explanation,
    required this.examples,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lessonId': lessonId,
      'title': title,
      'explanation': explanation,
      'examples': examples.join('||'),
      'category': category,
    };
  }

  factory GrammarRule.fromMap(Map<String, dynamic> map) {
    return GrammarRule(
      id: map['id'],
      lessonId: map['lessonId'],
      title: map['title'],
      explanation: map['explanation'],
      examples: (map['examples'] as String).split('||'),
      category: map['category'],
    );
  }
}
