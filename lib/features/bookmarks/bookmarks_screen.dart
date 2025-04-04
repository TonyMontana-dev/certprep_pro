import 'package:flutter/material.dart';
import '../../services/question_service.dart';
import '../../data/models/question.dart';
import '../../data/models/answer.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final QuestionService _service = QuestionService();

  List<Question> _bookmarkedQuestions = [];
  List<List<Answer>> _bookmarkedAnswers = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final db = await _service.dbHelper.database;

    final bookmarks = await db.rawQuery('''
      SELECT q.*
      FROM bookmarks b
      JOIN questions q ON q.id = b.question_id
      ORDER BY b.timestamp DESC
    ''');

    final questions = bookmarks.map((row) => Question.fromMap(row)).toList();
    final allAnswers = await Future.wait(
      questions.map((q) => _service.getAnswersForQuestion(q.id!)),
    );

    setState(() {
      _bookmarkedQuestions = questions;
      _bookmarkedAnswers = allAnswers;
    });
  }

  Future<void> _removeBookmark(int questionId) async {
    final db = await _service.dbHelper.database;
    await db.delete('bookmarks', where: 'question_id = ?', whereArgs: [questionId]);
    _loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bookmarked Questions")),
      body: _bookmarkedQuestions.isEmpty
          ? const Center(child: Text("You haven’t saved any questions yet."))
          : ListView.builder(
              itemCount: _bookmarkedQuestions.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final q = _bookmarkedQuestions[index];
                final a = _bookmarkedAnswers[index];
                final correct = a.firstWhere((ans) => ans.isCorrect);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.question,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text("✅ ${correct.answer}",
                            style: const TextStyle(color: Colors.tealAccent)),
                        if (q.explanation != null) ...[
                          const SizedBox(height: 6),
                          Text("🧠 ${q.explanation!}",
                              style: const TextStyle(color: Colors.white70)),
                        ],
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () => _removeBookmark(q.id!),
                            icon: const Icon(Icons.bookmark_remove_outlined, color: Colors.redAccent),
                            tooltip: "Remove from bookmarks",
                          ),
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
