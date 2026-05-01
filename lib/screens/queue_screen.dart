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
    loadPendingTasks(); // Carga datos al iniciar la pantalla
  }

  // ── Carga tareas de la API y encola solo las pendientes ──
  Future<void> loadPendingTasks() async {
    try {
      final tasks = await apiService.fetchTasks();
      for (final task in tasks) {
        if (!task.completed) taskQueue.enqueue(task);
      }
      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // ── Elimina y muestra la primera tarea de la cola ──
  void dequeue() {
    final task = taskQueue.dequeue();
    if (task != null) {
      setState(() => lastDequeued = task);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Procesada: "${task.title}"')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La cola está vacía')),
      );
    }
    setState(() {});
  }

  // ── Crea una tarea de prueba y la agrega al final ──
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
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Cola — Tareas Pendientes'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: enqueueManual,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : Column(
                    children: [

                      // Info de la cola
                      Text('Tareas en cola: ${taskQueue.size}'),
                      const SizedBox(height: 8),
                      Text('Siguiente: ${frontTask != null ? "#${frontTask.id}" : "—"}'),
                      const SizedBox(height: 8),

                      // Última tarea procesada (solo si existe)
                      if (lastDequeued != null)
                        Text('Última procesada: ${lastDequeued!.title}'),

                      const SizedBox(height: 16),

                      // Botón deshabilitado si la cola está vacía
                      ElevatedButton(
                        onPressed: taskQueue.isEmpty ? null : dequeue,
                        child: const Text('Procesar siguiente'),
                      ),

                      const SizedBox(height: 16),

                      // Lista de tareas en cola
                      Expanded(
                        child: tasks.isEmpty
                            ? const Center(child: Text('Cola vacía'))
                            : ListView.builder(
                                itemCount: tasks.length,
                                itemBuilder: (context, index) {
                                  final task = tasks[index];
                                  return ListTile(
                                    leading: Text('${index + 1}'),
                                    title: Text(task.title),
                                    subtitle: Text('ID: ${task.id}'),
                                    trailing: index == 0
                                        ? const Text('[FRENTE]')
                                        : null,
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