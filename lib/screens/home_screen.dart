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

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final data = await DatabaseHelper.instance.getProducts();

    setState(() {
      products = data;
    });
  }

  Future<void> openAddProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddProductScreen()),
    );

    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PriceBook'), centerTitle: true),
      body: products.isEmpty
          ? const Center(
              child: Text('No products yet', style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text(product.category),
                    trailing: Text('₦${product.price.toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}
