import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];

  List<Product> get products => _filteredProducts;

  Future<void> loadProducts() async {
    _products = await DatabaseHelper.instance.getProducts();
    _filteredProducts = List.from(_products);
    notifyListeners();
  }

  void search(String keyword) {
    if (keyword.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products.where((product) {
        return product.name.toLowerCase().contains(keyword.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }
}
