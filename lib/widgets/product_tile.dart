import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/product.dart';
import '../screens/add_product_screen.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onRefresh;

  const ProductTile({
    super.key,
    required this.product,
    required this.onRefresh,
  });

  Future<void> deleteProduct(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteProduct(product.id!);
      onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(
          '${product.category} • ₦${product.price.toStringAsFixed(2)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddProductScreen(product: product),
                  ),
                );
                onRefresh();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deleteProduct(context),
            ),
          ],
        ),
      ),
    );
  }
}
