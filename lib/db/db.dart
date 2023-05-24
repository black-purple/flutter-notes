import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await init();
      return _db;
    }
    return _db;
  }

  init() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "Notes.db");
    Database db = await openDatabase(path, onCreate: _onCreate, version: 1);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "notes" (
        "id" INTEGER NOT NULL PRIMARY KEY,
        "content" TEXT NOT NULL
      )
      ''');
  }

  getNotes() async {
    var notesDb = await db;
    var data = notesDb!.rawQuery("SELECT * FROM notes");
    return data;
  }
  addNote(String note) async {
    var notesDb = await db;
    var data = notesDb!.rawInsert("INSERT INTO 'notes' ('content') VALUES ('$note')");
    return data;
  }
  updateNote(String newNote, int id) async {
    var notesDb = await db;
    var data = notesDb!.rawUpdate("UPDATE 'notes' SET 'content' WHERE id=$id");
    return data;
  }
  deleteNote(int id) async {
    var notesDb = await db;
    var data = notesDb!.rawDelete("DELETE FROM 'notes' WHERE id=$id");
    return data;
  }
}
