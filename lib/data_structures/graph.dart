class Graph {
  final Map<String, List<String>> _adjacencyList = {};

  void addNode(String taskId) {
    _adjacencyList.putIfAbsent(taskId, () => []);
  }

  void addEdge(String from, String to) {
    _adjacencyList.putIfAbsent(from, () => []);
    _adjacencyList[from]!.add(to);
  }

  List<String> getConnections(String taskId) {
    return _adjacencyList[taskId] ?? [];
  }

  Map<String, List<String>> getAll() {
    return _adjacencyList;
  }
}