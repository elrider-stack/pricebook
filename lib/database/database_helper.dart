import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/product.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();

    return openDatabase(
      join(dbPath, 'pricebook.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            price REAL,
            category TEXT,
            createdAt TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertProduct(Product product) async {
    final db = await database;
    return db.insert('products', product.toMap());
  }

  Future<List<Product>> getProducts() async {
    final db = await database;

    final maps = await db.query('products', orderBy: 'id DESC');

    return maps.map(Product.fromMap).toList();
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;

    return db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
