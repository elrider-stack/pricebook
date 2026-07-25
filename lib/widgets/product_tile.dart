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

  Future<void> _showMenu(BuildContext context) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('Edit'),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading: Icon(product.favorite ? Icons.star : Icons.star_border),
              title: Text(product.favorite ? 'Remove Favorite' : 'Favorite'),
              onTap: () => Navigator.pop(context, 'favorite'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded, color: Colors.red),
              title: const Text('Delete'),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );

    if (!context.mounted || action == null) return;

    switch (action) {
      case 'edit':
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddProductScreen(product: product)),
        );

        await onRefresh();
        break;

      case 'favorite':
        await DatabaseHelper.instance.updateProduct(
          product.copyWith(favorite: !product.favorite),
        );

        await onRefresh();
        break;

      case 'delete':
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
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () => _showMenu(context),
        onLongPress: () => _showMenu(context),
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
                  child: const Icon(Icons.inventory_2_rounded),
                ),
        ),
        title: Text(product.name),
        subtitle: Text(
          '${product.category}\n₦${product.price.toStringAsFixed(2)}',
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.more_vert),
      ),
    );
  }
}
