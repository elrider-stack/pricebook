import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../providers/theme_provider.dart';
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
    final theme = context.watch<ThemeProvider>();

    final totalValue = provider.products.fold<double>(
      0,
      (sum, item) => sum + item.price,
    );

    final favorites = provider.products.where((e) => e.favorite).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Haidar's Shop"),
        actions: [
          IconButton(
            icon: Icon(
              theme.themeMode == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            onPressed: theme.toggleTheme,
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
              "Dashboard",
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    icon: Icons.inventory_2_rounded,
                    title: "Products",
                    value: provider.totalProducts.toString(),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    icon: Icons.star_rounded,
                    title: "Favorites",
                    value: favorites.toString(),
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    icon: Icons.payments_rounded,
                    title: "Value",
                    value: "₦${totalValue.toStringAsFixed(2)}",
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: DashboardCard(
                    icon: Icons.category_rounded,
                    title: "Categories",
                    value: provider.categories.length.toString(),
                    color: Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            PremiumSearchBar(onChanged: provider.search),

            const SizedBox(height: 16),

            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: provider.categories
                    .map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryChip(
                          label: category,
                          selected: provider.selectedCategory == category,
                          onTap: () => provider.selectCategory(category),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 24),

            Text("Products", style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 12),

            if (provider.products.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Center(child: Text("No products found.")),
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
