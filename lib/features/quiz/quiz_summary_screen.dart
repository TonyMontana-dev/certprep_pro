import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class QuizSummaryScreen extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final int totalTimeSeconds;

  const QuizSummaryScreen({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalTimeSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final accuracy = totalQuestions == 0 ? 0 : (correctAnswers / totalQuestions * 100);
    final duration = Duration(seconds: totalTimeSeconds);
    final timeFormatted = "${duration.inMinutes}m ${duration.inSeconds % 60}s";

    return Scaffold(
      appBar: AppBar(title: const Text("Quiz Summary")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text("✅ Quiz Completed!", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            _summaryRow("Total Questions:", "$totalQuestions"),
            _summaryRow("Correct Answers:", "$correctAnswers"),
            _summaryRow("Accuracy:", "${accuracy.toStringAsFixed(1)}%"),
            _summaryRow("Time Spent:", timeFormatted),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const HomeScreen(),
                    transitionsBuilder: (_, animation, __, child) {
                      final slide = Tween(begin: const Offset(0, 1), end: Offset.zero)
                          .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
                      final fade = Tween(begin: 0.0, end: 1.0).animate(animation);
                      return FadeTransition(
                        opacity: fade,
                        child: SlideTransition(position: slide, child: child),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 350),
                  ),
                );
              },
              icon: const Icon(Icons.home),
              label: const Text("Back to Home"),
            )
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.tealAccent)),
        ],
      ),
    );
  }
}
