import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../../services/question_service.dart';
import '../../data/models/question.dart';
import '../../data/models/answer.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final QuestionService _service = QuestionService();
  List<Question> _questions = [];
  List<List<Answer>> _answers = [];

  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    final qs = await _service.getQuestions(examId: 1);
    final allAns = await Future.wait(qs.map((q) => _service.getAnswersForQuestion(q.id!)));

    setState(() {
      _questions = qs;
      _answers = allAns;
    });
  }

  void _flipCard() {
    setState(() => _showAnswer = !_showAnswer);
  }

  void _nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _questions.length;
      _showAnswer = false;
    });
  }

  void _prevCard() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _questions.length) % _questions.length;
      _showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final q = _questions[_currentIndex];
    final correctAnswer = _answers[_currentIndex].firstWhere((a) => a.isCorrect);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flashcards"),
        actions: [
          IconButton(
            tooltip: "Back to Home",
            icon: const Icon(Icons.home),
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
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Flashcard ${_currentIndex + 1}/${_questions.length}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GestureDetector(
                onTap: _flipCard,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Center(
                    child: _showAnswer
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                correctAnswer.answer,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.tealAccent,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              if (q.explanation != null)
                                Text(
                                  q.explanation!,
                                  style: const TextStyle(color: Colors.white70),
                                  textAlign: TextAlign.center,
                                ),
                            ],
                          )
                        : Text(
                            q.question,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _prevCard,
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white38),
                ),
                ElevatedButton(
                  onPressed: _flipCard,
                  child: Text(_showAnswer ? "Hide Answer" : "Show Answer"),
                ),
                IconButton(
                  onPressed: _nextCard,
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white38),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// This code is a Flutter widget that represents a flashcard screen. It allows users to view questions and their corresponding answers, flipping the card to reveal the answer when tapped. The user can navigate through the questions using next and previous buttons, and it also includes a back button to return to the home screen.
// The screen fetches questions and answers from a service, displays them in a card format, and provides a loading indicator while fetching data. The design is responsive and adapts to different screen sizes.