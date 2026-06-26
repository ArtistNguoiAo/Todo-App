import 'package:todo_app/enum/note_priority_enum.dart';

class Note {
  final int id;
  final int categoryId;
  final String title;
  final String content;
  final bool isDone;
  final NotePriorityEnum priority;
  final int createdAt;

  Note({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.content,
    required this.isDone,
    required this.priority,
    required this.createdAt,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      categoryId: map['category_id'],
      title: map['title'],
      content: map['content'],
      isDone: map['is_done'] == 1,
      priority: NotePriorityEnum.values[map['priority']],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'content': content,
      'is_done': isDone ? 1 : 0,
      'priority': priority.index,
      'created_at': createdAt,
    };
  }
}