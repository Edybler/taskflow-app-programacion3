import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';
import '../models/user_model.dart';

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

 Future<List<Task>> fetchTasks() async {
  final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20');

  try {
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      List<Task> tasks = [];

      for (int i = 0; i < results.length; i++) {
        final pokemon = results[i];

        final int pokemonId = i + 1;
        final String imageUrl =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png';

        tasks.add(
          Task(
            id: pokemonId,
            userId: 1,
            title: pokemon['name'],
            completed: false,
            imageUrl: imageUrl,
          ),
        );
      }

      return tasks;
    } else {
      throw Exception('Error al cargar tareas. Código: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Fallo de conexión o lectura: $e');
  }
}
  Future<List<UserModel>> fetchUsers() async {
    final url = Uri.parse('$baseUrl/users');

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => UserModel.fromJson(item)).toList();
      } else {
        throw Exception('Error al cargar usuarios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
