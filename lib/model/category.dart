class Category {
  final int id;
  final String name;
  final String color;
  final String createdAt;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      createdAt: map['createdAt'],
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