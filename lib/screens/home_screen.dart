import 'package:flutter/material.dart';
import 'package:taskflow_app/screens/users_screen.dart';
import '../data_structures/hash_table.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';
import '../data_structures/linked_list.dart';
import 'analysis_screen.dart';
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

  /// 🔥 CARGAR DATOS
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

  /// 🔍 BUSCAR
  void searchTask() {
    final id = int.tryParse(searchController.text);

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un ID válido')),
      );
      return;
    }

    final task = linkedList.search(id);

    setState(() {
      displayedTasks = task != null ? [task] : [];
    });
  }

  /// 📋 MOSTRAR TODAS
  void showAllTasks() {
    setState(() {
      displayedTasks = linkedList.toList();
    });
  }

  /// 🗑 ELIMINAR
  void deleteTask(int id) {
    linkedList.delete(id);

    setState(() {
      displayedTasks = linkedList.toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tarea $id eliminada')),
    );
  }

  /// ⚠ CONFIRMAR ELIMINACIÓN
  void confirmDelete(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Eliminar "${task.title}"?'),
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
  }

  /// ➕ AGREGAR TAREA
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
            tooltip: 'Usuarios',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.queue),
            tooltip: 'Cola',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QueueScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.layers),
            tooltip: 'Pila',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StackScreen()),
              );
            },
          ),
        ],
      ),

      /// 🔥 BOTONES NUEVOS (ÁRBOL / HASH / GRAFO / ANÁLISIS)
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// 🔘 BOTONES DE ESTRUCTURAS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.account_tree),
                    label: const Text("Árbol"),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Pantalla de Árbol pendiente")),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.grid_on),
                    label: const Text("Hash"),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("HashTable en uso interno")),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text("Grafo"),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Pantalla de Grafo pendiente")),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.analytics),
                    label: const Text("Análisis"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
  final hashTable = HashTable<Task>();

  for (var task in displayedTasks) {
    hashTable.insert(task.id.toString(), task);
  }

  return AnalysisScreen(hashTable: hashTable);
},
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔍 BUSCADOR
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

            const SizedBox(height: 10),

            /// 📋 LISTA
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? Center(child: Text(errorMessage!))
                      : ListView.builder(
                          itemCount: displayedTasks.length,
                          itemBuilder: (context, index) {
                            final task = displayedTasks[index];

                            return Card(
                              child: ListTile(
                                leading: task.imageUrl != null
                                    ? CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(task.imageUrl!),
                                      )
                                    : CircleAvatar(
                                        child: Text(task.id.toString()),
                                      ),
                                title: Text(task.title.toUpperCase()),
                                subtitle: Text('Pokémon ID: ${task.id}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      task.completed
                                          ? Icons.check_circle
                                          : Icons.pending,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => confirmDelete(task),
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

      floatingActionButton: FloatingActionButton.extended(
        onPressed: insertNewTask,
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
    );
  }
}