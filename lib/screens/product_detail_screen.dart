import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final laodedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId)!;
    //listen argument is fales to avoid rebuilding this widget when it is not visible

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(laodedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(laodedProduct.title),
              background: Hero(
                tag: laodedProduct.id!,
                child: Image.network(
                  laodedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  width: double.infinity,
                  // height: 300,
                  // child: Hero(
                  //   tag: laodedProduct.id!,
                  //   child: Image.network(
                  //     laodedProduct.imageUrl,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '\$${laodedProduct.price}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    laodedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 800,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
