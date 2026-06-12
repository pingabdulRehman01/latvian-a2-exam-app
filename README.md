# Latvian A2 Exam Practice App

A Flutter mobile app designed to help users prepare for the Latvian A2 language exam in 30 days through interactive speech-to-text practice.

## Features

- **4 Core Screens**
  - Home Dashboard: Track progress and statistics
  - Lesson List: Browse 10 daily lessons
  - Practice Screen: Speak phrases and get instant feedback
  - Mistake Review: Review and retry weak phrases

- **Speech-to-Text Integration**
  - Record your voice speaking Latvian phrases
  - Automatic transcription using `speech_to_text` plugin
  - Real-time feedback on pronunciation and word accuracy

- **Smart Scoring**
  - Word-level comparison between spoken and target phrases
  - Score categories: Correct (80-100%), Almost correct (60-79%), Needs work (<60%)
  - Detailed feedback highlighting missing or extra words

- **Progress Tracking**
  - Local SQLite database for storing attempts and progress
  - Analytics dashboard showing:
    - Total attempts
    - Accuracy percentage
    - Mistakes to review
    - Overall progress

- **30-Day Learning Plan**
  - 10 lessons covering essential A2 topics:
    - Day 1: Introduce yourself
    - Day 2: Family
    - Day 3: Numbers and time
    - Day 4: Shopping
    - Day 5: Food and drink
    - Day 6: Directions
    - Day 7: Daily routine
    - Day 8: Work and hobbies
    - Day 9: Health and well-being
    - Day 10: Mock exam review

## Tech Stack

- **Frontend**: Flutter
- **State Management**: Provider
- **Database**: SQLite (via sqflite)
- **Speech Recognition**: speech_to_text
- **Permissions**: permission_handler
- **Localization**: intl

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- iOS/Android development environment

### Installation

1. Clone the repository
```bash
git clone https://github.com/pingabdulRehman01/latvian-a2-exam-app.git
cd latvian-a2-exam-app
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── lesson.dart          # Lesson model
│   ├── phrase.dart          # Phrase model
│   ├── attempt.dart         # Attempt record model
│   └── mistake.dart         # Mistake tracking model
├── database/
│   ├── database_helper.dart # SQLite operations
│   └── db_seed.dart         # Database initialization
├── services/
│   ├── speech_service.dart  # Speech-to-text service
│   ├── scoring_service.dart # Answer scoring logic
│   └── progress_service.dart# Progress analytics
├── providers/
│   ├── lesson_provider.dart # Lesson state management
│   ├── practice_provider.dart# Practice session state
│   └── mistake_provider.dart # Mistake tracking state
├── screens/
│   ├── home_screen.dart     # Dashboard
│   ├── lesson_list_screen.dart # Lesson selection
│   ├── practice_screen.dart # Main practice interface
│   └── mistake_review_screen.dart # Mistake review
├── widgets/
│   └── (reusable components)
└── utils/
    └── constants.dart       # App constants
```

## How It Works

### Practice Flow
1. User selects a lesson from the list
2. App displays a Latvian phrase
3. User taps and holds the microphone button to record
4. Speech is transcribed to text
5. App compares user's text with the target phrase
6. Score and feedback are displayed
7. User can retry or move to the next phrase

### Scoring Algorithm
- Normalizes both phrases (lowercase, removes special characters)
- Splits phrases into words
- Calculates match percentage based on word overlap
- Categorizes result as: Correct / Almost correct / Needs work
- Identifies missing and extra words for specific feedback

### Mistake Tracking
- Any phrase with score < 80% is automatically added to mistakes
- Users can review and retry mistakes later
- Retry count is tracked for learning analytics

## Database Schema

### Lessons table
- id (INTEGER PRIMARY KEY)
- title (TEXT)
- dayNumber (INTEGER)
- topic (TEXT)
- createdAt (TEXT)
- isCompleted (INTEGER)

### Phrases table
- id (INTEGER PRIMARY KEY)
- lessonId (INTEGER FOREIGN KEY)
- phraseLv (TEXT)
- phraseEn (TEXT)
- difficultyLevel (TEXT)

### Attempts table
- id (INTEGER PRIMARY KEY)
- phraseId (INTEGER FOREIGN KEY)
- userTranscript (TEXT)
- targetPhrase (TEXT)
- score (INTEGER)
- result (TEXT)
- createdAt (TEXT)

### Mistakes table
- id (INTEGER PRIMARY KEY)
- phraseId (INTEGER UNIQUE FOREIGN KEY)
- retryCount (INTEGER)
- lastAttempted (TEXT)
- isResolved (INTEGER)

## Future Enhancements

- [ ] Add audio playback of native speaker pronunciation
- [ ] Implement phoneme-level pronunciation analysis
- [ ] Add spaced repetition for vocabulary review
- [ ] Create mock exam mode with time limits
- [ ] Add grammar exercises and explanations
- [ ] Implement user authentication and cloud sync
- [ ] Add progress charts and analytics
- [ ] Support for more languages
- [ ] Offline mode with downloaded lessons
- [ ] AI-powered personalized learning paths

## License

MIT License - Feel free to use this project for learning purposes.

## Support

For issues or questions, please open an issue on GitHub.

## Author

Built as a learning project for Latvian A2 exam preparation.
