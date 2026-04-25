import 'package:flutter/material.dart';
import '../data_structures/hash_table.dart';
import '../data_structures/tree.dart';

class AnalysisScreen extends StatelessWidget {
  final HashTable hashTable;

  const AnalysisScreen({super.key, required this.hashTable});

  @override
  Widget build(BuildContext context) {
    final tasks = hashTable.getAll();

    int total = tasks.length;
    int completed = tasks.where((t) => t.completed).length;
    int pending = total - completed;

    Map<String, int> tasksByUser = {};

    for (var task in tasks) {
      tasksByUser[task.user] =
          (tasksByUser[task.user] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Análisis de tareas"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total de tareas: $total"),
            Text("Completadas: $completed"),
            Text("Pendientes: $pending"),
            const SizedBox(height: 20),

            const Text(
              "Tareas por usuario:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            ...tasksByUser.entries.map((entry) {
              return Text("${entry.key}: ${entry.value}");
            }),
          ],
        ),
      ),
    );
  }
}