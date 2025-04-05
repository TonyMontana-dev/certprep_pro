import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/db/database_helper.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _stats = [];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('''
      SELECT d.name as domain_name,
             us.total_answered,
             us.correct_answered,
             us.total_time_seconds
      FROM user_stats us
      JOIN domains d ON d.id = us.domain_id
      ORDER BY d.name ASC
    ''');

    setState(() {
      _stats = result;
    });
  }

  int get totalQuestions =>
      _stats.fold(0, (sum, s) => sum + (s['total_answered'] as int));
  int get correctQuestions =>
      _stats.fold(0, (sum, s) => sum + (s['correct_answered'] as int));
  int get totalSeconds =>
      _stats.fold(0, (sum, s) => sum + (s['total_time_seconds'] as int));

  @override
  Widget build(BuildContext context) {
    final accuracy =
        totalQuestions == 0 ? 0 : (correctQuestions / totalQuestions * 100);

    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _stats.isEmpty
            ? const Center(
                child: Text("No data yet. Take a quiz to see stats."))
            : ListView(
                children: [
                  Text("Your Progress",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _buildStatTile("Total Questions Answered", "$totalQuestions"),
                  _buildStatTile("Correct Answers", "$correctQuestions"),
                  _buildStatTile("Accuracy", "${accuracy.toStringAsFixed(1)}%"),
                  _buildStatTile(
                      "Total Time Spent", _formatDuration(totalSeconds)),
                  const SizedBox(height: 30),
                  Text("Domain Breakdown",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  ..._stats.map(_buildDomainStatTile),
                ],
              ),
      ),
    );
  }

  Widget _buildStatTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.tealAccent)),
        ],
      ),
    );
  }

  Widget _buildDomainStatTile(Map<String, dynamic> stat) {
    final name = stat['domain_name'];
    final total = stat['total_answered'] as int;
    final correct = stat['correct_answered'] as int;
    final seconds = stat['total_time_seconds'] as int;
    final accuracy = total == 0 ? 0 : (correct / total * 100);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          Text("Answered: $total",
              style: const TextStyle(color: Colors.white70)),
          Text("Correct: $correct",
              style: const TextStyle(color: Colors.white70)),
          Text("Accuracy: ${accuracy.toStringAsFixed(1)}%",
              style: const TextStyle(color: Colors.tealAccent)),
          Text("Time Spent: ${_formatDuration(seconds)}",
              style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return "${hours}h ${minutes}m ${seconds}s";
  }
}
