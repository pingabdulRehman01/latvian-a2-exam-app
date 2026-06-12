import 'dart:convert';

class WritingPrompt {
  final int id;
  final String title;
  final String promptEn;
  final String promptLv;
  final String topic;
  final List<String> vocabulary;
  final String modelAnswer;

  WritingPrompt({
    required this.id,
    required this.title,
    required this.promptEn,
    required this.promptLv,
    required this.topic,
    required this.vocabulary,
    required this.modelAnswer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'promptEn': promptEn,
      'promptLv': promptLv,
      'topic': topic,
      'vocabulary': jsonEncode(vocabulary),
      'modelAnswer': modelAnswer,
    };
  }

  factory WritingPrompt.fromMap(Map<String, dynamic> map) {
    return WritingPrompt(
      id: map['id'],
      title: map['title'],
      promptEn: map['promptEn'],
      promptLv: map['promptLv'],
      topic: map['topic'],
      vocabulary: (jsonDecode(map['vocabulary']) as List)
          .map((v) => v as String)
          .toList(),
      modelAnswer: map['modelAnswer'],
    );
  }
}
