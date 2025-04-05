/// CertPrep Pro
/// A Flutter application for exam preparation.
/// This app provides a platform for users to prepare for various certification exams.
/// It includes features like quizzes, flashcards, and study materials.
///
/// Copyright (c) 2025 CertPrep Pro
/// GNU General Public License v3.0
/// Created by: TonyMontana-dev & ChatGPT 4o
library;

import 'package:certprep_pro/data/db/database_helper.dart';
import 'package:flutter/material.dart';
import 'features/quiz/quiz_screen.dart';
import 'data/settings/settings_service.dart';
import 'features/startup/startup_transition.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<void> resetDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, 'certprep.db');
  final exists = await File(path).exists();
  if (exists) {
    await File(path).delete();
    print("✅ Database deleted. Restart the app to reload fresh data.");
  } else {
    print("❌ Database not found. No deletion necessary.");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await resetDatabase(); // Uncomment to reset the database

  final db = await DatabaseHelper().database; // 🔧 Ensure DB is created first
  await DatabaseHelper().syncQuestionBankIfNeeded(); // 🔁 Now safe to sync

  final settings = SettingsService();
  final darkMode = await settings.getDarkMode();

  runApp(MyApp(darkMode: darkMode));
}

class MyApp extends StatelessWidget {
  final bool darkMode;
  const MyApp({super.key, required this.darkMode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CertPrep Pro',
      debugShowCheckedModeBanner: false,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.dark(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const SplashToHomeTransition(), // 👈 Start with fade-in Home
      routes: {
        '/quiz': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return QuizScreen(
            examId: args['examId'],
            domainId: args['domainId'],
          );
        },
      },
    );
  }
}
