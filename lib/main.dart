import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'database/database_helper.dart';
import 'database/db_factory.dart';
import 'providers/lesson_provider.dart';
import 'providers/practice_provider.dart';
import 'providers/mistake_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure the sqflite database factory for the current platform.
  // No-op on mobile/desktop; on web this swaps in sqflite_common_ffi_web.
  await initDatabaseFactory();

  // Request microphone permission
  await Permission.microphone.request();

  // Initialize database (the `database` getter triggers _initDB on first access)
  await DatabaseHelper.instance.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => PracticeProvider()),
        ChangeNotifierProvider(create: (_) => MistakeProvider()),
      ],
      child: MaterialApp(
        title: 'Latvian A2 Exam',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
