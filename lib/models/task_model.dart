class Task {
  final int id;
  final int userId;
  final String title;
  final bool completed;
  final String? imageUrl;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
    this.imageUrl,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      completed: json['completed'],
      imageUrl: json['imageUrl'],
    );
  }
}