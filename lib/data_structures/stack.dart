class StackLog<T> {
  final String action;
  final T value;
  final DateTime timestamp;

  StackLog(this.action, this.value) : timestamp = DateTime.now();
}

class MyStack<T> {
  // 🔥 NUNCA debe ser null
  final List<T> items = [];

  // Historial de acciones
  final List<StackLog<T>> history = [];

  void push(T value) {
    items.add(value);
    history.add(StackLog("Push", value));
  }

  T? pop() {
    if (items.isEmpty) return null;

    final value = items.removeLast();
    history.add(StackLog("Pop", value));
    return value;
  }

  T? peek() {
    if (items.isEmpty) return null;
    return items.last;
  }

  bool get isEmpty => items.isEmpty;

  int get length => items.length;
}