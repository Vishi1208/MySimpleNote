class Note {
  final int? id;
  final String title;
  final String content;
  final bool isArchived;
  final int color;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.isArchived,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isArchived': isArchived ? 1 : 0,
      'color': color,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      isArchived: map['isArchived'] == 1,
      color: map['color'],
    );
  }
}
