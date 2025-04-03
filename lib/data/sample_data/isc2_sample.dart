import 'package:sqflite/sqflite.dart';

Future<void> insertSampleISC2CCData(Database db) async {
  // Check if sample data already exists
  final existing = await db.query('questions');
  if (existing.isNotEmpty) return;

  // Insert Exam
  int examId = await db.insert('exams', {'title': 'ISC2 Certified in Cybersecurity (CC)'});

  // Insert Domains
  int domain1Id = await db.insert('domains', {
    'exam_id': examId,
    'name': 'Security Principles',
  });

  int domain2Id = await db.insert('domains', {
    'exam_id': examId,
    'name': 'Access Control Concepts',
  });

  // Sample Question 1 (Domain 1)
  int q1Id = await db.insert('questions', {
    'exam_id': examId,
    'domain_id': domain1Id,
    'question': 'Which of the following best defines the principle of least privilege?',
    'explanation': 'It ensures users only have access necessary to perform their job functions.',
  });

  await db.insert('answers', {
    'question_id': q1Id,
    'answer': 'Users have unrestricted access to resources.',
    'is_correct': 0,
  });
  await db.insert('answers', {
    'question_id': q1Id,
    'answer': 'Users only get access necessary for their tasks.',
    'is_correct': 1,
  });
  await db.insert('answers', {
    'question_id': q1Id,
    'answer': 'Admins have full control over all systems.',
    'is_correct': 0,
  });
  await db.insert('answers', {
    'question_id': q1Id,
    'answer': 'Access is based on user seniority.',
    'is_correct': 0,
  });

  // Sample Question 2 (Domain 2)
  int q2Id = await db.insert('questions', {
    'exam_id': examId,
    'domain_id': domain2Id,
    'question': 'What type of access control assigns roles to users?',
    'explanation': 'Role-Based Access Control (RBAC) assigns permissions to roles rather than individuals.',
  });

  await db.insert('answers', {
    'question_id': q2Id,
    'answer': 'Mandatory Access Control',
    'is_correct': 0,
  });
  await db.insert('answers', {
    'question_id': q2Id,
    'answer': 'Discretionary Access Control',
    'is_correct': 0,
  });
  await db.insert('answers', {
    'question_id': q2Id,
    'answer': 'Role-Based Access Control',
    'is_correct': 1,
  });
  await db.insert('answers', {
    'question_id': q2Id,
    'answer': 'Rule-Based Access Control',
    'is_correct': 0,
  });

  // Add more questions here...
}
