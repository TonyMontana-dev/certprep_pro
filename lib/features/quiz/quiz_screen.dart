import 'package:flutter/material.dart';
import 'package:certprep_pro/features/quiz/quiz_summary_screen.dart';
import '../../services/question_service.dart';
import '../../data/models/question.dart';
import '../../data/models/answer.dart';

class QuizScreen extends StatefulWidget {
  final int examId;
  final int? domainId;

  const QuizScreen({super.key, required this.examId, this.domainId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuestionService _service = QuestionService();

  DateTime? _questionStartTime;
  int _totalTimeSeconds = 0;
  final List<Map<String, dynamic>> _quizResults = [];

  List<Question> _questions = [];
  List<List<Answer>> _answers = [];

  int _currentIndex = 0;
  int? _selectedAnswerIndex;
  bool _showExplanation = false;

  final Map<int, int> _attemptsPerQuestion = {}; // ID → attempt count
  final Set<int> _answeredQuestions = {};        // Prevent duplicate saves
  bool _isLocked = false;                        // Block input after 2 wrong

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _startTimerForQuestion() {
    _questionStartTime = DateTime.now();
  }

  Future<void> _loadQuestions() async {
    final questions = await _service.getQuestions(
      examId: widget.examId,
      domainId: widget.domainId,
    );
    final allAnswers = await Future.wait(
      questions.map((q) => _service.getAnswersForQuestion(q.id!)),
    );

    setState(() {
      _questions = questions;
      _answers = allAnswers;
    });

    _startTimerForQuestion();
  }

  void _selectAnswer(int index) {
    if (_isLocked || _selectedAnswerIndex != null) return;

    setState(() {
      _selectedAnswerIndex = index;
      _showExplanation = true;
    });

    final timeSpent = DateTime.now().difference(_questionStartTime!).inSeconds;
    _totalTimeSeconds += timeSpent;

    final question = _questions[_currentIndex];
    final answers = _answers[_currentIndex];
    final isCorrect = answers[index].isCorrect;

    _attemptsPerQuestion[question.id!] = (_attemptsPerQuestion[question.id!] ?? 0) + 1;

    if (!_answeredQuestions.contains(question.id!)) {
      _quizResults.add({
        'questionId': question.id!,
        'isCorrect': isCorrect,
        'domainId': question.domainId,
        'examId': question.examId,
        'timeSpent': timeSpent,
      });
      _answeredQuestions.add(question.id!);
    }

    if (isCorrect || _attemptsPerQuestion[question.id!]! >= 2) {
      _isLocked = true;
    }
  }

  void _nextQuestion() {
    if (_currentIndex == _questions.length - 1) {
      _endQuiz();
    } else {
      setState(() {
        _currentIndex++;
        _selectedAnswerIndex = null;
        _showExplanation = false;
        _isLocked = false;
      });
      _startTimerForQuestion();
    }
  }

  Future<void> _endQuiz() async {
    await _service.saveQuizResult(
      examId: _questions.first.examId,
      totalTimeSeconds: _totalTimeSeconds,
      results: _quizResults,
    );

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => QuizSummaryScreen(
          totalQuestions: _quizResults.length,
          correctAnswers: _quizResults.where((r) => r['isCorrect'] == true).length,
          totalTimeSeconds: _totalTimeSeconds,
        ),
        transitionsBuilder: (_, animation, __, child) {
          final slide = Tween(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
          final fade = Tween(begin: 0.0, end: 1.0).animate(animation);
          return FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions[_currentIndex];
    final answers = _answers[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Practice"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Question ${_currentIndex + 1}/${_questions.length}",
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Text(question.question,
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 20),
                      ...List.generate(answers.length, (i) {
                        final isCorrect = answers[i].isCorrect;
                        final isSelected = _selectedAnswerIndex == i;
                        final showResult = _showExplanation;

                        Color? bgColor;
                        if (showResult) {
                          if (isCorrect) {
                            bgColor = Colors.green.withOpacity(0.2);
                          } else if (isSelected) {
                            bgColor = Colors.red.withOpacity(0.2);
                          }
                        } else if (isSelected) {
                          bgColor = Colors.teal.withOpacity(0.3);
                        }

                        return GestureDetector(
                          onTap: () => _selectAnswer(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: bgColor ?? Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.tealAccent
                                    : Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                answers[i].answer,
                                style: TextStyle(
                                  color: showResult && isCorrect
                                      ? Colors.green
                                      : isSelected
                                          ? Colors.tealAccent
                                          : Colors.white70,
                                  fontWeight: isSelected ? FontWeight.bold : null,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                      if (_showExplanation && question.explanation != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("🧠 ${question.explanation!}",
                              style: const TextStyle(color: Colors.white70)),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _showExplanation ? _nextQuestion : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Next"),
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_add_outlined,
                        color: Colors.tealAccent),
                    tooltip: "Bookmark this question",
                    onPressed: () async {
                      final db = await _service.dbHelper.database;
                      final alreadyBookmarked = await db.query(
                        'bookmarks',
                        where: 'question_id = ?',
                        whereArgs: [_questions[_currentIndex].id],
                      );

                      if (alreadyBookmarked.isEmpty) {
                        await db.insert('bookmarks', {
                          'question_id': _questions[_currentIndex].id,
                          'timestamp': DateTime.now().toIso8601String(),
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Question bookmarked!")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Already bookmarked")),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
