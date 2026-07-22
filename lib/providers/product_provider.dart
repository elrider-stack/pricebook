import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  List<Product> _products = [];
  List<Product> _allProducts = [];

  List<Product> get products => _products;

  int get totalProducts => _allProducts.length;

  Future<void> loadProducts() async {
    _allProducts = await _databaseHelper.getProducts();
    _products = List.from(_allProducts);
    notifyListeners();
  }

  void search(String keyword) {
    if (keyword.trim().isEmpty) {
      _products = List.from(_allProducts);
    } else {
      _products = _allProducts.where((product) {
        return product.name.toLowerCase().contains(keyword.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }
}
