import 'tree.dart';

class HashTable {
  final Map<String, Task> _table = {};

  void insert(Task task) {
    _table[task.id] = task;
  }

  Task? search(String id) {
    return _table[id];
  }

  void delete(String id) {
    _table.remove(id);
  }

  List<Task> getAll() {
    return _table.values.toList();
  }
}