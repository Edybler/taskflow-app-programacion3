class TreeNode {
  String value;
  List<TreeNode> children;

  TreeNode(this.value) : children = [];
}

class TaskTree {
  TreeNode root = TreeNode("Tareas");

  TreeNode pendientes = TreeNode("Pendientes");
  TreeNode completadas = TreeNode("Completadas");

  TaskTree() {
    root.children.add(pendientes);
    root.children.add(completadas);
  }

  void addTask(String taskName, bool isCompleted) {
    if (isCompleted) {
      completadas.children.add(TreeNode(taskName));
    } else {
      pendientes.children.add(TreeNode(taskName));
    }
  }

  void printTree(TreeNode node, [String indent = ""]) {
    print("$indent${node.value}");
    for (var child in node.children) {
      printTree(child, indent + "  ");
    }
  }
}class HashTable {
  Map<int, dynamic> _table = {};

  void insert(int id, dynamic task) {
    _table[id] = task;
  }

  dynamic search(int id) {
    return _table[id];
  }

  void delete(int id) {
    _table.remove(id);
  }

  void printTable() {
    _table.forEach((key, value) {
      print("ID: $key -> $value");
    });
  }
}class HashTable {
  Map<int, dynamic> _table = {};

  void insert(int id, dynamic task) {
    _table[id] = task;
  }

  dynamic search(int id) {
    return _table[id];
  }

  void delete(int id) {
    _table.remove(id);
  }

  void printTable() {
    _table.forEach((key, value) {
      print("ID: $key -> $value");
    });
  }
}class Graph {
  Map<String, List<String>> adjList = {};

  void addNode(String task) {
    adjList.putIfAbsent(task, () => []);
  }

  void addEdge(String from, String to) {
    adjList.putIfAbsent(from, () => []);
    adjList.putIfAbsent(to, () => []);
    adjList[from]!.add(to);
  }

  List<String> getConnections(String task) {
    return adjList[task] ?? [];
  }

  void printGraph() {
    adjList.forEach((key, value) {
      print("$key -> $value");
    });
  }
}