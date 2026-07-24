import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/premium_search_bar.dart';
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
        title: const Text("Haidar's Shop"),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: provider.loadProducts,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );

          provider.loadProducts();
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Product"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text(
              "Welcome 👋",
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 6),

            Text(
              "Manage your inventory professionally.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 20),

            DashboardCard(
              icon: Icons.inventory_2_rounded,
              title: "Total Products",
              value: provider.totalProducts.toString(),
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 18),

            PremiumSearchBar(onChanged: provider.search),

            const SizedBox(height: 18),

            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: provider.categories
                    .map(
                      (e) => CategoryChip(
                        label: e,
                        selected: provider.selectedCategory == e,
                        onTap: () => provider.selectCategory(e),
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 24),

            Text("Products", style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 10),

            if (provider.products.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 80),
                      SizedBox(height: 18),
                      Text(
                        'No products available',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap "Add Product" to create your first product.',
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
