import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/premium_search_bar.dart';
import '../widgets/category_chip.dart';
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
      if (!mounted) return;
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Haidar's Shop"),
        actions: [
          PopupMenuButton<SortType>(
            icon: const Icon(Icons.sort_rounded),
            onSelected: provider.sortProducts,
            itemBuilder: (_) => const [
              PopupMenuItem(value: SortType.newest, child: Text('Newest')),
              PopupMenuItem(value: SortType.oldest, child: Text('Oldest')),
              PopupMenuItem(value: SortType.name, child: Text('Name')),
              PopupMenuItem(value: SortType.priceLow, child: Text('Price ↑')),
              PopupMenuItem(value: SortType.priceHigh, child: Text('Price ↓')),
            ],
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );

          if (!mounted) return;

          provider.loadProducts();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Welcome 👋',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 6),

            Text(
              'Manage your products professionally.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 20),

            DashboardCard(
              icon: Icons.inventory_2_rounded,
              title: 'Total Products',
              value: provider.totalProducts.toString(),
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 20),

            PremiumSearchBar(onChanged: provider.search),

            const SizedBox(height: 18),

            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: provider.categories
                    .map(
                      (category) => CategoryChip(
                        label: category,
                        selected: provider.selectedCategory == category,
                        onTap: () {
                          provider.selectCategory(category);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 24),

            Text('Products', style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 12),

            if (provider.products.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 72),
                      SizedBox(height: 16),
                      Text(
                        'No products found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap "Add Product" to create your first item.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...provider.products.map(
                (product) => ProductTile(
                  product: product,
                  onRefresh: provider.loadProducts,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
