// lib/data_structures/stack.dart

class ActionLog {
  final String action; // "insertar", "eliminar", "buscar"
  final dynamic value;
  final DateTime timestamp;

  ActionLog(this.action, this.value) : timestamp = DateTime.now();

  @override
  String toString() => "[${timestamp.toString().substring(11, 19)}] $action: $value";
}

class MyStack<T> {
  final List<T> _storage = [];
  final List<ActionLog> history = [];

  // 1. PUSH: Insertar elemento
  void push(T element) {
    _storage.add(element);
    history.add(ActionLog("insertar", element));
  }

  // 2. POP: Eliminar y retornar el último elemento (Tope)
  T? pop() {
    if (_storage.isEmpty) {
      history.add(ActionLog("error", "Intento de eliminar en pila vacía"));
      return null;
    }
    T lastElement = _storage.removeLast();
    history.add(ActionLog("eliminar", lastElement));
    return lastElement;
  }

  // 3. PEEK: Ver el elemento del tope sin eliminarlo
  T? peek() {
    if (_storage.isEmpty) {
      history.add(ActionLog("buscar", "Pila vacía (null)"));
      return null;
    }
    T topElement = _storage.last;
    history.add(ActionLog("buscar (peek)", topElement));
    return topElement;
  }

  // Auxiliares
  bool get isEmpty => _storage.isEmpty;
  int get length => _storage.length;

  get items => null;
  
  void printHistory() {
    print("--- Historial de la Pila ---");
    for (var log in history) {
      print(log);
    }
  }
}
