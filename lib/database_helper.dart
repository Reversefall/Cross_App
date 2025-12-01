import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/hike.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('hikeDemo.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final pathDb = join(dbPath, path);
    return await openDatabase(
      pathDb,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE hikes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      location TEXT NOT NULL,
      date TEXT NOT NULL,
      parkingAvailable TEXT NOT NULL,
      length REAL NOT NULL,
      difficulty TEXT NOT NULL,
      description TEXT,
      weatherConditions TEXT,
      safetyTips TEXT
    );
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      ALTER TABLE hikes ADD COLUMN weatherConditions TEXT;
      ALTER TABLE hikes ADD COLUMN safetyTips TEXT;
    ''');
    }
  }

  Future<int> addHike(Hike hike) async {
    final db = await instance.database;
    return await db.insert('hikes', hike.toMap());
  }

  Future<List<Hike>> getAllHikes() async {
    final db = await instance.database;
    final result = await db.query('hikes');
    return result.map((e) => Hike.fromMap(e)).toList();
  }

  Future<int> updateHike(Hike hike) async {
    final db = await instance.database;
    return await db.update(
      'hikes',
      hike.toMap(),
      where: 'id = ?',
      whereArgs: [hike.id],
    );
  }

  Future<int> deleteHike(int id) async {
    final db = await instance.database;
    return await db.delete('hikes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Hike>> searchHikes(String name) async {
    final db = await instance.database;
    final result = await db.query(
      'hikes',
      where: 'name LIKE ?',
      whereArgs: ['%$name%'],
    );
    return result.map((e) => Hike.fromMap(e)).toList();
  }
}
