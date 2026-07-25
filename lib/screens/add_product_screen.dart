import 'dart:io';

import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/product.dart';
import '../services/image_service.dart';

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
  String _imagePath = '';

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      _name.text = widget.product!.name;
      _price.text = widget.product!.price.toString();
      _category = widget.product!.category;
      _imagePath = widget.product!.imagePath;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final path = await ImageService.pickImage();

    if (path != null) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.product != null;

    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit Product' : 'Add Product')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    backgroundImage: _imagePath.isNotEmpty
                        ? FileImage(File(_imagePath))
                        : null,
                    child: _imagePath.isEmpty
                        ? const Icon(Icons.add_a_photo_rounded, size: 36)
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Choose Image"),
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: "Product Name",
                  prefixIcon: Icon(Icons.inventory_2_rounded),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Enter product name"
                    : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _price,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Price",
                  prefixIcon: Icon(Icons.payments_rounded),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Enter price"
                    : null,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: "Category",
                  prefixIcon: Icon(Icons.category_rounded),
                ),
                items: const [
                  DropdownMenuItem(value: "Food", child: Text("Food")),
                  DropdownMenuItem(value: "Drinks", child: Text("Drinks")),
                  DropdownMenuItem(value: "Snacks", child: Text("Snacks")),
                  DropdownMenuItem(value: "Goods", child: Text("Goods")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _category = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 30),

              FilledButton.icon(
                icon: Icon(
                  editing ? Icons.save_rounded : Icons.add_circle_rounded,
                ),
                label: Text(editing ? "Save Changes" : "Add Product"),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  final product = Product(
                    id: widget.product?.id,
                    name: _name.text.trim(),
                    price: double.parse(_price.text),
                    category: _category,
                    imagePath: _imagePath,
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
