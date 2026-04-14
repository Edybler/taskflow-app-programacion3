import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';
import '../data_structures/queue.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  final ApiService apiService = ApiService();
  final TaskQueue taskQueue = TaskQueue();

  bool isLoading = true;
  String? errorMessage;
  Task? lastDequeued;

  @override
  void initState() {
    super.initState();
    loadPendingTasks();
  }

  Future<void> loadPendingTasks() async {
    try {
      final tasks = await apiService.fetchTasks();
      // Solo encolar tareas pendientes (completed == false)
      for (final task in tasks) {
        if (!task.completed) {
          taskQueue.enqueue(task);
        }
      }
      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void dequeue() {
    final task = taskQueue.dequeue();
    if (task != null) {
      setState(() => lastDequeued = task);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Procesada: "${task.title}"'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La cola está vacía'),
          backgroundColor: Colors.orange,
        ),
      );
    }
    setState(() {});
  }

  void enqueueManual() {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      userId: 99,
      title: 'Tarea manual #${taskQueue.size + 1}',
      completed: false,
    );
    taskQueue.enqueue(newTask);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Encolada: "${newTask.title}"')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = taskQueue.toList();
    final frontTask = taskQueue.peek();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cola (Queue) — Tareas Pendientes'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: enqueueManual,
        tooltip: 'Encolar tarea',
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : Column(
                    children: [
                      // Panel de info
                      Card(
                        color: Colors.blue.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text('${taskQueue.size}',
                                      style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold)),
                                  const Text('En cola'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    frontTask != null
                                        ? '#${frontTask.id}'
                                        : '—',
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text('Siguiente'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Última tarea procesada
                      if (lastDequeued != null)
                        Card(
                          color: Colors.green.shade50,
                          child: ListTile(
                            leading: const Icon(Icons.check_circle,
                                color: Colors.green),
                            title: Text(lastDequeued!.title),
                            subtitle: const Text('Última procesada (dequeue)'),
                          ),
                        ),

                      const SizedBox(height: 8),

                      // Botón dequeue
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: taskQueue.isEmpty ? null : dequeue,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Procesar siguiente (Dequeue)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Lista de la cola
                      Expanded(
                        child: tasks.isEmpty
                            ? const Center(child: Text('Cola vacía'))
                            : ListView.builder(
                                itemCount: tasks.length,
                                itemBuilder: (context, index) {
                                  final task = tasks[index];
                                  return Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: index == 0
                                            ? Colors.deepPurple
                                            : Colors.grey.shade300,
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            color: index == 0
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      title: Text(task.title),
                                      subtitle: Text('ID: ${task.id}'),
                                      trailing: index == 0
                                          ? const Chip(
                                              label: Text('FRENTE'),
                                              backgroundColor:
                                                  Colors.deepPurple,
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
      ),
    );
  }
}