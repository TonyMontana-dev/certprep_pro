import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fl_chart/fl_chart.dart';
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
    ''');

    setState(() {
      _stats = result;
    });
  }

  int get totalQuestions => _stats.fold(0, (sum, s) => sum + (s['total_answered'] as int));
  int get correctQuestions => _stats.fold(0, (sum, s) => sum + (s['correct_answered'] as int));
  int get totalSeconds => _stats.fold(0, (sum, s) => sum + (s['total_time_seconds'] as int));

  @override
  Widget build(BuildContext context) {
    double accuracy = totalQuestions == 0 ? 0 : (correctQuestions / totalQuestions * 100);

    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _stats.isEmpty
            ? const Center(child: Text("No data yet. Take a quiz to see stats."))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Progress", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _buildStatTile("Total Questions Answered", totalQuestions.toString()),
                  _buildStatTile("Correct Answers", correctQuestions.toString()),
                  _buildStatTile("Accuracy", "${accuracy.toStringAsFixed(1)}%"),
                  _buildStatTile("Total Time Spent", _formatDuration(totalSeconds)),
                  const SizedBox(height: 24),
                  Text("Accuracy by Domain", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: false),
                        barGroups: _stats.asMap().entries.map((entry) {
                          final index = entry.key;
                          final stat = entry.value;
                          final total = stat['total_answered'] as int;
                          final correct = stat['correct_answered'] as int;
                          final acc = total == 0 ? 0 : (correct / total * 100);
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: acc.toDouble(),
                                width: 16,
                                color: Colors.tealAccent,
                              ),
                            ],
                          );
                        }).toList(),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 25,
                              getTitlesWidget: (value, meta) {
                                if (value % 25 == 0) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(fontSize: 10, color: Colors.white54),
                                  );  
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                final index = value.toInt();
                                if (index >= 0 && index < _stats.length) {
                                  final name = _stats[index]['domain_name'];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      name.toString().split(' ').first,
                                      style: const TextStyle(fontSize: 10, color: Colors.white70),
                                    ),
                                  );
                                } else {
                                  return const Text("");
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
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
// This code is a Flutter widget that displays user analytics for a quiz application. It retrieves data from a SQLite database, calculates statistics like total questions answered, correct answers, accuracy, and time spent, and visualizes the accuracy by domain using a bar chart. The UI is built using Flutter's Material Design components.
// The widget is stateful, meaning it can update its UI based on changes in the underlying data. It uses the fl_chart package for rendering the bar chart. The analytics screen is designed to provide users with insights into their quiz performance, helping them identify areas for improvement.