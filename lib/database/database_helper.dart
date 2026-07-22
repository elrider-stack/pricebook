import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('pricebook.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        category TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertProduct(Product product) async {
    final db = await instance.database;

    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;

    final result = await db.query('products', orderBy: 'name ASC');

    return result.map((e) => Product.fromMap(e)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
