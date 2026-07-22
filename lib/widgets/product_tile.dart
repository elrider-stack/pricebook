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

                await onRefresh();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
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
                      ElevatedButton(
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
