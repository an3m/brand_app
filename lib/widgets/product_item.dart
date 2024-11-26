import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    // final scaffold = ScaffoldMessenger.of(context);
    final product = Provider.of<Product>(context);
    //we can use consumer instead of this approach when we wanna display it on widget tree
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        //a new widget//
        footer: GridTileBar(
          backgroundColor: Colors.black87, ///////////////
          leading: IconButton(
            onPressed: () {
              product.toggleIsFavorite(
                context,
                authData.token == null ? '' : authData.token!,
                authData.userId,
              );

              // Provider.of<Product>(context, listen: false)
            },
            color: Theme.of(context).hintColor,
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
          ),

          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product.id!, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              ScaffoldMessenger.of(context).showSnackBar(
                //the nearest scaffold widget

                SnackBar(
                  content: const Text('Added item to cart!'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id as String); //String?
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).hintColor,
            icon: const Icon(Icons.shopping_cart),
          ),
        ),
        //a new widget//
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id!,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/6.2 product-placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
