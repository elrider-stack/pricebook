import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/product.dart';

enum SortType { newest, oldest, name, priceLow, priceHigh }

class ProductProvider extends ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _products = [];

  SortType _sortType = SortType.newest;

  List<Product> get products => _products;

  int get totalProducts => _products.length;

  SortType get sortType => _sortType;

  Future<void> loadProducts() async {
    _allProducts = await DatabaseHelper.instance.getProducts();
    _products = List.from(_allProducts);

    sortProducts(_sortType, notify: false);

    notifyListeners();
  }

  void search(String query) {
    if (query.isEmpty) {
      _products = List.from(_allProducts);
    } else {
      _products = _allProducts.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    sortProducts(_sortType, notify: false);

    notifyListeners();
  }

  void sortProducts(SortType type, {bool notify = true}) {
    _sortType = type;

    switch (type) {
      case SortType.newest:
        _products.sort((a, b) => b.id!.compareTo(a.id!));
        break;

      case SortType.oldest:
        _products.sort((a, b) => a.id!.compareTo(b.id!));
        break;

      case SortType.name:
        _products.sort((a, b) => a.name.compareTo(b.name));
        break;

      case SortType.priceLow:
        _products.sort((a, b) => a.price.compareTo(b.price));
        break;

      case SortType.priceHigh:
        _products.sort((a, b) => b.price.compareTo(a.price));
        break;
    }

    if (notify) {
      notifyListeners();
    }
  }
}
