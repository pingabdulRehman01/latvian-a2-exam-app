import 'package:sqflite/sqflite.dart';

/// Seed grammar rules (shared by fresh install and DB upgrade)
Future<void> seedGrammarRules(Database db) async {
  final grammarRules = [
    {
      'lessonId': 1,
      'title': 'Personal Pronouns & Verb "būt" (to be)',
      'explanation': 'Latvian verbs conjugate by person. "Es esmu" (I am), "Tu esi" (you are), "Viņš/viņa ir" (he/she is). The personal pronouns are: es (I), tu (you), viņš/viņa (he/she), mēs (we), jūs (you plural/formal), viņi/viņas (they masculine/feminine).',
      'examples': 'Es esmu no Latvijas.||Tu esi skolotājs.||Viņa ir ārste.',
      'category': 'verbs',
    },
    {
      'lessonId': 2,
      'title': 'Possessive Pronouns (mans, mana, mani, manas)',
      'explanation': 'In Latvian, possessive pronouns agree with the noun in gender and number. "Mans" (my, masculine), "Mana" (my, feminine), "Mani" (my, masculine plural), "Manas" (my, feminine plural). The same pattern applies to "tavs/tava" (your), "viņa" (his), "viņas" (her).',
      'examples': 'Mans tēvs strādā.||Mana māte ir skolotāja.||Mani brāļi ir lieli.',
      'category': 'pronouns',
    },
    {
      'lessonId': 3,
      'title': 'Locative Case (-ā, -ē, -os, -ās)',
      'explanation': 'The locative case answers the question "where?" (kur?). It is formed by adding endings to the noun: -ā (masculine), -ē (feminine), -os (masculine plural), -ās (feminine plural). Examples: Rīgā (in Riga), skolā (at school), jūlijā (in July).',
      'examples': 'Es dzīvoju Rīgā.||Mēs tiekamies skolā.||Janvārī ir auksts.',
      'category': 'cases',
    },
    {
      'lessonId': 4,
      'title': 'Accusative Case (Direct Object)',
      'explanation': 'The accusative case marks the direct object. Masculine nouns ending in -s/-š change to -u. Feminine nouns ending in -a change to -u, -e changes to -i. Example: maize → maizi (bread), piens → pienu (milk). Verbs like "gribu" (want), "pērku" (buy), "vajag" (need) require the accusative.',
      'examples': 'Es gribu nopirkt maizi.||Man vajag pienu.||Es pērku ābolus.',
      'category': 'cases',
    },
    {
      'lessonId': 5,
      'title': 'Verb "gribēt" (to want) & "garšot" (to like taste)',
      'explanation': '"Gribēt" (to want): es gribu, tu gribi, viņš/viņa grib, mēs gribam, jūs gribat, viņi/viņas grib. "Man garšo" (I like it / it tastes good to me) uses the dative "man" (to me). "Man patīk" (I like) is used for general preferences.',
      'examples': 'Es gribu ūdeni.||Tu gribi kafiju?||Man garšo zupa.||Man patīk lasīt.',
      'category': 'verbs',
    },
    {
      'lessonId': 6,
      'title': 'Prepositions of Place & Direction (uz, pie, no, pa)',
      'explanation': 'Prepositions require specific cases. "Uz" (to/on) + genitive/accusative. "Pie" (at/near) + genitive. "No" (from) + genitive. "Pa" (along/by) + dative/locative. Examples: Uz centru (to the center), pie stacijas (at the station), no Rīgas (from Riga).',
      'examples': 'Kā nokļūt uz centru?||Autoosta ir pie stacijas.||Es eju no mājas.',
      'category': 'prepositions',
    },
    {
      'lessonId': 7,
      'title': 'Reflexive Verbs (mazgāties, ģērbties, mosties)',
      'explanation': 'Reflexive verbs indicate the action is done to oneself. They add "-ties" in the infinitive and have special endings: es mostos (I wake up), tu mosties, viņš mostas. Common reflexive verbs: mazgāties (wash oneself), ģērbties (get dressed), atpūsties (rest).',
      'examples': 'Es mostos septiņos.||Es mazgājos.||Es ģērbjos un eju.',
      'category': 'verbs',
    },
    {
      'lessonId': 8,
      'title': 'Verb "patīk" & Dative Case',
      'explanation': '"Patīk" (like) uses the dative case for the person who likes something. "Man patīk" (I like), "Tev patīk" (you like), "Viņam patīk" (he likes). The thing liked is in the nominative case. "Man patīk grāmatas" = "Books are pleasing to me."',
      'examples': 'Man patīk lasīt grāmatas.||Viņam patīk futbols.||Mums patīk ceļot.',
      'category': 'verbs',
    },
    {
      'lessonId': 9,
      'title': 'Expressing Pain & Symptoms: "Man sāp" + Dative',
      'explanation': 'To express pain, use "Man sāp" (I have pain / something hurts me). The body part is in the nominative case. "Man sāp galva" (I have a headache / head hurts me). "Man ir" + noun for having a condition: "Man ir temperatūra" (I have a fever).',
      'examples': 'Man sāp galva.||Man sāp mugura.||Man ir temperatūra.',
      'category': 'expressions',
    },
    {
      'lessonId': 10,
      'title': 'Past & Future Tenses (bija, būšu, gāju, ies)',
      'explanation': 'Past tense removes -t and adds -ju, -ji, -ja, -jām, -jāt, -ja. "Es biju" (I was), "Tu gāji" (you went). Future tense uses the infinitive stem + -šu, -si, -s, -sim, -siet, -s. "Es būšu" (I will be), "Es apmeklēšu" (I will visit).',
      'examples': 'Es biju Latvijā.||Pagājušajā gadā es apmeklēju Rīgu.||Nākamgad es aizbraukšu uz Latviju.',
      'category': 'verbs',
    },
  ];

  for (final rule in grammarRules) {
    await db.insert('grammar_rules', {
      ...rule,
      'id': null,
    });
  }
}

