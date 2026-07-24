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
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _price = TextEditingController();

  String _category = 'Food';

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      _name.text = widget.product!.name;
      _price.text = widget.product!.price.toString();
      _category = widget.product!.category;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.product != null;

    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit Product' : 'Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  prefixIcon: Icon(Icons.inventory_2),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: _price,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 18),

              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                ),
                items: const [
                  DropdownMenuItem(value: 'Food', child: Text('Food')),
                  DropdownMenuItem(value: 'Drinks', child: Text('Drinks')),
                  DropdownMenuItem(value: 'Snacks', child: Text('Snacks')),
                  DropdownMenuItem(value: 'Goods', child: Text('Goods')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _category = value);
                  }
                },
              ),

              const SizedBox(height: 30),

              FilledButton.icon(
                icon: Icon(
                  editing ? Icons.save_rounded : Icons.add_circle_outline,
                ),
                label: Text(editing ? 'Save Changes' : 'Add Product'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  final product = Product(
                    id: widget.product?.id,
                    name: _name.text.trim(),
                    price: double.parse(_price.text),
                    category: _category,
                    imagePath: widget.product?.imagePath ?? '',
                    favorite: widget.product?.favorite ?? false,
                    createdAt:
                        widget.product?.createdAt ??
                        DateTime.now().toIso8601String(),
                  );

                  if (editing) {
                    await DatabaseHelper.instance.updateProduct(product);
                  } else {
                    await DatabaseHelper.instance.insertProduct(product);
                  }

                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
