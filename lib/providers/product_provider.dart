import 'package:flutter/material.dart';

import '../constants/categories.dart';
import '../database/database_helper.dart';
import '../models/product.dart';

enum SortType { newest, oldest, name, priceLow, priceHigh }

class ProductProvider extends ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _products = [];

  String _searchQuery = '';
  String _selectedCategory = 'All';

  SortType _sortType = SortType.newest;

  List<Product> get products => _products;

  int get totalProducts => _allProducts.length;

  int get favoriteCount => _allProducts.where((e) => e.favorite).length;

  SortType get sortType => _sortType;

  String get selectedCategory => _selectedCategory;

  List<String> get categories => Categories.defaultCategories;

  Future<void> loadProducts() async {
    _allProducts = await DatabaseHelper.instance.getProducts();
    _applyFilters();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
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

  void _applyFilters() {
    _products = _allProducts.where((product) {
      final search = product.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      final category = _selectedCategory == 'All'
          ? true
          : product.category == _selectedCategory;

      return search && category;
    }).toList();

    sortProducts(_sortType, notify: false);

    notifyListeners();
  }
}
