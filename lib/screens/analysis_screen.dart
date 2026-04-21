import 'package:flutter/material.dart';

class AnalysisScreen extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;

  AnalysisScreen({required this.tasks});

  int get total => tasks.length;

  int get completed =>
      tasks.where((task) => task['completed'] == true).length;

  int get pending =>
      tasks.where((task) => task['completed'] == false).length;

  Map<String, int> get tasksByUser {
    Map<String, int> result = {};
    for (var task in tasks) {
      String user = task['user'];
      result[user] = (result[user] ?? 0) + 1;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Análisis de Tareas"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total de tareas: $total"),
            Text("Completadas: $completed"),
            Text("Pendientes: $pending"),
            SizedBox(height: 20),

            Text("Tareas por usuario:",
                style: TextStyle(fontWeight: FontWeight.bold)),

            ...tasksByUser.entries.map((entry) {
              return Text("${entry.key}: ${entry.value}");
            }).toList(),
          ],
        ),
      ),
    );
  }
}