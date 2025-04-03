import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../../data/db/database_helper.dart';

class TestDataScreen extends StatefulWidget {
  const TestDataScreen({super.key});

  @override
  State<TestDataScreen> createState() => _TestDataScreenState();
}

class _TestDataScreenState extends State<TestDataScreen> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final db = await dbHelper.database;

    final result = await db.rawQuery('''
      SELECT q.id as question_id, q.question, q.explanation,
             a.answer, a.is_correct
      FROM questions q
      JOIN answers a ON q.id = a.question_id
      ORDER BY q.id
    ''');

    setState(() {
      questions = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧪 Test Questions')),
      body: questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final q = questions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(q['question'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• ${q['answer']}"),
                        if (q['is_correct'] == 1)
                          const Text("✅ Correct", style: TextStyle(color: Colors.green))
                        else
                          const Text("❌ Incorrect", style: TextStyle(color: Colors.red)),
                        if (q['explanation'] != null && q['explanation'].toString().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text("🧠 ${q['explanation']}"),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
// This code is a Flutter widget that displays a list of questions and their answers from a SQLite database.
// It uses the sqflite package to interact with the database and fetch data.
// The questions are displayed in a ListView, and each question is shown in a Card widget with its answer and correctness status.
// The widget also includes an AppBar with the title "Test Questions".
// The questions are loaded from the database in the initState method, and a CircularProgressIndicator is shown while loading.
// The questions are displayed in a ListView, and each question is shown in a Card widget with its answer and correctness status.
// The widget also includes an AppBar with the title "Test Questions".
// The questions are loaded from the database in the initState method, and a CircularProgressIndicator is shown while loading.