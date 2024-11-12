import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      isArchived INTEGER NOT NULL DEFAULT 0,
      color INTEGER NOT NULL DEFAULT 4294967295
    )
    ''');

    // Insert dummy data
    await db.insert('notes', {
      'title': 'Sample Note 1',
      'content': 'This is a sample note to showcase the features.',
      'isArchived': 0,
      'color': 4294967295, // Default color (white)
    });

    await db.insert('notes', {
      'title': 'Work Reminder',
      'content': 'Complete the pending report by tomorrow.',
      'isArchived': 0,
      'color': 4294901760, // Red color for urgency
    });

    await db.insert('notes', {
      'title': 'Personal Task',
      'content': 'Buy groceries: milk, bread, and eggs.',
      'isArchived': 0,
      'color': 4278255360, // Green color
    });
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE notes ADD COLUMN isArchived INTEGER NOT NULL DEFAULT 0
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        ALTER TABLE notes ADD COLUMN color INTEGER NOT NULL DEFAULT 4294967295
      ''');
    }
  }

  Future<int> create(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> readAllNotes() async {
    final db = await database;
    final result = await db.query('notes', where: 'isArchived = 0', orderBy: 'id DESC');
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<List<Note>> readArchivedNotes() async {
    final db = await database;
    final result = await db.query('notes', where: 'isArchived = 1', orderBy: 'id DESC');
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await database;
    return await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> archive(Note note, bool isArchived) async {
    final db = await database;
    return await db.update(
      'notes',
      {'isArchived': isArchived ? 1 : 0},
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
