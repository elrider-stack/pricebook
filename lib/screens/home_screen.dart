import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/product_tile.dart';
import 'add_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PriceBook'),
        centerTitle: true,
        actions: [
          PopupMenuButton<SortType>(
            icon: const Icon(Icons.sort),
            onSelected: provider.sortProducts,
            itemBuilder: (_) => const [
              PopupMenuItem(value: SortType.newest, child: Text('Newest')),
              PopupMenuItem(value: SortType.oldest, child: Text('Oldest')),
              PopupMenuItem(value: SortType.name, child: Text('Name A-Z')),
              PopupMenuItem(
                value: SortType.priceLow,
                child: Text('Price Low-High'),
              ),
              PopupMenuItem(
                value: SortType.priceHigh,
                child: Text('Price High-Low'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Total Products: ${provider.totalProducts}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search product...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: provider.search,
            ),
          ),
          Expanded(
            child: provider.products.isEmpty
                ? const Center(child: Text('No products found'))
                : ListView.builder(
                    itemCount: provider.products.length,
                    itemBuilder: (_, index) {
                      return ProductTile(
                        product: provider.products[index],
                        onRefresh: provider.loadProducts,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );

          if (!mounted) return;

          provider.loadProducts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
