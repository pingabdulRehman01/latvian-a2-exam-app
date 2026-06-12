import 'dart:convert';

class ListeningQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  ListeningQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  Map<String, dynamic> toJson() => {
    'question': question,
    'options': options,
    'correctIndex': correctIndex,
  };

  factory ListeningQuestion.fromJson(Map<String, dynamic> json) => ListeningQuestion(
    question: json['question'],
    options: List<String>.from(json['options']),
    correctIndex: json['correctIndex'],
  );
}

class ListeningExercise {
  final int id;
  final String title;
  final String textLv;
  final String textEn;
  final String topic;
  final List<ListeningQuestion> questions;

  ListeningExercise({
    required this.id,
    required this.title,
    required this.textLv,
    required this.textEn,
    required this.topic,
    required this.questions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'textLv': textLv,
      'textEn': textEn,
      'topic': topic,
      'questions': jsonEncode(questions.map((q) => q.toJson()).toList()),
    };
  }

  factory ListeningExercise.fromMap(Map<String, dynamic> map) {
    return ListeningExercise(
      id: map['id'],
      title: map['title'],
      textLv: map['textLv'],
      textEn: map['textEn'],
      topic: map['topic'],
      questions: (jsonDecode(map['questions']) as List)
          .map((q) => ListeningQuestion.fromJson(q))
          .toList(),
    );
  }
}
