import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("booking_progress.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE booking_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        lastName TEXT,
        wheels INTEGER,
        vehicleTypeId TEXT,
        vehicleTypeName TEXT,
        modelId TEXT,
        modelName TEXT,
        startDate TEXT,
        endDate TEXT
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
