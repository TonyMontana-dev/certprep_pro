import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';

Future<void> insertQuestionsFromJson(Database db) async {
  final String data = await rootBundle.loadString('assets/data/certprep_sample_questions.json');
  final Map<String, dynamic> json = jsonDecode(data);

  for (final exam in json['exams']) {
    // ✅ Check if this exam already exists
    final existingExams = await db.query(
      'exams',
      where: 'title = ?',
      whereArgs: [exam['title']],
    );
    if (existingExams.isNotEmpty) {
      if (kDebugMode) {
        print("🔁 Skipping existing exam: ${exam['title']}");
      }
      continue;
    }
    
    final int examId = await db.insert('exams', {'title': exam['title']});

    for (final domain in exam['domains']) {
      final int domainId = await db.insert('domains', {
        'exam_id': examId,
        'name': domain['name'],
      });

      for (final q in domain['questions']) {
        final int qId = await db.insert('questions', {
          'exam_id': examId,
          'domain_id': domainId,
          'question': q['question'],
          'explanation': q['explanation'],
        });

        for (final a in q['answers']) {
          await db.insert('answers', {
            'question_id': qId,
            'answer': a['answer'],
            'is_correct': a['is_correct'] ? 1 : 0,
          });
        }
      }
    }
  }
}
