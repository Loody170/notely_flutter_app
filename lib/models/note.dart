class Note {
  final String id;
  final String title;
  final String content;
  final String color;
  final String userId;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.userId,
    required this.createdAt,
  });

  static Map<String, dynamic> toJSON (Note note, String uid) {
    return {
      'id': note.id,
      'title': note.title,
      'content': note.content,
      'color': note.color,
      'created_at': note.createdAt.toIso8601String(),
      'user_id': uid,
    };
  }

  static Note fromJSON(Map<String, dynamic> json) {
  return Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    userId: json['user_id'],
    color: json['color'],
    createdAt: DateTime.parse(json['created_at']),
  );
}
}