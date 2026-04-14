import '../models/task_model.dart';

class QueueNode {
  Task data;
  QueueNode? next;

  QueueNode(this.data);
}

class TaskQueue {
  QueueNode? _front;
  QueueNode? _rear;
  int _size = 0;

  int get size => _size;
  bool get isEmpty => _front == null;

  // Encolar — agrega al final
  void enqueue(Task task) {
    final newNode = QueueNode(task);

    if (_rear == null) {
      _front = newNode;
      _rear = newNode;
    } else {
      _rear!.next = newNode;
      _rear = newNode;
    }
    _size++;
  }

  // Desencolar — elimina del frente y retorna la tarea
  Task? dequeue() {
    if (_front == null) return null;

    final task = _front!.data;
    _front = _front!.next;

    if (_front == null) _rear = null;

    _size--;
    return task;
  }

  // Ver el frente sin eliminar
  Task? peek() => _front?.data;

  // Buscar por ID
  Task? search(int id) {
    QueueNode? current = _front;
    while (current != null) {
      if (current.data.id == id) return current.data;
      current = current.next;
    }
    return null;
  }

  // Convertir a lista para mostrar en UI
  List<Task> toList() {
    List<Task> tasks = [];
    QueueNode? current = _front;
    while (current != null) {
      tasks.add(current.data);
      current = current.next;
    }
    return tasks;
  }
}