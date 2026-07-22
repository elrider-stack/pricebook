import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/product.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  String _category = 'Food';

  Future<void> _saveProduct() async {
    if (_nameController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty) {
      return;
    }

    final product = Product(
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text),
      category: _category,
      createdAt: DateTime.now().toIso8601String(),
    );

    await DatabaseHelper.instance.insertProduct(product);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Food', child: Text('Food')),
                DropdownMenuItem(value: 'Snacks', child: Text('Snacks')),
                DropdownMenuItem(value: 'Drinks', child: Text('Drinks')),
              ],
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProduct,
                child: const Text('Save Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
