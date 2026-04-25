class HashTable<T> {
  final Map<String, T> _table = {};

  void insert(String key, T value) {
    _table[key] = value;
  }

  T? search(String key) {
    return _table[key];
  }

  void delete(String key) {
    _table.remove(key);
  }

  List<T> getAll() {
    return _table.values.toList();
  }
}