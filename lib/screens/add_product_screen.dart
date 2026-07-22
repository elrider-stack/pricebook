import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/product.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;

  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  String _category = 'Food';

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _category = widget.product!.category;
    }
  }

  Future<void> saveProduct() async {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text);

    if (name.isEmpty || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid product details')),
      );
      return;
    }

    final product = Product(
      id: widget.product?.id,
      name: name,
      price: price,
      category: _category,
      createdAt: widget.product?.createdAt ?? DateTime.now().toIso8601String(),
    );

    if (widget.product == null) {
      await DatabaseHelper.instance.insertProduct(product);
    } else {
      await DatabaseHelper.instance.updateProduct(product);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.product != null;

    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit Product' : 'Add Product')),
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
                if (value == null) return;

                setState(() {
                  _category = value;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveProduct,
                child: Text(editing ? 'Update Product' : 'Save Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
