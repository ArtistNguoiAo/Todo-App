import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/model/category.dart';
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
      version: 3,
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

  }

  //Xử lý bảng Categories
  Future<int> insertCategory(Category category) async{
    final db = await instance.database;
    final map = category.toMap()..remove('id');
    return await db.insert('categories', map);
  }

  Future<List<Category>> getAllCategories() async{
    final db = await instance.database;
    final result = await db.query('categories', orderBy: 'created_at DESC');

    return result.map((map) => Category.fromMap({
      'id' : map['id'],
      'name': map['name'],
      'color': map['color'],
      'created_at': map['created_at'],
    })).toList();
  }
}