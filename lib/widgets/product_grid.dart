import 'package:brand_app/providers/products.dart';
import 'package:brand_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;
  const ProductGrid(this.showFavs, {super.key});
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context); //listener
    final products = showFavs ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        // changed it from ChangeNotifierProvider because the provider doesn't depends on a context to do its job
        value: products[index],
        child: ProductItem(),
      ),
    );
  }
}
