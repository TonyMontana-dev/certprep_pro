import 'package:flutter/material.dart';
import 'package:certprep_pro/features/analytics/analystics_screen.dart';
import 'package:certprep_pro/features/bookmarks/bookmarks_screen.dart';
import 'package:certprep_pro/features/flashcards/flashcard_screen.dart';
import 'package:certprep_pro/features/quiz/quiz_launcher_screen.dart';
import 'package:certprep_pro/features/quiz/quick_quiz_screen.dart';
import 'package:certprep_pro/data/settings/settings_screen.dart';

/// Smooth slide transition for screen changes
void animateTo(BuildContext context, Widget screen) {
  Navigator.of(context).push(PageRouteBuilder(
    pageBuilder: (_, __, ___) => screen,
    transitionsBuilder: (_, animation, __, child) {
      final slide = Tween(begin: const Offset(1, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
      final fade = Tween(begin: 0.0, end: 1.0).animate(animation);

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 350),
  ));
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      {
        'label': 'Start Quiz',
        'icon': Icons.quiz_outlined,
        'screen': const QuizLauncherScreen(),
      },
      {
        'label': 'Flashcards',
        'icon': Icons.style_outlined,
        'screen': const FlashcardScreen(),
      },
      {
        'label': 'Analytics',
        'icon': Icons.bar_chart_outlined,
        'screen': const AnalyticsScreen(),
      },
      {
        'label': 'Bookmarks',
        'icon': Icons.bookmark_outline,
        'screen': const BookmarksScreen(),
      },
      {
        'label': 'Quick Quiz',
        'icon': Icons.flash_on,
        'screen': const QuickQuizScreen(),
      },
      {
        'label': 'Settings',
        'icon': Icons.settings_outlined,
        'screen': const SettingsScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('CertPrep Pro'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          itemCount: options.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final item = options[index];
            return GestureDetector(
              onTap: () {
                animateTo(context, item['screen'] as Widget);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    Icon(item['icon'] as IconData, color: Colors.tealAccent),
                    const SizedBox(width: 16),
                    Text(
                      item['label'] as String,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: Colors.white38),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
