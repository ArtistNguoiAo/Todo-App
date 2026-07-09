
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/note.dart';
import 'package:todo_app/utils/string_utils.dart';

class AppDatabase{
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDB(StringUtils.appDB);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 7,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      category_id INTEGER,
      title TEXT NOT NULL,
      content TEXT,
      is_done INTEGER NOT NULL DEFAULT 0,
      priority INTEGER NOT NULL,
      scheduled_at INTEGER NOT NULL,
      FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE CASCADE
      )
    ''');
  }

  //Xử lý bảng Categories
  Future<int> insertCategory(NoteCategory category) async{
    final db = await instance.database;
    final map = category.toMap()..remove('id');
    return await db.insert('categories', map);
  }

  Future<List<NoteCategory>> getAllCategories() async{
    final db = await instance.database;
    final result = await db.query('categories', orderBy: 'id ASC');

    return result.map((map) => NoteCategory.fromMap(map)).toList();
  }

  Future<int> updateCategory(NoteCategory category) async {
    final db = await instance.database;
    final map = category.toMap()..remove('id');
    return db.update(
      'categories',
      map,
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await instance.database;

    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Xử lý bảng Notes
  Future<int> insertNote(Note note) async{
    final db = await instance.database;
    final map = note.toMap()..remove('id');
    return await db.insert('notes', map);
  }

  Future<List<Note>> getAllNotes() async{
    final db = await instance.database;
    final result = await db.query('notes', orderBy: 'scheduled_at DESC');

    return result.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;

    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateNoteDone(int id, bool isDone) async {
    final db = await instance.database;

    return await db.update(
      'notes',
      {'is_done': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    final map = note.toMap()..remove('id');
    return db.update(
      'notes',
      map,
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}
