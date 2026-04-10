import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'erp_hmpa.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE purchases (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            reference TEXT NOT NULL,
            date TEXT NOT NULL,
            supplier TEXT NOT NULL,
            description TEXT NOT NULL,
            category TEXT NOT NULL,
            amount REAL NOT NULL,
            paymentMethod TEXT NOT NULL,
            status TEXT NOT NULL,
            createdBy TEXT NOT NULL,
            validatedBy TEXT,
            validationComment TEXT,
            validationDate TEXT,
            dateCreation TEXT NOT NULL,
            dateModification TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE sales (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            reference TEXT NOT NULL,
            date TEXT NOT NULL,
            client TEXT NOT NULL,
            description TEXT NOT NULL,
            category TEXT NOT NULL,
            amount REAL NOT NULL,
            paymentMethod TEXT NOT NULL,
            status TEXT NOT NULL,
            createdBy TEXT NOT NULL,
            validatedBy TEXT,
            validationComment TEXT,
            validationDate TEXT,
            dateCreation TEXT NOT NULL,
            dateModification TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            operationType TEXT NOT NULL,
            operationId INTEGER NOT NULL,
            action TEXT NOT NULL,
            actor TEXT NOT NULL,
            comment TEXT,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }
}
