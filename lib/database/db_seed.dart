import 'package:sqflite/sqflite.dart';

Future<void> seedDatabase(Database db) async {
  // Insert lessons
  final lessons = [
    {'title': 'Day 1: Introduce yourself', 'dayNumber': 1, 'topic': 'Introduce yourself'},
    {'title': 'Day 2: Family', 'dayNumber': 2, 'topic': 'Family'},
    {'title': 'Day 3: Numbers and time', 'dayNumber': 3, 'topic': 'Numbers and time'},
    {'title': 'Day 4: Shopping', 'dayNumber': 4, 'topic': 'Shopping'},
    {'title': 'Day 5: Food and drink', 'dayNumber': 5, 'topic': 'Food and drink'},
    {'title': 'Day 6: Directions', 'dayNumber': 6, 'topic': 'Directions'},
    {'title': 'Day 7: Daily routine', 'dayNumber': 7, 'topic': 'Daily routine'},
    {'title': 'Day 8: Work and hobbies', 'dayNumber': 8, 'topic': 'Work and hobbies'},
    {'title': 'Day 9: Health and well-being', 'dayNumber': 9, 'topic': 'Health and well-being'},
    {'title': 'Day 10: Mock exam review', 'dayNumber': 10, 'topic': 'Mock exam review'},
  ];

  for (var lesson in lessons) {
    await db.insert(
      'lessons',
      {
        ...lesson,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
  }

  // Insert phrases
  final phrases = [
    // Day 1
    {'lessonId': 1, 'phraseLv': 'Es esmu [name].', 'phraseEn': 'I am [name].', 'difficultyLevel': 'A2'},
    {'lessonId': 1, 'phraseLv': 'Kā tevi sauc?', 'phraseEn': 'What is your name?', 'difficultyLevel': 'A2'},
    {'lessonId': 1, 'phraseLv': 'Kur tu dzīvoji?', 'phraseEn': 'Where do you live?', 'difficultyLevel': 'A2'},
    
    // Day 2
    {'lessonId': 2, 'phraseLv': 'Man ir māsa.', 'phraseEn': 'I have a sister.', 'difficultyLevel': 'A2'},
    {'lessonId': 2, 'phraseLv': 'Mans tēvs strādā.', 'phraseEn': 'My father works.', 'difficultyLevel': 'A2'},
    {'lessonId': 2, 'phraseLv': 'Mana māte ir skolotāja.', 'phraseEn': 'My mother is a teacher.', 'difficultyLevel': 'A2'},
    
    // Day 3
    {'lessonId': 3, 'phraseLv': 'Cik ir pulkstenis?', 'phraseEn': 'What time is it?', 'difficultyLevel': 'A2'},
    {'lessonId': 3, 'phraseLv': 'Tas ir desmit.', 'phraseEn': 'It is ten.', 'difficultyLevel': 'A2'},
    {'lessonId': 3, 'phraseLv': 'Es nāku rīt.', 'phraseEn': 'I come tomorrow.', 'difficultyLevel': 'A2'},
    
    // Day 4
    {'lessonId': 4, 'phraseLv': 'Cik tas maksā?', 'phraseEn': 'How much does it cost?', 'difficultyLevel': 'A2'},
    {'lessonId': 4, 'phraseLv': 'Es gribu nopirkt maizi.', 'phraseEn': 'I want to buy bread.', 'difficultyLevel': 'A2'},
    {'lessonId': 4, 'phraseLv': 'Vai jums ir piena produkti?', 'phraseEn': 'Do you have dairy products?', 'difficultyLevel': 'A2'},
    
    // Day 5
    {'lessonId': 5, 'phraseLv': 'Es ēdu ābolu.', 'phraseEn': 'I eat an apple.', 'difficultyLevel': 'A2'},
    {'lessonId': 5, 'phraseLv': 'Man patīk kafija.', 'phraseEn': 'I like coffee.', 'difficultyLevel': 'A2'},
    {'lessonId': 5, 'phraseLv': 'Vai tu gribi ūdeni?', 'phraseEn': 'Do you want water?', 'difficultyLevel': 'A2'},
    
    // Day 6
    {'lessonId': 6, 'phraseLv': 'Kur ir stacija?', 'phraseEn': 'Where is the station?', 'difficultyLevel': 'A2'},
    {'lessonId': 6, 'phraseLv': 'Vienmēr uz priekšu.', 'phraseEn': 'Always straight ahead.', 'difficultyLevel': 'A2'},
    {'lessonId': 6, 'phraseLv': 'Pagriezies pa labi.', 'phraseEn': 'Turn right.', 'difficultyLevel': 'A2'},
    
    // Day 7
    {'lessonId': 7, 'phraseLv': 'Es mostos agri.', 'phraseEn': 'I wake up early.', 'difficultyLevel': 'A2'},
    {'lessonId': 7, 'phraseLv': 'Viņa iet uz darbu.', 'phraseEn': 'She goes to work.', 'difficultyLevel': 'A2'},
    {'lessonId': 7, 'phraseLv': 'Mēs gulējam par nakti.', 'phraseEn': 'We sleep at night.', 'difficultyLevel': 'A2'},
    
    // Day 8
    {'lessonId': 8, 'phraseLv': 'Es strādāju birojā.', 'phraseEn': 'I work in an office.', 'difficultyLevel': 'A2'},
    {'lessonId': 8, 'phraseLv': 'Man patīk lasīt grāmatas.', 'phraseEn': 'I like to read books.', 'difficultyLevel': 'A2'},
    {'lessonId': 8, 'phraseLv': 'Viņš spēlē futbolu.', 'phraseEn': 'He plays football.', 'difficultyLevel': 'A2'},
    
    // Day 9
    {'lessonId': 9, 'phraseLv': 'Man ir galvassāpes.', 'phraseEn': 'I have a headache.', 'difficultyLevel': 'A2'},
    {'lessonId': 9, 'phraseLv': 'Es jūtos labi.', 'phraseEn': 'I feel good.', 'difficultyLevel': 'A2'},
    {'lessonId': 9, 'phraseLv': 'Vai tev ir mājās ārstnieks?', 'phraseEn': 'Do you have a doctor at home?', 'difficultyLevel': 'A2'},
    
    // Day 10
    {'lessonId': 10, 'phraseLv': 'Es biju Rīgā.', 'phraseEn': 'I was in Riga.', 'difficultyLevel': 'A2'},
    {'lessonId': 10, 'phraseLv': 'Nākamgad es gribētu braukt uz Baltiju.', 'phraseEn': 'Next year I would like to travel to the Baltics.', 'difficultyLevel': 'A2'},
    {'lessonId': 10, 'phraseLv': 'Vai tu runā latviešu valodu?', 'phraseEn': 'Do you speak Latvian?', 'difficultyLevel': 'A2'},
  ];

  for (var phrase in phrases) {
    await db.insert('phrases', phrase);
  }
}
