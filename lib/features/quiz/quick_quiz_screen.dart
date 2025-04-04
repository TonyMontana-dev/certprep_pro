import 'package:flutter/material.dart';
import '../../services/question_service.dart';
import 'quiz_screen.dart';

class QuickQuizScreen extends StatelessWidget {
  const QuickQuizScreen({super.key});

  Future<void> _startQuickQuiz(BuildContext context) async {
    final service = QuestionService();
    final questions = await service.getRandomQuestions(limit: 10); // 🧠 We'll add this

    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Not enough questions available.")),
      );
      return;
    }

    final examId = questions.first.examId;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(examId: examId), // Optional: you can support custom list later
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quick Quiz")),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.flash_on),
          label: const Text("Start Random 10"),
          onPressed: () => _startQuickQuiz(context),
        ),
      ),
    );
  }
}
