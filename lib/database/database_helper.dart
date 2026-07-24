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
    final path = join(await getDatabasesPath(), 'pricebook.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
CREATE TABLE products(
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
price REAL NOT NULL,
category TEXT NOT NULL,
imagePath TEXT NOT NULL DEFAULT '',
favorite INTEGER NOT NULL DEFAULT 0,
createdAt TEXT NOT NULL
)
''');
  }

  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute(
        "ALTER TABLE products ADD COLUMN imagePath TEXT NOT NULL DEFAULT ''",
      );

      await db.execute(
        "ALTER TABLE products ADD COLUMN favorite INTEGER NOT NULL DEFAULT 0",
      );
    }
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

  Future<int> updateProduct(Product product) async {
    final db = await database;

    return db.update(
      'products',
      product.toMap(),
      where: 'id=?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;

    return db.delete('products', where: 'id=?', whereArgs: [id]);
  }
}
