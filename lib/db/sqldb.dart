import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDB();
      return _db;
    } else {
      return _db;
    }
  }

  intialDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'yahya.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 7, onUpgrade: _onUpgrade);
    return mydb;
  }

  myDeleteDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'yahya.db');
    await deleteDatabase(path);
    print('Database Deleted');
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('On Upgrade Database');
    // await db.execute('ALTER TABLE Notes ADD COLUMN Color TEXT');
  }

  _onCreate(Database db, int version) async {
    Batch batch = db.batch();

    batch.execute('''CREATE TABLE Notes 
        (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        Title TEXT NOT NULL,
        Note TEXT NOT NULL,
        Color TEXT
        )''');
    await batch.commit();

    print('On Creete Database');
  }

  //First way
  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  //second way
  read(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insert(String table, Map<String, Object?> values) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, values);
    return response;
  }

  update(String table, Map<String, Object?> values, String mywhere) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, values, where: mywhere);
    return response;
  }

  delete(String table, String? mywhere) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: mywhere);
    return response;
  }
}
