import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<List<UserModel>> users;

  @override
  void initState() {
    super.initState();
    users = ApiService().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: FutureBuilder<List<UserModel>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final usersList = snapshot.data!;

          return ListView.builder(
            itemCount: usersList.length,
            itemBuilder: (context, index) {
              final user = usersList[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(user.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${user.id}'),
                      Text('Username: ${user.username}'),
                      Text('Email: ${user.email}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
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
