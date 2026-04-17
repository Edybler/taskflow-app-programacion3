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
