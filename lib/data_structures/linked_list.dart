import '../models/task_model.dart';

class Node {
  Task data;
  Node? next;

  Node(this.data);
}

class LinkedList {
  Node? head;

  // Insertar al final
  void insert(Task task) {
    final newNode = Node(task);

    if (head == null) {
      head = newNode;
      return;
    }

    Node current = head!;
    while (current.next != null) {
      current = current.next!;
    }

    current.next = newNode;
  }

  // Eliminar por ID
  void delete(int id) {
    if (head == null) return;

    if (head!.data.id == id) {
      head = head!.next;
      return;
    }

    Node current = head!;
    while (current.next != null) {
      if (current.next!.data.id == id) {
        current.next = current.next!.next;
        return;
      }
      current = current.next!;
    }
  }

  // Buscar por ID
  Task? search(int id) {
    Node? current = head;

    while (current != null) {
      if (current.data.id == id) {
        return current.data;
      }
      current = current.next;
    }

    return null;
  }

  // Convertir a lista normal (para mostrar en UI)
  List<Task> toList() {
    List<Task> tasks = [];
    Node? current = head;

    while (current != null) {
      tasks.add(current.data);
      current = current.next;
    }

    return tasks;
  }
}