import 'package:flutter/material.dart';
import 'package:taskflow_app/screens/users_screen.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';
import '../data_structures/linked_list.dart';
import 'queue_screen.dart';
import 'stack_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  final LinkedList linkedList = LinkedList();

  List<Task> displayedTasks = [];
  bool isLoading = true;
  String? errorMessage;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      final tasks = await apiService.fetchTasks();

      for (final task in tasks) {
        linkedList.insert(task);
      }

      setState(() {
        displayedTasks = linkedList.toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void searchTask() {
    final id = int.tryParse(searchController.text);

    if (id == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ingresa un ID válido')));
      return;
    }

    final task = linkedList.search(id);

    setState(() {
      displayedTasks = task != null ? [task] : [];
    });
  }

  void showAllTasks() {
    setState(() {
      displayedTasks = linkedList.toList();
    });
  }

  void deleteTask(int id) {
    linkedList.delete(id);

    setState(() {
      displayedTasks = linkedList.toList();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Tarea $id eliminada')));
  }
Future<void> insertNewTask() async {
  final titleController = TextEditingController();
  final userController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Agregar nueva tarea'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la tarea',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: userController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID del usuario',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final userId = int.tryParse(userController.text.trim());

              if (title.isEmpty || userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Completa bien los campos'),
                  ),
                );
                return;
              }

              final currentTasks = linkedList.toList();
              final newId = currentTasks.isNotEmpty
                  ? currentTasks
                          .map((t) => t.id)
                          .reduce((a, b) => a > b ? a : b) +
                      1
                  : 1;

              final newTask = Task(
                id: newId,
                userId: userId,
                title: title,
                completed: false,
              );

              linkedList.insert(newTask);

              setState(() {
                displayedTasks = linkedList.toList();
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tarea agregada correctamente'),
                ),
              );
            },
            child: const Text('Agregar'),
          ),
        ],
      );
    },
  );
}

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow App - Lista Enlazada'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Ver Usuarios',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.queue),
            tooltip: 'Ver Cola',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QueueScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.layers),
            tooltip: 'Ver Pila',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StackScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: insertNewTask,
          icon: const Icon(Icons.add),
          label: const Text('Agregar'),
      ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Buscar tarea por ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  onPressed: searchTask,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: searchTask,
                    child: const Text('Buscar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: showAllTasks,
                    child: const Text('Mostrar todas'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                  ? Center(child: Text(errorMessage!))
                  : displayedTasks.isEmpty
                  ? const Center(child: Text('No hay tareas para mostrar'))
                  : ListView.builder(
                      itemCount: displayedTasks.length,
                      itemBuilder: (context, index) {
                        final task = displayedTasks[index];

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(task.id.toString()),
                            ),
                            title: Text(task.title),
                            subtitle: Text('Usuario: ${task.userId}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  task.completed
                                      ? Icons.check_circle
                                      : Icons.pending_actions,
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                        builder: (context) {
                                return AlertDialog(
                                title: const Text('Confirmar eliminación'),
                                content: const Text('¿Seguro que deseas eliminar esta tarea?'),
                              actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                        onPressed: () {
                      deleteTask(task.id);
                      Navigator.pop(context);
                        },
                        child: const Text('Eliminar'),
                      ),
                    ],
                  );
                },
              );
            },
                      icon: const Icon(Icons.delete),
                        ),
                              ],
                            ),
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
