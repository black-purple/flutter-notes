import 'package:path/path.dart';
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
        "title" TEXT NOT NULL,
        "content" TEXT NOT NULL,
        "color" INTEGER NOT NULL
      )
      ''');
  }

  getNotes() async {
    var notesDb = await db;
    var data = notesDb!.rawQuery("SELECT * FROM notes");
    return data;
  }
  getNoteWithId(int id) async {
    var notesDb = await db;
    var data = notesDb!.rawQuery("SELECT content FROM notes WHERE id = $id");
    return data;
  }
  addNote(String noteTitle, String noteContent, int color) async {
    var notesDb = await db;
    var data = notesDb!.rawInsert("INSERT INTO 'notes' ('title', 'content', 'color') VALUES ('$noteTitle', '$noteContent', '$color')");
    return data;
  }
  updateNoteContent(String newNoteContent, int id) async {
    var notesDb = await db;
    var data = notesDb!.rawUpdate("UPDATE 'notes' SET 'content' = '$newNoteContent' WHERE id=$id");
    return data;
  }
  updateNoteTitle(int newNoteTitle, int id) async {
    var notesDb = await db;
    var data = notesDb!.rawUpdate("UPDATE 'notes' SET 'title' = '$newNoteTitle' WHERE id=$id");
    return data;
  }
  deleteNote(int id) async {
    var notesDb = await db;
    var data = notesDb!.rawDelete("DELETE FROM 'notes' WHERE id=$id");
    return data;
  }
}
