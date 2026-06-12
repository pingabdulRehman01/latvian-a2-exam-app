import 'dart:convert';

class ReadingQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  ReadingQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  Map<String, dynamic> toJson() => {
    'question': question,
    'options': options,
    'correctIndex': correctIndex,
  };

  factory ReadingQuestion.fromJson(Map<String, dynamic> json) => ReadingQuestion(
    question: json['question'],
    options: List<String>.from(json['options']),
    correctIndex: json['correctIndex'],
  );
}

class ReadingPassage {
  final int id;
  final String title;
  final String textLv;
  final String textEn;
  final String topic;
  final List<String> vocabulary; // new Latvian words with their English meanings
  final List<ReadingQuestion> questions;

  ReadingPassage({
    required this.id,
    required this.title,
    required this.textLv,
    required this.textEn,
    required this.topic,
    required this.vocabulary,
    required this.questions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'textLv': textLv,
      'textEn': textEn,
      'topic': topic,
      'vocabulary': jsonEncode(vocabulary),
      'questions': jsonEncode(questions.map((q) => q.toJson()).toList()),
    };
  }

  factory ReadingPassage.fromMap(Map<String, dynamic> map) {
    return ReadingPassage(
      id: map['id'],
      title: map['title'],
      textLv: map['textLv'],
      textEn: map['textEn'],
      topic: map['topic'],
      vocabulary: (jsonDecode(map['vocabulary']) as List)
          .map((v) => v as String)
          .toList(),
      questions: (jsonDecode(map['questions']) as List)
          .map((q) => ReadingQuestion.fromJson(q))
          .toList(),
    );
  }
}
