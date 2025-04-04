import 'package:sqflite/sqflite.dart';
import '../data/db/database_helper.dart';
import '../data/models/question.dart';
import '../data/models/answer.dart';

class QuestionService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  DatabaseHelper get dbHelper => _dbHelper;

  Future<List<Question>> getQuestions({int? examId, int? domainId}) async {
    final db = await _dbHelper.database;

    final questionMaps = await db.query(
      'questions',
      where: examId != null && domainId != null
          ? 'exam_id = ? AND domain_id = ?'
          : examId != null
              ? 'exam_id = ?'
              : null,
      whereArgs: examId != null && domainId != null
          ? [examId, domainId]
          : examId != null
              ? [examId]
              : null,
    );

    List<Question> questions = [];

    for (var q in questionMaps) {
      final answers = await db.query(
        'answers',
        where: 'question_id = ?',
        whereArgs: [q['id']],
      );

      questions.add(
        Question(
          id: q['id'] as int,
          examId: q['exam_id'] as int,
          domainId: q['domain_id'] as int,
          question: q['question'] as String,
          explanation: q['explanation'] as String?,
        ),
      );
    }

    return questions;
  }

  Future<List<Answer>> getAnswersForQuestion(int questionId) async {
    final db = await _dbHelper.database;

    final answerMaps = await db.query(
      'answers',
      where: 'question_id = ?',
      whereArgs: [questionId],
    );

    return answerMaps
        .map((a) => Answer(
              id: a['id'] as int,
              questionId: a['question_id'] as int,
              answer: a['answer'] as String,
              isCorrect: a['is_correct'] == 1,
            ))
        .toList();
  }
  
  Future<List<Question>> getRandomQuestions({int limit = 10}) async {
    final db = await _dbHelper.database;
    final raw = await db.rawQuery('''
      SELECT * FROM questions ORDER BY RANDOM() LIMIT ?
      ''', [limit]);
      return raw.map((q) => Question.fromMap(q)).toList();
  }


  Future<void> saveQuizResult({
    required List<Map<String, dynamic>> results, // each: {questionId, isCorrect, domainId, examId, timeSpent}
    required int examId,
    required int totalTimeSeconds,
  }) async {
    final db = await _dbHelper.database;
    final batch = db.batch();

    int correctCount = 0;

    for (final res in results) {
      final bool isCorrect = res['isCorrect'];
      final int domainId = res['domainId'];

      if (isCorrect) correctCount++;

      // Update or insert stats per domain
      final existing = await db.query(
        'user_stats',
        where: 'exam_id = ? AND domain_id = ?',
        whereArgs: [examId, domainId],
      );

      if (existing.isNotEmpty) {
        batch.update(
          'user_stats',
          {
            'total_answered': (existing[0]['total_answered'] as int) + 1,
            'correct_answered': (existing[0]['correct_answered'] as int? ?? 0) + (isCorrect ? 1 : 0),
            'total_time_seconds': (existing[0]['total_time_seconds'] as int? ?? 0) + res['timeSpent']
          },
          where: 'id = ?',
          whereArgs: [existing[0]['id']],
        );
      } else {
        batch.insert('user_stats', {
          'exam_id': examId,
          'domain_id': domainId,
          'total_answered': 1,
          'correct_answered': isCorrect ? 1 : 0,
          'total_time_seconds': res['timeSpent']
        });
      }

      // Save incorrect question to retry later (optional table or reuse bookmarks)
      if (!isCorrect) {
        batch.insert('bookmarks', {
          'question_id': res['questionId'],
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    }

    // Save this as an attempt
    batch.insert('attempts', {
      'exam_id': examId,
      'score': correctCount,
      'total_questions': results.length,
      'duration_seconds': totalTimeSeconds,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await batch.commit(noResult: true);
  }
}
