import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../sample_data/insert_questions_from_json.dart'; // JSON-based data insertion

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'certprep.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 🧱 Create all tables
    await db.execute('''
      CREATE TABLE exams (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE domains (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exam_id INTEGER,
        name TEXT NOT NULL,
        FOREIGN KEY (exam_id) REFERENCES exams(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        domain_id INTEGER,
        exam_id INTEGER,
        question TEXT NOT NULL,
        explanation TEXT,
        FOREIGN KEY (domain_id) REFERENCES domains(id),
        FOREIGN KEY (exam_id) REFERENCES exams(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER,
        answer TEXT NOT NULL,
        is_correct INTEGER NOT NULL,
        FOREIGN KEY (question_id) REFERENCES questions(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (question_id) REFERENCES questions(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE attempts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exam_id INTEGER,
        score INTEGER,
        total_questions INTEGER,
        duration_seconds INTEGER,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (exam_id) REFERENCES exams(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE user_stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exam_id INTEGER,
        domain_id INTEGER,
        total_answered INTEGER DEFAULT 0,
        correct_answered INTEGER DEFAULT 0,
        total_time_seconds INTEGER DEFAULT 0,
        FOREIGN KEY (exam_id) REFERENCES exams(id),
        FOREIGN KEY (domain_id) REFERENCES domains(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE meta (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    // Initial metadata version
    await db.insert('meta', {'key': 'data_version', 'value': '1'});

    // Insert default question set
    await insertQuestionsFromJson(db);
  }

  /// 🔁 Syncs the question bank if JSON data version changed
  Future<void> syncQuestionBankIfNeeded() async {
    final db = await database;
    const latestVersion = '2'; // Change this when JSON changes

    // Make sure meta table exists
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meta (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    final result = await db.query(
      'meta',
      where: 'key = ?',
      whereArgs: ['data_version'],
    );

    final currentVersion =
        result.isNotEmpty ? result.first['value'] as String : null;

    if (currentVersion != latestVersion) {
      // 🔄 Clear old data
      await db.delete('answers');
      await db.delete('questions');
      await db.delete('domains');
      await db.delete('exams');

      // ✅ Reinsert fresh data
      await insertQuestionsFromJson(db);

      // Update version
      await db.insert(
        'meta',
        {'key': 'data_version', 'value': latestVersion},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print("✅ Question bank updated to version $latestVersion");
    } else {
      print("✔️ Question bank already up-to-date");
    }
  }
}
