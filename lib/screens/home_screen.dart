import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/product.dart';
import 'add_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final data = await DatabaseHelper.instance.getProducts();

    setState(() {
      products = data;
      filteredProducts = data;
    });
  }

  void searchProducts(String value) {
    setState(() {
      filteredProducts = products.where((product) {
        return product.name.toLowerCase().contains(value.toLowerCase());
      }).toList();
    });
  }

  Future<void> openAddProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddProductScreen()),
    );

    loadProducts();
  }

  Future<void> deleteProduct(Product product) async {
    if (product.id == null) return;

    await DatabaseHelper.instance.deleteProduct(product.id!);

    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PriceBook'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search product...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: searchProducts,
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('No products found'))
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return Card(
                        child: ListTile(
                          title: Text(product.name),
                          subtitle: Text(product.category),
                          trailing: Text(
                            '₦${product.price.toStringAsFixed(2)}',
                          ),
                          onLongPress: () => deleteProduct(product),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}
