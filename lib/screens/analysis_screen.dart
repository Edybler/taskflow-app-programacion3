import 'package:flutter/material.dart';
import 'package:taskflow_app/data_structures/hash_table.dart';
import 'package:taskflow_app/models/task_model.dart';

class AnalysisScreen extends StatelessWidget {
  final HashTable<Task> hashTable;

  const AnalysisScreen({super.key, required this.hashTable});

  @override
  Widget build(BuildContext context) {
    final tasks = hashTable.getAll();

    int total = tasks.length;
    int completed = tasks.where((t) => t.completed).length;
    int pending = total - completed;

    // 🔹 Ahora usamos userId (int)
    Map<int, int> tasksByUser = {};

    for (var task in tasks) {
      tasksByUser[task.userId] =
          (tasksByUser[task.userId] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Análisis de tareas"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: total == 0
            ? const Center(child: Text("No hay tareas registradas"))
            : Column(
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

                  const SizedBox(height: 10),

                  ...tasksByUser.entries.map((entry) {
                    return Text(
                      "Usuario ${entry.key}: ${entry.value} tareas",
                    );
                  }).toList(),
                ],
              ),
      ),
    );
  }
}