/// Seed listening exercises (shared by fresh install and DB upgrade)
Future<void> seedListeningExercises(Database db) async {
  final exercises = [
    {
      'title': 'Introducing a Friend',
      'textLv': 'Sveiks! Šis ir mans draugs Pēteris. Viņš ir no Lietuvas, bet tagad dzīvo Rīgā. Pēteris strādā par programmētāju lielā uzņēmumā. Viņam ir 28 gadi. Brīvajā laikā viņš spēlē futbolu un klausās mūziku. Pēteris runā lietuviski, krieviski un angliski. Tagad viņš arī mācās latviešu valodu.',
      'textEn': 'Hi! This is my friend Pēteris. He is from Lithuania but now lives in Riga.',
      'topic': 'Introduce yourself',
      'questions': '[{"question":"Where is Pēteris from?","options":["Latvia","Lithuania","Estonia","Russia"],"correctIndex":1},{"question":"How old is Pēteris?","options":["25","28","30","35"],"correctIndex":1},{"question":"What languages does Pēteris speak?","options":["Only Lithuanian","Lithuanian, Russian, English","Only Russian","Lithuanian and English"],"correctIndex":1}]'
    },
    {
      'title': 'My Family',
      'textLv': 'Manā ģimenē ir četri cilvēki: es, mans tēvs, mana māte un mana mazā māsa. Mans tēvs ir skolotājs, un mana māte strādā slimnīcā par ārsti. Manai māsai ir desmit gadi, un viņa iet skolā. Mēs dzīvojam mazā dzīvoklī Rīgas centrā. Brīvdienās mēs bieži braucam pie vecvecākiem uz laukiem.',
      'textEn': 'In my family there are four people: me, my father, my mother and my sister.',
      'topic': 'Family',
      'questions': '[{"question":"How many people are in the family?","options":["Three","Four","Five","Six"],"correctIndex":1},{"question":"Where does the mother work?","options":["School","Hospital","Office","Shop"],"correctIndex":1},{"question":"Where do the grandparents live?","options":["Riga","Countryside","Big city","Another country"],"correctIndex":1}]'
    },
    {
      'title': 'Daily Schedule',
      'textLv': 'Es pieceļos pulksten septiņos no rīta. Vispirms es mazgāju seju un tīru zobus. Brokastīs es ēdu putru un dzeru kafiju. Pulksten astoņos es eju uz darbu. Es strādāju līdz pieciem. Pēc darba es bieži iepērkos veikalā. Vakarā es skatos televizoru vai lasu grāmatu. Es eju gulēt pulksten desmitos.',
      'textEn': 'I wake up at seven in the morning. First I wash my face and brush my teeth.',
      'topic': 'Daily routine',
      'questions': '[{"question":"What time does the person wake up?","options":["Six","Seven","Eight","Nine"],"correctIndex":1},{"question":"What does the person eat for breakfast?","options":["Bread","Porridge","Eggs","Fruit"],"correctIndex":1},{"question":"What time does the person go to sleep?","options":["Nine","Ten","Eleven","Midnight"],"correctIndex":1}]'
    },
    {
      'title': 'At the Shop',
      'textLv': 'Šodien man vajag nopirkt pārtiku. Es eju uz lielveikalu, kas ir netālu no manas mājas. Man vajag maizi, pienu, sviestu un olas. Es arī gribu nopirkt augļus. Piens maksā vienu eiro, maize maksā divus eiro. Kopā man jāmaksā desmit eiro. Es maksāju ar karti un paņemu čeku.',
      'textEn': 'Today I need to buy food. I go to the supermarket near my house.',
      'topic': 'Shopping',
      'questions': '[{"question":"Where does the person go shopping?","options":["Market","Supermarket","Small shop","Pharmacy"],"correctIndex":1},{"question":"What fruit does the person want?","options":["Oranges","Apples and bananas","Pears","Bananas only"],"correctIndex":1},{"question":"How does the person pay?","options":["Cash","Card","Phone","Check"],"correctIndex":1}]'
    },
    {
      'title': 'Restaurant Visit',
      'textLv': 'Vakar mēs ar draugiem bijām restorānā. Es pasūtīju zupu un vistas gaļu ar kartupeļiem. Mana draudzene pasūtīja zivs fileju un dārzeņu salātus. Mēs arī dzērām sulu. Ēdiens bija ļoti garšīgs. Rēķins bija 45 eiro. Mēs atstājām dzeramnaudu piecus eiro. Man ļoti patika šis restorāns!',
      'textEn': 'Yesterday my friends and I were at a restaurant. The food was very tasty.',
      'topic': 'Food and drink',
      'questions': '[{"question":"What did the speaker order?","options":["Fish","Soup and chicken","Pasta","Only soup"],"correctIndex":1},{"question":"How much was the bill?","options":["40","45","50","55"],"correctIndex":1},{"question":"Did the speaker like the restaurant?","options":["No","Yes very much","Okay","Not mentioned"],"correctIndex":1}]'
    },
    {
      'title': 'Asking for Directions',
      'textLv': 'Atvainojiet, es meklēju Centrālo staciju. Vai jūs varat man palīdzēt? Jums jāiet taisni uz priekšu līdz otram krustojumam. Tad pagriezieties pa kreisi. Stacija ir apmēram piecas minūtes kājām. Tā ir liela ēka ar pulksteni. Jūs nevarat to palaist garām!',
      'textEn': 'Excuse me, I am looking for the Central Station. Can you help me?',
      'topic': 'Directions',
      'questions': '[{"question":"What is the person looking for?","options":["Hotel","Central Station","Restaurant","Museum"],"correctIndex":1},{"question":"Which direction should the person turn?","options":["Right","Left","Straight","Back"],"correctIndex":1},{"question":"How far is the station?","options":["2 min","5 min","10 min","15 min"],"correctIndex":1}]'
    },
    {
      'title': 'My Hobbies',
      'textLv': 'Man ir vairāki hobiji. Man ļoti patīk lasīt grāmatas, īpaši detektīvromānus. Es arī spēlēju ģitāru un dažreiz dziedu. Trīs reizes nedēļā es eju uz sporta zāli. Brīvdienās man patīk iet garās pastaigās parkā. Man arī patīk gatavot ēst. Šovakar es gatavošu tradicionālu latviešu ēdienu.',
      'textEn': 'I have several hobbies. I like reading books and playing guitar.',
      'topic': 'Work and hobbies',
      'questions': '[{"question":"What kind of books does the speaker like?","options":["Romance","Detective","Sci-fi","History"],"correctIndex":1},{"question":"How often does the speaker go to the gym?","options":["Once a week","Twice a week","Three times a week","Daily"],"correctIndex":2},{"question":"What will the speaker cook tonight?","options":["Soup","Traditional Latvian dish","Pasta","Fish"],"correctIndex":1}]'
    },
    {
      'title': 'At the Doctor',
      'textLv': 'Sveiki, man ir slikti. Man sāp galva un man ir temperatūra 38 grādi. Es arī klepoju. Šīs sāpes sākās vakar vakarā. Es jūtos ļoti noguris. Ārsts paskatījās uz mani un teica, ka man ir gripa. Viņš izrakstīja zāles un teica, ka man jādzer daudz ūdens un jāatpūšas trīs dienas.',
      'textEn': 'Hello, I feel unwell. I have a headache and a fever.',
      'topic': 'Health',
      'questions': '[{"question":"What symptoms does the patient have?","options":["Headache only","Headache and fever","Cough only","Stomach pain"],"correctIndex":1},{"question":"What did the doctor diagnose?","options":["Cold","Flu","Allergy","Poisoning"],"correctIndex":1},{"question":"How many days should the patient rest?","options":["One","Two","Three","Five"],"correctIndex":2}]'
    },
    {
      'title': 'Weather and Plans',
      'textLv': 'Šodien laiks ir ļoti skaists. Spīd saule un ir silts, apmēram 20 grādu. Rīt būs lietus un vējš. Tāpēc šodien es gribu iet uz parku. Es aicināšu līdzi savu draugu Jāni. Mēs ņemsim līdzi grozu ar ēdienu un segas. Mēs sēdēsim zālē un lasīsim grāmatas.',
      'textEn': 'Today the weather is very nice. The sun is shining and it is warm.',
      'topic': 'Daily routine',
      'questions': '[{"question":"What is the weather like today?","options":["Rainy","Sunny and warm","Cold","Snowy"],"correctIndex":1},{"question":"What will the weather be like tomorrow?","options":["Sunny","Rain and wind","Warm","Cloudy"],"correctIndex":1},{"question":"Who will the speaker invite?","options":["Sister","Friend Janis","Mother","Colleague"],"correctIndex":1}]'
    },
    {
      'title': 'Travel Plans',
      'textLv': 'Nākamajā mēnesī es braukšu uz Latviju. Es apmeklēšu Rīgu, Jūrmalu un Siguldu. Rīgā es gribu redzēt Vecrīgu un Centrāltirgu. Jūrmalā es peldēšos jūrā un staigāšu pa pludmali. Siguldā es redzēšu Turaidas pili. Es palikšu Latvijā divas nedēļas.',
      'textEn': 'Next month I will travel to Latvia. I will visit Riga and Jurmala.',
      'topic': 'Mock exam review',
      'questions': '[{"question":"How many Latvian cities will the speaker visit?","options":["Two","Three","Four","Five"],"correctIndex":1},{"question":"What does the speaker want to see in Riga?","options":["Museums","Old Town and Market","Parks","Malls"],"correctIndex":1},{"question":"How long will the trip be?","options":["One week","Two weeks","Three weeks","One month"],"correctIndex":1}]'
    },
  ];

  for (final exercise in exercises) {
    await db.insert('listening_exercises', {
      'id': null,
      'title': exercise['title'],
      'textLv': exercise['textLv'],
      'textEn': exercise['textEn'],
      'topic': exercise['topic'],
      'questions': exercise['questions'],
    });
  }
}

