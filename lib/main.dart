import 'package:flutter/foundation.dart';
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

  try {
    debugPrint("App initialization started...");
    await initDatabaseFactory();
    debugPrint("Database factory initialized.");

    if (!kIsWeb) {
      debugPrint("Requesting microphone permission...");
      await Permission.microphone.request();
      debugPrint("Microphone permission requested.");
    }

    debugPrint("Initializing database...");
    await DatabaseHelper.instance.database;
    debugPrint("Database initialized successfully.");
  } catch (e, stack) {
    debugPrint("ERROR during initialization: $e");
    debugPrint(stack.toString());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => PracticeProvider()),
        ChangeNotifierProvider(create: (_) => MistakeProvider()),
      ],
      child: MaterialApp(
        title: 'Latvian A2',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF5E5CE6),
            brightness: Brightness.light,
            primary: const Color(0xFF5E5CE6),
            secondary: const Color(0xFF30D158),
            surface: Colors.white,
          ),
          scaffoldBackgroundColor: const Color(0xFFF9FAFB),
          fontFamily: 'SF Pro Display',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Color(0xFF1C1C1E),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
            iconTheme: IconThemeData(color: Color(0xFF5E5CE6)),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFE5E5EA), width: 1),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5E5CE6),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
