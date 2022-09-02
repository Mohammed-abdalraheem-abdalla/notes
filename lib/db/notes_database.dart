import 'package:noteyyy/model/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;
  NotesDatabase._init();

  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,filePath);
    return await openDatabase(path,version: 1,onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
  await db.execute(''' 
  CREATE TABLE $tableNotes (
  ${NoteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${NoteFields.isImportant} BOOLEAN NOT NULL,
  ${NoteFields.number} INTEGER NOT NULL,
  ${NoteFields.title} TEXT NOT NULL,
  ${NoteFields.description} TEXT NOT NULL,
  ${NoteFields.time} TEXT NOT NULL 
  )
  ''');
  }

  // create note
  Future<Note> create(Note note) async{
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  // read note
  Future<Note?> readNote(int id) async{
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
    if(maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      return null;
    }
  }

  // read multiple notes
  Future<List<Note>> raedAllNotes() async{
    final db = await instance.database;
    const order = '${NoteFields.time} ASC';
    final result = await db.query(tableNotes, orderBy: order);
    return result.map((json) =>
        Note.fromJson(json)).toList();
  }
  //update or edit note
  Future<int> update(Note note) async{
    final db = await instance.database;

    return db.update(tableNotes, note.toJson(),
      where: '${NoteFields.id} = ?',
        whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async{
    final db = await instance.database;
    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

  }

  Future close() async{
    final db = await instance.database;

    db.close();
  }
}