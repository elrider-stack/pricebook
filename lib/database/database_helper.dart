import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  static Database? _database;

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

  Future<List<Product>> getProducts() async {
    final db = await instance.database;

    final result = await db.query('products', orderBy: 'id DESC');

    return result.map((e) => Product.fromMap(e)).toList();
  }

  Future<int> updateProduct(Product product) async {
    final db = await instance.database;

    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await instance.database;

    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
