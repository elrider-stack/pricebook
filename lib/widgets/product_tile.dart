import 'dart:io';

import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/product.dart';
import '../screens/add_product_screen.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final Future<void> Function() onRefresh;

  const ProductTile({
    super.key,
    required this.product,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),

        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: product.imagePath.isNotEmpty
              ? Image.file(
                  File(product.imagePath),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.inventory_2_rounded, size: 30),
                ),
        ),

        title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(product.category),
            const SizedBox(height: 4),
            Text(
              '₦${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddProductScreen(product: product),
                  ),
                );

                await onRefresh();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_rounded, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Delete Product'),
                    content: Text('Delete "${product.name}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await DatabaseHelper.instance.deleteProduct(product.id!);

                  await onRefresh();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
