import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';
import '../models/user_model.dart';

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Task>> fetchTasks() async {
    final url = Uri.parse('$baseUrl/todos?_limit=20');

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      print('STATUS CODE: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Task.fromJson(item)).toList();
      } else {
        throw Exception(
          'Error al cargar tareas. Código: ${response.statusCode}',
        );
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
