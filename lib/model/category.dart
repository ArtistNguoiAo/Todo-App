class NoteCategory {
  int? id;
  final String name;
  final String color;
  final String createdAt;

  NoteCategory({
    this.id,
    required this.name,
    required this.color,
    required this.createdAt,
  });

  factory NoteCategory.fromMap(Map<String, dynamic> map) {
    return NoteCategory(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'created_at': createdAt,
    };
  }
}