Future<void> seedDatabase(Database db) async {
  // ── Lessons ──────────────────────────────────────────────────────────────
  final lessons = [
    {'title': 'Day 1: Introduce yourself', 'dayNumber': 1, 'topic': 'Greetings & self-introduction'},
    {'title': 'Day 2: Family & friends', 'dayNumber': 2, 'topic': 'Family & friends'},
    {'title': 'Day 3: Numbers and time', 'dayNumber': 3, 'topic': 'Numbers and time'},
    {'title': 'Day 4: Shopping', 'dayNumber': 4, 'topic': 'Shopping'},
    {'title': 'Day 5: Food and drink', 'dayNumber': 5, 'topic': 'Food and drink'},
    {'title': 'Day 6: Directions', 'dayNumber': 6, 'topic': 'Directions & transport'},
    {'title': 'Day 7: Daily routine', 'dayNumber': 7, 'topic': 'Daily routine'},
    {'title': 'Day 8: Work and hobbies', 'dayNumber': 8, 'topic': 'Work and hobbies'},
    {'title': 'Day 9: Health and well-being', 'dayNumber': 9, 'topic': 'Health & well-being'},
    {'title': 'Day 10: Mock exam review', 'dayNumber': 10, 'topic': 'Mock exam review'},
  ];

  for (final lesson in lessons) {
    await db.insert('lessons', {
      ...lesson,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  // ── Phrases ──────────────────────────────────────────────────────────────
  final phrases = <Map<String, dynamic>>[
    // ── DAY 1: Introduce yourself ──────────────────────────────────────────
    {'lessonId': 1, 'phraseLv': 'Sveiki! Kā jums klājas?', 'phraseEn': 'Hello! How are you?', 'difficultyLevel': 'A1'},
    {'lessonId': 1, 'phraseLv': 'Es esmu [vārds].', 'phraseEn': 'I am [name].', 'difficultyLevel': 'A1'},
    {'lessonId': 1, 'phraseLv': 'Kā tevi sauc?', 'phraseEn': 'What is your name?', 'difficultyLevel': 'A1'},
    {'lessonId': 1, 'phraseLv': 'Man ir 30 gadi.', 'phraseEn': 'I am 30 years old.', 'difficultyLevel': 'A2'},
    {'lessonId': 1, 'phraseLv': 'No kurienes tu nāc?', 'phraseEn': 'Where do you come from?', 'difficultyLevel': 'A2'},
    {'lessonId': 1, 'phraseLv': 'Es esmu no Latvijas.', 'phraseEn': 'I am from Latvia.', 'difficultyLevel': 'A2'},
    {'lessonId': 1, 'phraseLv': 'Es runāju latviski un angliski.', 'phraseEn': 'I speak Latvian and English.', 'difficultyLevel': 'A2'},
    {'lessonId': 1, 'phraseLv': 'Prieks iepazīties!', 'phraseEn': 'Nice to meet you!', 'difficultyLevel': 'A1'},
    {'lessonId': 1, 'phraseLv': 'Es dzīvoju Rīgā.', 'phraseEn': 'I live in Riga.', 'difficultyLevel': 'A2'},
    {'lessonId': 1, 'phraseLv': 'Man patīk ceļot.', 'phraseEn': 'I like to travel.', 'difficultyLevel': 'A2'},

    // ── DAY 2: Family & friends ───────────────────────────────────────────
    {'lessonId': 2, 'phraseLv': 'Man ir māsa un brālis.', 'phraseEn': 'I have a sister and a brother.', 'difficultyLevel': 'A2'},
    {'lessonId': 2, 'phraseLv': 'Mana māte strādā skolā.', 'phraseEn': 'My mother works at a school.', 'difficultyLevel': 'A2'},
    {'lessonId': 2, 'phraseLv': 'Mans tēvs ir ārsts.', 'phraseEn': 'My father is a doctor.', 'difficultyLevel': 'A2'},
    {'lessonId': 2, 'phraseLv': 'Man ir divi bērni.', 'phraseEn': 'I have two children.', 'difficultyLevel': 'A2'},
    {'lessonId': 2, 'phraseLv': 'Mana vecmāmiņa dzīvo laukos.', 'phraseEn': 'My grandmother lives in the countryside.', 'difficultyLevel': 'A2'},
    {'lessonId': 2, 'phraseLv': 'Mēs satiekamies brīvdienās.', 'phraseEn': 'We meet on weekends.', 'difficultyLevel': 'A2'},
    {'lessonId': 2, 'phraseLv': 'Man ir draugs no Anglijas.', 'phraseEn': 'I have a friend from England.', 'difficultyLevel': 'A2'},
    {'lessonId': 2, 'phraseLv': 'Vai tev ir ģimene?', 'phraseEn': 'Do you have a family?', 'difficultyLevel': 'A1'},
    {'lessonId': 2, 'phraseLv': 'Mēs dzīvojam kopā ar vecākiem.', 'phraseEn': 'We live together with parents.', 'difficultyLevel': 'A2'},
    {'lessonId': 2, 'phraseLv': 'Es mīlu savu ģimeni.', 'phraseEn': 'I love my family.', 'difficultyLevel': 'A2'},

    // ── DAY 3: Numbers and time ────────────────────────────────────────────
    {'lessonId': 3, 'phraseLv': 'Cik ir pulkstenis?', 'phraseEn': 'What time is it?', 'difficultyLevel': 'A1'},
    {'lessonId': 3, 'phraseLv': 'Pulkstenis ir desmit.', 'phraseEn': 'It is ten o\'clock.', 'difficultyLevel': 'A1'},
    {'lessonId': 3, 'phraseLv': 'Šodien ir pirmdiena.', 'phraseEn': 'Today is Monday.', 'difficultyLevel': 'A1'},
    {'lessonId': 3, 'phraseLv': 'Es pieceļos pulksten septiņos.', 'phraseEn': 'I get up at seven o\'clock.', 'difficultyLevel': 'A2'},
    {'lessonId': 3, 'phraseLv': 'Mēs tiekamies trijos pēcpusdienā.', 'phraseEn': 'We meet at three in the afternoon.', 'difficultyLevel': 'A2'},
    {'lessonId': 3, 'phraseLv': 'Janvārī ir auksts.', 'phraseEn': 'It is cold in January.', 'difficultyLevel': 'A2'},
    {'lessonId': 3, 'phraseLv': 'Šodien ir divdesmitais marts.', 'phraseEn': 'Today is the twentieth of March.', 'difficultyLevel': 'A2'},
    {'lessonId': 3, 'phraseLv': 'Es strādāju no rīta līdz vakaram.', 'phraseEn': 'I work from morning till evening.', 'difficultyLevel': 'A2'},
    {'lessonId': 3, 'phraseLv': 'Rīt ir piektdiena.', 'phraseEn': 'Tomorrow is Friday.', 'difficultyLevel': 'A1'},
    {'lessonId': 3, 'phraseLv': 'Vasarā ir silts.', 'phraseEn': 'In summer it is warm.', 'difficultyLevel': 'A1'},

    // ── DAY 4: Shopping ────────────────────────────────────────────────────
    {'lessonId': 4, 'phraseLv': 'Cik tas maksā?', 'phraseEn': 'How much does it cost?', 'difficultyLevel': 'A1'},
    {'lessonId': 4, 'phraseLv': 'Tas maksā piecus eiro.', 'phraseEn': 'It costs five euros.', 'difficultyLevel': 'A2'},
    {'lessonId': 4, 'phraseLv': 'Vai jums ir piens?', 'phraseEn': 'Do you have milk?', 'difficultyLevel': 'A2'},
    {'lessonId': 4, 'phraseLv': 'Es gribu nopirkt maizi un sviestu.', 'phraseEn': 'I want to buy bread and butter.', 'difficultyLevel': 'A2'},
    {'lessonId': 4, 'phraseLv': 'Vai šī kleita ir pārdošanā?', 'phraseEn': 'Is this dress on sale?', 'difficultyLevel': 'A2'},
    {'lessonId': 4, 'phraseLv': 'Man vajag kilogramu ābolu.', 'phraseEn': 'I need a kilogram of apples.', 'difficultyLevel': 'A2'},
    {'lessonId': 4, 'phraseLv': 'Šis ir pārāk dārgs.', 'phraseEn': 'This is too expensive.', 'difficultyLevel': 'A2'},
    {'lessonId': 4, 'phraseLv': 'Kur ir tuvākais veikals?', 'phraseEn': 'Where is the nearest shop?', 'difficultyLevel': 'A2'},
    {'lessonId': 4, 'phraseLv': 'Es maksāju ar karti.', 'phraseEn': 'I pay with a card.', 'difficultyLevel': 'A2'},
    {'lessonId': 4, 'phraseLv': 'Lūdzu, čeku.', 'phraseEn': 'The receipt, please.', 'difficultyLevel': 'A2'},

    // ── DAY 5: Food and drink ──────────────────────────────────────────────
    {'lessonId': 5, 'phraseLv': 'Es ēdu ābolu.', 'phraseEn': 'I eat an apple.', 'difficultyLevel': 'A1'},
    {'lessonId': 5, 'phraseLv': 'Man garšo kafija.', 'phraseEn': 'I like coffee.', 'difficultyLevel': 'A2'},
    {'lessonId': 5, 'phraseLv': 'Vai tu gribi ūdeni vai sulu?', 'phraseEn': 'Do you want water or juice?', 'difficultyLevel': 'A2'},
    {'lessonId': 5, 'phraseLv': 'Lūdzu, vienu kafiju ar pienu.', 'phraseEn': 'One coffee with milk, please.', 'difficultyLevel': 'A2'},
    {'lessonId': 5, 'phraseLv': 'Brokastīs es ēdu putru.', 'phraseEn': 'For breakfast I eat porridge.', 'difficultyLevel': 'A2'},
    {'lessonId': 5, 'phraseLv': 'Šī zupa ir ļoti garšīga.', 'phraseEn': 'This soup is very tasty.', 'difficultyLevel': 'A2'},
    {'lessonId': 5, 'phraseLv': 'Es negribu gaļu, es esmu veģetārietis.', 'phraseEn': 'I don\'t want meat, I am a vegetarian.', 'difficultyLevel': 'A2'},
    {'lessonId': 5, 'phraseLv': 'Mēs ēdam pusdienas restorānā.', 'phraseEn': 'We have lunch at a restaurant.', 'difficultyLevel': 'A2'},
    {'lessonId': 5, 'phraseLv': 'Cik maksā šis ēdiens?', 'phraseEn': 'How much is this dish?', 'difficultyLevel': 'A2'},
    {'lessonId': 5, 'phraseLv': 'Vai jums ir galds diviem?', 'phraseEn': 'Do you have a table for two?', 'difficultyLevel': 'A2'},

    // ── DAY 6: Directions & transport ──────────────────────────────────────
    {'lessonId': 6, 'phraseLv': 'Kur ir autoosta?', 'phraseEn': 'Where is the bus station?', 'difficultyLevel': 'A2'},
    {'lessonId': 6, 'phraseLv': 'Kā nokļūt uz centru?', 'phraseEn': 'How to get to the centre?', 'difficultyLevel': 'A2'},
    {'lessonId': 6, 'phraseLv': 'Pagriezieties pa labi.', 'phraseEn': 'Turn right.', 'difficultyLevel': 'A2'},
    {'lessonId': 6, 'phraseLv': 'Iet taisni uz priekšu.', 'phraseEn': 'Go straight ahead.', 'difficultyLevel': 'A2'},
    {'lessonId': 6, 'phraseLv': 'Tas ir aiz stūra.', 'phraseEn': 'It is around the corner.', 'difficultyLevel': 'A2'},
    {'lessonId': 6, 'phraseLv': 'Cik tālu ir līdz stacijai?', 'phraseEn': 'How far is it to the station?', 'difficultyLevel': 'A2'},
    {'lessonId': 6, 'phraseLv': 'Es braucu ar autobusu.', 'phraseEn': 'I go by bus.', 'difficultyLevel': 'A2'},
    {'lessonId': 6, 'phraseLv': 'Kur ir tuvākā pietura?', 'phraseEn': 'Where is the nearest stop?', 'difficultyLevel': 'A2'},
    {'lessonId': 6, 'phraseLv': 'Man vajag biļeti uz Rīgu.', 'phraseEn': 'I need a ticket to Riga.', 'difficultyLevel': 'A2'},
    {'lessonId': 6, 'phraseLv': 'Vilciens atiet trijos.', 'phraseEn': 'The train departs at three.', 'difficultyLevel': 'A2'},

    // ── DAY 7: Daily routine ───────────────────────────────────────────────
    {'lessonId': 7, 'phraseLv': 'Es mostos septiņos no rīta.', 'phraseEn': 'I wake up at seven in the morning.', 'difficultyLevel': 'A2'},
    {'lessonId': 7, 'phraseLv': 'Es mazgāju seju un tīru zobus.', 'phraseEn': 'I wash my face and brush my teeth.', 'difficultyLevel': 'A2'},
    {'lessonId': 7, 'phraseLv': 'Es ģērbjos un eju uz darbu.', 'phraseEn': 'I get dressed and go to work.', 'difficultyLevel': 'A2'},
    {'lessonId': 7, 'phraseLv': 'Pusdienas pārtraukums ir no vieniem.', 'phraseEn': 'Lunch break is from one o\'clock.', 'difficultyLevel': 'A2'},
    {'lessonId': 7, 'phraseLv': 'Vakarā es skatos televizoru.', 'phraseEn': 'In the evening I watch TV.', 'difficultyLevel': 'A2'},
    {'lessonId': 7, 'phraseLv': 'Es eju gulēt desmitos.', 'phraseEn': 'I go to sleep at ten.', 'difficultyLevel': 'A2'},
    {'lessonId': 7, 'phraseLv': 'Katru dienu es lasu grāmatu.', 'phraseEn': 'Every day I read a book.', 'difficultyLevel': 'A2'},
    {'lessonId': 7, 'phraseLv': 'Dažreiz es sportoju.', 'phraseEn': 'Sometimes I exercise.', 'difficultyLevel': 'A2'},
    {'lessonId': 7, 'phraseLv': 'Pēc darba es satieku draugus.', 'phraseEn': 'After work I meet friends.', 'difficultyLevel': 'A2'},
    {'lessonId': 7, 'phraseLv': 'Brīvdienās es atpūšos.', 'phraseEn': 'On weekends I rest.', 'difficultyLevel': 'A1'},

    // ── DAY 8: Work and hobbies ────────────────────────────────────────────
    {'lessonId': 8, 'phraseLv': 'Es strādāju birojā.', 'phraseEn': 'I work in an office.', 'difficultyLevel': 'A2'},
    {'lessonId': 8, 'phraseLv': 'Es esmu programmētājs.', 'phraseEn': 'I am a programmer.', 'difficultyLevel': 'A2'},
    {'lessonId': 8, 'phraseLv': 'Man patīk lasīt grāmatas.', 'phraseEn': 'I like to read books.', 'difficultyLevel': 'A1'},
    {'lessonId': 8, 'phraseLv': 'Mans hobijs ir fotografēšana.', 'phraseEn': 'My hobby is photography.', 'difficultyLevel': 'A2'},
    {'lessonId': 8, 'phraseLv': 'Es spēlēju futbolu brīvdienās.', 'phraseEn': 'I play football on weekends.', 'difficultyLevel': 'A2'},
    {'lessonId': 8, 'phraseLv': 'Vai tev patīk mūzika?', 'phraseEn': 'Do you like music?', 'difficultyLevel': 'A1'},
    {'lessonId': 8, 'phraseLv': 'Es mācos latviešu valodu.', 'phraseEn': 'I am learning the Latvian language.', 'difficultyLevel': 'A2'},
    {'lessonId': 8, 'phraseLv': 'Mans darbs ir interesants.', 'phraseEn': 'My work is interesting.', 'difficultyLevel': 'A2'},
    {'lessonId': 8, 'phraseLv': 'Es strādāju no pirmdienas līdz piektdienai.', 'phraseEn': 'I work from Monday to Friday.', 'difficultyLevel': 'A2'},
    {'lessonId': 8, 'phraseLv': 'Man ir trīs brīvdienas nedēļā.', 'phraseEn': 'I have three days off per week.', 'difficultyLevel': 'A2'},

    // ── DAY 9: Health and well-being ───────────────────────────────────────
    {'lessonId': 9, 'phraseLv': 'Man ir galvassāpes.', 'phraseEn': 'I have a headache.', 'difficultyLevel': 'A2'},
    {'lessonId': 9, 'phraseLv': 'Es jūtos slikti.', 'phraseEn': 'I feel unwell.', 'difficultyLevel': 'A2'},
    {'lessonId': 9, 'phraseLv': 'Vai jūs varat izsaukt ārstu?', 'phraseEn': 'Can you call a doctor?', 'difficultyLevel': 'A2'},
    {'lessonId': 9, 'phraseLv': 'Man ir temperatūra.', 'phraseEn': 'I have a fever.', 'difficultyLevel': 'A2'},
    {'lessonId': 9, 'phraseLv': 'Kur ir tuvākā aptieka?', 'phraseEn': 'Where is the nearest pharmacy?', 'difficultyLevel': 'A2'},
    {'lessonId': 9, 'phraseLv': 'Ārsts izrakstīja man zāles.', 'phraseEn': 'The doctor prescribed me medicine.', 'difficultyLevel': 'A2'},
    {'lessonId': 9, 'phraseLv': 'Man sāp mugura.', 'phraseEn': 'My back hurts.', 'difficultyLevel': 'A2'},
    {'lessonId': 9, 'phraseLv': 'Es vingroju katru rītu.', 'phraseEn': 'I exercise every morning.', 'difficultyLevel': 'A2'},
    {'lessonId': 9, 'phraseLv': 'Dzeriet daudz ūdens!', 'phraseEn': 'Drink plenty of water!', 'difficultyLevel': 'A2'},
    {'lessonId': 9, 'phraseLv': 'Man ir alerģija pret ziedputekšņiem.', 'phraseEn': 'I have an allergy to pollen.', 'difficultyLevel': 'A2'},

    // ── DAY 10: Mock exam review ───────────────────────────────────────────
    {'lessonId': 10, 'phraseLv': 'Vai jūs runājat angliski?', 'phraseEn': 'Do you speak English?', 'difficultyLevel': 'A1'},
    {'lessonId': 10, 'phraseLv': 'Es nevaru atrast savu maku.', 'phraseEn': 'I cannot find my wallet.', 'difficultyLevel': 'A2'},
    {'lessonId': 10, 'phraseLv': 'Vai jūs varat man palīdzēt?', 'phraseEn': 'Can you help me?', 'difficultyLevel': 'A1'},
    {'lessonId': 10, 'phraseLv': 'Es gribētu rezervēt istabu.', 'phraseEn': 'I would like to book a room.', 'difficultyLevel': 'A2'},
    {'lessonId': 10, 'phraseLv': 'Cik ilgi vilciens brauc uz Rīgu?', 'phraseEn': 'How long does the train take to Riga?', 'difficultyLevel': 'A2'},
    {'lessonId': 10, 'phraseLv': 'Laiks ir skaists šodien.', 'phraseEn': 'The weather is nice today.', 'difficultyLevel': 'A1'},
    {'lessonId': 10, 'phraseLv': 'Es gribu iemācīties latviešu valodu.', 'phraseEn': 'I want to learn the Latvian language.', 'difficultyLevel': 'A2'},
    {'lessonId': 10, 'phraseLv': 'Rīgā ir daudz skaistu vietu.', 'phraseEn': 'There are many beautiful places in Riga.', 'difficultyLevel': 'A2'},
    {'lessonId': 10, 'phraseLv': 'Es biju Latvijā pagājušajā gadā.', 'phraseEn': 'I was in Latvia last year.', 'difficultyLevel': 'A2'},
    {'lessonId': 10, 'phraseLv': 'Nākamajā gadā es apmeklēšu Latviju.', 'phraseEn': 'Next year I will visit Latvia.', 'difficultyLevel': 'A2'},
  ];

  for (final phrase in phrases) {
    await db.insert('phrases', phrase);
  }

  // ── Grammar rules ────────────────────────────────────────────────────────
  await seedGrammarRules(db);

  // Seed listening exercises
  await seedListeningExercises(db);

  // Seed reading passages
  await seedReadingPassages(db);

  // Seed writing prompts
  await seedWritingPrompts(db);
}

/// Seed writing prompts (shared by fresh install and DB upgrade)
Future<void> seedWritingPrompts(Database db) async {
  final prompts = [
    {
      'title': 'Introduce Yourself',
      'promptEn': 'Write a short introduction of yourself in Latvian. Include your name, where you are from, where you live, what you do, and what languages you speak.',
      'promptLv': 'Uzraksti īsu sevis iepazīstināšanu latviešu valodā. Iekļauj savu vārdu, no kurienes esi, kur dzīvo, ko dari un kādās valodās runā.',
      'topic': 'Introduce yourself',
      'vocabulary': '["iepazīstināt - to introduce", "vārds - name", "dzīvot - to live", "strādāt - to work", "runāt - to speak", "latviski - in Latvian", "angliski - in English"]',
      'modelAnswer': 'Sveiki! Mani sauc Jānis. Es esmu no Latvijas un dzīvoju Rīgā. Es strādāju par skolotāju. Es runāju latviski, angliski un krieviski. Man patīk ceļot un lasīt grāmatas.'
    },
    {
      'title': 'Describe Your Family',
      'promptEn': 'Write about your family in Latvian. Describe how many people are in your family, what they do, and where they live.',
      'promptLv': 'Uzraksti par savu ģimeni latviešu valodā. Apraksti, cik cilvēku ir tavā ģimenē, ko viņi dara un kur dzīvo.',
      'topic': 'Family',
      'vocabulary': '["ģimene - family", "tēvs - father", "māte - mother", "brālis - brother", "māsa - sister", "kopā - together", "dzīvoklis - apartment"]',
      'modelAnswer': 'Manā ģimenē ir četri cilvēki: es, mans tēvs, mana māte un mana māsa. Mans tēvs strādā birojā, un mana māte ir ārste. Mana māsa mācās skolā. Mēs dzīvojam kopā dzīvoklī Rīgas centrā.'
    },
    {
      'title': 'My Daily Routine',
      'promptEn': 'Describe your typical day in Latvian. Write about what time you wake up, what you eat for breakfast, what you do during the day, and when you go to sleep.',
      'promptLv': 'Apraksti savu tipisko dienu latviešu valodā. Uzraksti, cikos tu mosties, ko ēd brokastīs, ko dari dienas laikā un kad ej gulēt.',
      'topic': 'Daily routine',
      'vocabulary': '["mosties - to wake up", "brokastis - breakfast", "pusdienas - lunch", "vakariņas - dinner", "darbs - work", "atpūsties - to rest", "gulēt - to sleep"]',
      'modelAnswer': 'Es pieceļos pulksten septiņos no rīta. Brokastīs es ēdu putru un dzeru kafiju. Es eju uz darbu pulksten astoņos. Pēc darba es atpūšos un skatos televizoru. Es eju gulēt pulksten desmitos vakarā.'
    },
    {
      'title': 'Shopping List',
      'promptEn': 'Write a short text in Latvian about going to the shop. Say what you need to buy, how much things cost, and how you pay.',
      'promptLv': 'Uzraksti īsu tekstu latviešu valodā par iepirkšanos veikalā. Pasaki, kas tev jānopērk, cik maksā preces un kā tu maksā.',
      'topic': 'Shopping',
      'vocabulary': '["iepirkšanās - shopping", "veikals - shop", "nopirkt - to buy", "maksāt - to pay", "eiro - euro", "lēts - cheap", "dārgs - expensive"]',
      'modelAnswer': 'Šodien man vajag nopirkt pārtiku. Es eju uz lielveikalu. Man vajag maizi, pienu un augļus. Piens maksā vienu eiro, bet maize maksā divus eiro. Es maksāju ar karti.'
    },
    {
      'title': 'At a Restaurant',
      'promptEn': 'Write a dialogue or description in Latvian about visiting a restaurant. What do you order? How is the food? How much is the bill?',
      'promptLv': 'Uzraksti dialogu vai aprakstu latviešu valodā par restorāna apmeklējumu. Ko tu pasūti? Kāds ir ēdiens? Cik liels ir rēķins?',
      'topic': 'Food and drink',
      'vocabulary': '["restorāns - restaurant", "pasūtīt - to order", "zupa - soup", "gaļa - meat", "dārzenis - vegetable", "garšīgs - tasty", "rēķins - bill"]',
      'modelAnswer': 'Vakar es ar draugu biju restorānā. Es pasūtīju zupu un vistas gaļu ar dārzeņiem. Ēdiens bija ļoti garšīgs. Rēķins bija 25 eiro. Man ļoti patika šis restorāns.'
    },
    {
      'title': 'Asking for Directions',
      'promptEn': 'Write a short dialogue in Latvian where someone asks for directions to the train station. Include the reply with clear directions.',
      'promptLv': 'Uzraksti īsu dialogu latviešu valodā, kur kāds jautā ceļu uz dzelzceļa staciju. Iekļauj atbildi ar skaidriem norādījumiem.',
      'topic': 'Directions',
      'vocabulary': '["stacija - station", "pagriezties - to turn", "pa labi - to the right", "pa kreisi - to the left", "taisni - straight", "krustojums - intersection", "netālu - nearby"]',
      'modelAnswer': 'Atvainojiet, kur ir autoosta? Jums jāiet taisni līdz otram krustojumam. Tad pagriezieties pa kreisi. Autoosta ir netālu, apmēram piecas minūtes kājām.'
    },
    {
      'title': 'My Hobbies',
      'promptEn': 'Write about your hobbies and free time activities in Latvian. What do you like to do in your free time? How often do you do these activities?',
      'promptLv': 'Uzraksti par saviem hobijiem un brīvā laika aktivitātēm latviešu valodā. Ko tev patīk darīt brīvajā laikā? Cik bieži tu nodarbojies ar šīm aktivitātēm?',
      'topic': 'Work and hobbies',
      'vocabulary': '["hobijs - hobby", "patīk - like", "lasīt - to read", "sportot - to exercise", "spēlēt - to play", "klausīties - to listen", "mūzika - music"]',
      'modelAnswer': 'Man ir vairāki hobiji. Man patīk lasīt grāmatas un klausīties mūziku. Trīs reizes nedēļā es sportoju. Brīvdienās es spēlēju futbolu ar draugiem. Man arī patīk gatavot ēst.'
    },
    {
      'title': 'At the Doctor',
      'promptEn': 'Write a short conversation in Latvian between a patient and a doctor. The patient describes their symptoms and the doctor gives advice.',
      'promptLv': 'Uzraksti īsu sarunu latviešu valodā starp pacientu un ārstu. Pacients apraksta savus simptomus, un ārsts dod padomu.',
      'topic': 'Health',
      'vocabulary': '["ārsts - doctor", "sāpēt - to hurt", "galva - head", "temperatūra - fever", "zāles - medicine", "atpūsties - to rest", "vesels - healthy"]',
      'modelAnswer': 'Sveiki, man ir slikti. Man sāp galva un man ir temperatūra. Ārsts teica, ka man ir gripa. Viņš izrakstīja zāles. Man jādzer daudz ūdens un jāatpūšas trīs dienas.'
    },
    {
      'title': 'Weekend Plans',
      'promptEn': 'Write about your plans for the upcoming weekend in Latvian. Describe what you will do, who you will meet, and what the weather will be like.',
      'promptLv': 'Uzraksti par saviem plāniem nedēļas nogalei latviešu valodā. Apraksti, ko tu darīsi, ko satiksi un kāds būs laiks.',
      'topic': 'Daily routine',
      'vocabulary': '["nedēļas nogale - weekend", "plāns - plan", "satikties - to meet", "draugs - friend", "laiks - weather", "saule - sun", "pastaiga - walk"]',
      'modelAnswer': 'Šajā nedēļas nogalē man ir lieliski plāni. Sestdien es satikšos ar draugiem un mēs iesim uz kafejnīcu. Svētdien laiks būs skaists, tāpēc es iešu garā pastaigā parkā.'
    },
    {
      'title': 'Invitation Email',
      'promptEn': 'Write a short email in Latvian inviting a friend to your birthday party. Include the date, time, location, and ask them to reply.',
      'promptLv': 'Uzraksti īsu e-pastu latviešu valodā, aicinot draugu uz savu dzimšanas dienas ballīti. Iekļauj datumu, laiku, vietu un palūdz atbildēt.',
      'topic': 'Mock exam review',
      'vocabulary': '["dzimšanas diena - birthday", "ballīte - party", "aicināt - to invite", "sestdiena - Saturday", "plkst. - at (time)", "lūdzu - please", "atbildēt - to reply"]',
      'modelAnswer': 'Sveiks! Es aicinu tevi uz savu dzimšanas dienas ballīti sestdien, pulksten sešos vakarā. Ballīte būs manā mājā. Lūdzu, atbildi, vai tu varēsi nākt! Ar prieku gaidīšu tevi ciemos.'
    },
  ];

  for (final prompt in prompts) {
    await db.insert('writing_prompts', {
      'id': null,
      'title': prompt['title'],
      'promptEn': prompt['promptEn'],
      'promptLv': prompt['promptLv'],
      'topic': prompt['topic'],
      'vocabulary': prompt['vocabulary'],
      'modelAnswer': prompt['modelAnswer'],
    });
  }
}

/// Seed reading passages (shared by fresh install and DB upgrade)
Future<void> seedReadingPassages(Database db) async {
  final passages = [
    {
      'title': 'My Day in Riga',
      'textLv': 'Es dzīvoju Rīgā, Latvijas galvaspilsētā. Katru rītu es eju uz darbu ar autobusu. Mana darba diena sākas pulksten deviņos. Pusdienas pārtraukumā es bieži eju uz kafejnīcu netālu no biroja. Pēc darba man patīk pastaigāties pa Vecrīgu. Vecrīgā ir daudz skaistu vecu ēku un interesantu veikalu. Brīvdienās es bieži satiekos ar draugiem un mēs kopā ietam uz restorānu vai kino.',
      'textEn': 'I live in Riga, the capital of Latvia. Every morning I go to work by bus. My work day starts at nine o\'clock. During lunch break I often go to a café near the office. After work I like to walk around Old Riga. In Old Riga there are many beautiful old buildings and interesting shops. On weekends I often meet with friends and we go to a restaurant or cinema together.',
      'topic': 'Daily life',
      'vocabulary': '["galvaspilsēta - capital city", "pārtraukums - break", "pastaigāties - to walk/stroll", "kafejnīca - café", "ēka - building", "veikals - shop", "kino - cinema"]',
      'questions': '[{"question":"Where does the person live?","options":["Jurmala","Riga","Sigulda","Daugavpils"],"correctIndex":1},{"question":"How does the person go to work?","options":["By car","By bus","By tram","By foot"],"correctIndex":1},{"question":"What does the person do after work?","options":["Goes home","Walks around Old Riga","Goes to the gym","Reads a book"],"correctIndex":1}]'
    },
    {
      'title': 'Latvian Weather',
      'textLv': 'Latvijā ir četri gadalaiki: pavasaris, vasara, rudens un ziema. Pavasarī laiks ir siltāks un dienas kļūst garākas. Vasarā ir silts, un temperatūra bieži ir ap 25 grādiem. Tas ir labākais laiks, lai peldētos jūrā un ceļotu. Rudenī laiks kļūst vēsāks, un bieži līst lietus. Koki kļūst dzelteni un sarkani. Ziemā ir auksts, un bieži snieg. Temperatūra var būt līdz -20 grādiem. Latvieši ziemā slēpo un slido.',
      'textEn': 'Latvia has four seasons: spring, summer, autumn and winter. In spring the weather is warmer and the days get longer. In summer it is warm and the temperature is often around 25 degrees. It is the best time to swim in the sea and travel. In autumn the weather becomes cooler and it often rains. The trees become yellow and red. In winter it is cold and it often snows. The temperature can be down to -20 degrees. Latvians ski and ice skate in winter.',
      'topic': 'Weather',
      'vocabulary': '["gadalaiks - season", "pavasaris - spring", "rudens - autumn", "ziema - winter", "snieg - snows", "slēpo - skis", "slido - ice skates"]',
      'questions': '[{"question":"How many seasons does Latvia have?","options":["Two","Three","Four","Six"],"correctIndex":2},{"question":"What is the best time to swim in the sea?","options":["Spring","Summer","Autumn","Winter"],"correctIndex":1},{"question":"What happens in autumn?","options":["It snows","It often rains","It is very hot","Days get longer"],"correctIndex":1}]'
    },
    {
      'title': 'Latvian Cuisine',
      'textLv': 'Latviešu virtuve ir vienkārša un garšīga. Tradicionālie ēdieni ir rudzu maize, pelēkie zirņi ar speķi, skābēti kāposti un kartupeļi. Ļoti populārs ir arī biezpiena siers ar ķimenēm. Zupas ir svarīga latviešu ēdienkartes daļa. Aukstā zupa, ko gatavo no bietēm, kefīra un zaļumiem, ir īpaši iecienīta vasarā. Dzērieni: latvieši dzer daudz kafijas, bet tradicionālais dzēriens ir kvass. Alus ir arī populārs, un Latvijā ir daudz mazu alus darītavu.',
      'textEn': 'Latvian cuisine is simple and tasty. Traditional dishes are rye bread, grey peas with bacon, sauerkraut and potatoes. Also very popular is cottage cheese with caraway seeds. Soups are an important part of the Latvian menu. Cold soup made from beets, kefir and herbs is especially popular in summer. Drinks: Latvians drink a lot of coffee, but the traditional drink is kvass. Beer is also popular and Latvia has many small breweries.',
      'topic': 'Food',
      'vocabulary': '["virtuve - cuisine/kitchen", "rudzu maize - rye bread", "speķis - bacon", "skābēti kāposti - sauerkraut", "biezpiena siers - cottage cheese", "ķimenes - caraway seeds", "alus darītava - brewery"]',
      'questions': '[{"question":"What is a traditional Latvian drink?","options":["Wine","Kvass","Tea","Lemonade"],"correctIndex":1},{"question":"When is cold soup especially popular?","options":["Winter","Summer","Spring","All year"],"correctIndex":1},{"question":"What bread is traditional in Latvia?","options":["White bread","Rye bread","Sourdough","Wheat bread"],"correctIndex":1}]'
    },
    {
      'title': 'At the Market',
      'textLv': 'Rīgas Centrāltirgus ir viens no lielākajiem tirgiem Eiropā. Tas atrodas pie Centrālās stacijas. Tirgū var nopirkt svaigus dārzeņus, augļus, gaļu, zivis un piena produktus. Pavāri un mājsaimnieces šeit iepērkas katru dienu. Cenas tirgū ir zemākas nekā veikalā. Sestdienas rītā tirgū ir ļoti daudz cilvēku. Es parasti pērku ābolus, burkānus un svaigu maizi. Pārdevēji ir draudzīgi un bieži dod paraugus bez maksas.',
      'textEn': 'Riga Central Market is one of the largest markets in Europe. It is located near the Central Station. At the market you can buy fresh vegetables, fruits, meat, fish and dairy products. Cooks and housewives shop here every day. Prices at the market are lower than at the store. On Saturday morning there are many people at the market. I usually buy apples, carrots and fresh bread. The sellers are friendly and often give free samples.',
      'topic': 'Shopping',
      'vocabulary': '["tirgus - market", "svaigs - fresh", "dārzenis - vegetable", "gaļa - meat", "zivs - fish", "pārdevējs - seller", "draudzīgs - friendly", "paraugs - sample"]',
      'questions': '[{"question":"Where is the Central Market located?","options":["In Old Riga","Near the Central Station","In the suburbs","Near the airport"],"correctIndex":1},{"question":"Why do people shop at the market?","options":["It is closer","Prices are lower","It is open 24/7","They only sell organic"],"correctIndex":1},{"question":"What does the speaker usually buy?","options":["Meat and fish","Apples, carrots and bread","Only vegetables","Dairy products"],"correctIndex":1}]'
    },
    {
      'title': 'A Letter from Liepaja',
      'textLv': 'Sveiks, Jāni! Es šobrīd esmu Liepājā. Šī pilsēta ir ļoti skaista un atrodas pie jūras. Laiks šeit ir lielisks - saule spīd un ir silts. Vakar es staigāju pa pludmali un vācu gliemežvākus. Šodien es apmeklēju Liepājas muzeju un veco cietumu. Rīt es braukšu uz Kolkas ragu, kas ir viens no skaistākajiem vietām Latvijā. Diemžēl man jāatgriežas Rīgā pirmdien. Satiksimies pēc nedēļas! Ar mīlestību, Liene.',
      'textEn': 'Hi Janis! I am currently in Liepaja. This city is very beautiful and is located by the sea. The weather here is great - the sun is shining and it is warm. Yesterday I walked on the beach and collected seashells. Today I visited the Liepaja museum and the old prison. Tomorrow I will travel to Kolka Cape, which is one of the most beautiful places in Latvia. Unfortunately I have to return to Riga on Monday. See you in a week! With love, Liene.',
      'topic': 'Travel',
      'vocabulary': '["šobrīd - currently/right now", "pludmale - beach", "gliemežvāks - seashell", "cietums - prison", "rags - cape", "diemžēl - unfortunately", "mīlestība - love"]',
      'questions': '[{"question":"Where is Liene now?","options":["Riga","Liepaja","Kolka","Jurmala"],"correctIndex":1},{"question":"What did Liene do yesterday?","options":["Visited a museum","Walked on the beach","Went to a restaurant","Shopped at the market"],"correctIndex":1},{"question":"When does Liene return to Riga?","options":["Today","Tomorrow","Monday","Friday"],"correctIndex":2}]'
    },
    {
      'title': 'Health Advice',
      'textLv': 'Lai būtu vesels, ir svarīgi ēst veselīgu pārtiku un sportot. Ārsti iesaka ēst daudz augļu un dārzeņu, dzert ūdeni un gulēt vismaz astoņas stundas naktī. Regulāras fiziskās aktivitātes, piemēram, skriešana, peldēšana vai riteņbraukšana, palīdz uzturēt labu formu. Ir arī svarīgi izvairīties no stresa un pavadīt laiku ārā svaigā gaisā. Ja jūtaties slikti, labāk palieciet mājās, atpūtieties un dzeriet daudz šķidruma.',
      'textEn': 'To be healthy it is important to eat healthy food and exercise. Doctors recommend eating lots of fruits and vegetables, drinking water and sleeping at least eight hours at night. Regular physical activities like running, swimming or cycling help maintain good shape. It is also important to avoid stress and spend time outside in fresh air. If you feel unwell, it is better to stay home, rest and drink plenty of fluids.',
      'topic': 'Health',
      'vocabulary': '["vesels - healthy", "iesaka - recommend", "vismaz - at least", "regulārs - regular", "skriešana - running", "peldēšana - swimming", "riteņbraukšana - cycling", "šķidrums - fluid"]',
      'questions': '[{"question":"How many hours of sleep do doctors recommend?","options":["Six","Seven","Eight","Ten"],"correctIndex":2},{"question":"What activities help maintain good shape?","options":["Only running","Running, swimming or cycling","Only swimming","Watching TV"],"correctIndex":1},{"question":"What should you do if you feel unwell?","options":["Go to work","Stay home and rest","Exercise more","Eat more food"],"correctIndex":1}]'
    },
    {
      'title': 'A Job Advertisement',
      'textLv': 'Uzņēmums "Baltic Tech" meklē jaunu darbinieku. Mēs piedāvājam darbu birojā Rīgas centrā. Darba laiks ir no pirmdienas līdz piektdienai, no deviņiem rītā līdz pieciem vakarā. Mēs meklējam cilvēku, kurš runā latviski, angliski un krieviski. Ir nepieciešama pieredze darbā ar datoriem un klientu apkalpošanā. Mēs piedāvājam labu algu, veselības apdrošināšanu un apmaksātus brīvdienas. Lūdzu, sūtiet savu CV uz e-pastu: darbs@baltictech.lv.',
      'textEn': 'The company Baltic Tech is looking for a new employee. We offer an office job in the center of Riga. Working hours are Monday to Friday from nine in the morning to five in the evening. We are looking for a person who speaks Latvian, English and Russian. Experience with computers and customer service is required. We offer a good salary, health insurance and paid vacation. Please send your CV to email: darbs@baltictech.lv.',
      'topic': 'Work',
      'vocabulary': '["uzņēmums - company", "darbinieks - employee", "piedāvāt - to offer", "pieredze - experience", "alga - salary", "apdrošināšana - insurance", "apmaksāts - paid", "CV - resume"]',
      'questions': '[{"question":"What company is hiring?","options":["Riga Tech","Baltic Tech","Latvian Tech","Nordic Tech"],"correctIndex":1},{"question":"What languages are required?","options":["Only Latvian","Latvian and English","Latvian, English and Russian","All European languages"],"correctIndex":2},{"question":"Which benefit is NOT mentioned?","options":["Good salary","Health insurance","Company car","Paid vacation"],"correctIndex":2}]'
    },
    {
      'title': 'My Hometown',
      'textLv': 'Es esmu dzimis un audzis Cēsīs, kas ir neliela pilsēta Vidzemē. Cēsis ir pazīstamas ar savu skaisto viduslaiku pili un veco parku. Manā bērnībā es bieži spēlējos pilī un apkārtējos mežos. Cēsīs ir arī mākslas muzejs un vairākas kafejnīcas. Cilvēki šeit ir ļoti draudzīgi un viesmīlīgi. Katru vasaru Cēsīs notiek mūzikas festivāls, kas piesaista tūristus no visas Latvijas un citām valstīm. Man ļoti patīk mana dzimtā pilsēta!',
      'textEn': 'I was born and raised in Cesis, which is a small town in Vidzeme. Cesis is known for its beautiful medieval castle and old park. In my childhood I often played in the castle and surrounding forests. In Cesis there is also an art museum and several cafes. The people here are very friendly and hospitable. Every summer there is a music festival in Cesis that attracts tourists from all over Latvia and other countries. I really like my hometown!',
      'topic': 'Life stories',
      'vocabulary': '["dzimis - born", "audzis - raised", "viduslaiku - medieval", "pils - castle", "bērnība - childhood", "viesmīlīgs - hospitable", "festivāls - festival", "piesaistīt - to attract", "dzimtā pilsēta - hometown"]',
      'questions': '[{"question":"What is Cesis known for?","options":["Beach","Medieval castle","Skyscrapers","Airport"],"correctIndex":1},{"question":"What event happens every summer in Cesis?","options":["A sports competition","A music festival","A food fair","A book fair"],"correctIndex":1},{"question":"Where is Cesis located?","options":["In Latgale","In Vidzeme","In Kurzeme","In Zemgale"],"correctIndex":1}]'
    },
    {
      'title': 'Transport in Riga',
      'textLv': 'Rīgā ir laba sabiedriskā transporta sistēma. Pilsētā kursē autobusi, tramvaji un trolejbusi. Biļeti var nopirkt pie vadītāja vai izmantot e-talonu. Viena brauciena biļete maksā 1.50 eiro, bet mēneša biļete ir daudz lētāka, ja braucat katru dienu. Tramvajs ir ātrākais transporta veids pilsētā, jo tas brauc pa savām sliedēm un neiestrēgst sastrēgumos. Rīgā ir arī vilcieni, kas savieno pilsētu ar priekšpilsētām un citām Latvijas pilsētām.',
      'textEn': 'Riga has a good public transport system. Buses, trams and trolleybuses operate in the city. A ticket can be bought from the driver or using an e-card. A single trip ticket costs 1.50 euros, but a monthly ticket is much cheaper if you travel every day. The tram is the fastest mode of transport in the city because it runs on its own tracks and does not get stuck in traffic jams. Riga also has trains that connect the city with suburbs and other Latvian cities.',
      'topic': 'Transport',
      'vocabulary': '["sabiedriskais transports - public transport", "kursēt - to operate/run", "tramvajs - tram", "trolejbuss - trolleybus", "vadītājs - driver", "e-talons - e-card", "sliedes - tracks", "sastrēgums - traffic jam", "priekšpilsēta - suburb"]',
      'questions': '[{"question":"How much does a single trip ticket cost?","options":["1 euro","1.50 euros","2 euros","2.50 euros"],"correctIndex":1},{"question":"Why is the tram the fastest?","options":["It goes underground","It has its own tracks","It has fewer stops","It is electric"],"correctIndex":1},{"question":"What connects Riga with other cities?","options":["Only buses","Trains","Only trams","Airplanes"],"correctIndex":1}]'
    },
    {
      'title': 'Mārtiņš and the Library',
      'textLv': 'Mārtiņš ir students. Viņš mācās Latvijas Universitātē. Katru dienu viņš iet uz bibliotēku, lai lasītu grāmatas un gatavotos eksāmeniem. Bibliotēka ir liela un klusa. Tur ir daudz grāmatu par vēsturi, ģeogrāfiju un literatūru. Mārtiņam visvairāk patīk lasīt par Latvijas vēsturi. Bibliotēkā ir arī datori un bezmaksas internets. Studenti var izmantot šos pakalpojumus bez maksas. Mārtiņš pavada bibliotēkā apmēram trīs stundas katru dienu. Viņš saka, ka bibliotēka ir viņa otrās mājas.',
      'textEn': 'Martins is a student. He studies at the University of Latvia. Every day he goes to the library to read books and prepare for exams. The library is big and quiet. There are many books about history, geography and literature. Martins likes to read about Latvian history the most. The library also has computers and free internet. Students can use these services for free. Martins spends about three hours in the library every day. He says the library is his second home.',
      'topic': 'Education',
      'vocabulary': '["students - student", "universitāte - university", "bibliotēka - library", "eksāmens - exam", "vēsture - history", "ģeogrāfija - geography", "literatūra - literature", "pavadīt - to spend (time)"]',
      'questions': '[{"question":"Where does Martins study?","options":["Riga Technical University","University of Latvia","University of Liepaja","Culture Academy"],"correctIndex":1},{"question":"What does Martins like to read about most?","options":["Geography","Literature","Latvian history","Science"],"correctIndex":2},{"question":"How many hours does Martins spend at the library daily?","options":["One hour","Two hours","Three hours","Four hours"],"correctIndex":2}]'
    },
  ];

  for (final passage in passages) {
    await db.insert('reading_passages', {
      'id': null,
      'title': passage['title'],
      'textLv': passage['textLv'],
      'textEn': passage['textEn'],
      'topic': passage['topic'],
      'vocabulary': passage['vocabulary'],
      'questions': passage['questions'],
    });
  }
}
