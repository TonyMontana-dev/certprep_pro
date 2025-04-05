import 'package:flutter/material.dart';
import '../../services/question_service.dart';

class QuizLauncherScreen extends StatefulWidget {
  const QuizLauncherScreen({super.key});

  @override
  State<QuizLauncherScreen> createState() => _QuizLauncherScreenState();
}

class _QuizLauncherScreenState extends State<QuizLauncherScreen> {
  final QuestionService _service = QuestionService();

  List<Map<String, dynamic>> _exams = [];
  List<Map<String, dynamic>> _domains = [];

  int? _selectedExamId;
  int? _selectedDomainId;

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  Future<void> _loadExams() async {
    final db = await _service.dbHelper.database;
    final exams = await db.query('exams');
    setState(() {
      _exams = exams;
    });
  }

  Future<void> _loadDomainsForExam(int examId) async {
    final db = await _service.dbHelper.database;
    final domains = await db.query(
      'domains',
      where: 'exam_id = ?',
      whereArgs: [examId],
    );
    setState(() {
      _domains = domains;
      _selectedDomainId = null; // Reset domain when exam changes
    });
  }

  void _startQuiz() {
    Navigator.of(context).pushNamed(
      '/quiz',
      arguments: {
        'examId': _selectedExamId,
        'domainId': _selectedDomainId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Exam & Topic")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "Select Exam"),
              value: _selectedExamId,
              items: _exams
                  .map((e) => DropdownMenuItem<int>(
                        value: e['id'] as int,
                        child: Text(e['title'] as String),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() => _selectedExamId = val);
                if (val != null) _loadDomainsForExam(val);
              },
            ),
            const SizedBox(height: 20),
            if (_domains.isNotEmpty)
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                    labelText: "Select Domain (Optional)"),
                value: _selectedDomainId,
                items: _domains
                    .map((d) => DropdownMenuItem<int>(
                          value: d['id'] as int,
                          child: Text(d['name'] as String),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedDomainId = val),
              ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _selectedExamId != null ? _startQuiz : null,
              icon: const Icon(Icons.play_arrow),
              label: const Text("Start Quiz"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
