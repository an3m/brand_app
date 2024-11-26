// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_grid.dart';
import '../widgets/cart_badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routName = '/products-overview';

  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  // var _isLoading = false;
  // var _isinit = true;

  // Future<void> _refreshProducts(BuildContext context) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  //   } catch (error) {
  //     // ignore: use_build_context_synchronously
  //     await showDialog<void>(
  //       context: context,
  //       builder: (cxt) => AlertDialog(
  //         title: const Text('An error occured!'),
  //         content: const Text(
  //             'Something went wrong!\nTry to check your connection.'),
  //         actions: [
  //           MaterialButton(
  //             onPressed: () {
  //               Navigator.of(cxt).pop(); //not context
  //             },
  //             child: const Text('Okay'),
  //             // animationDuration: Duration,
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  // @override
  // void didChangeDependencies() {
  //   if (_isinit) {
  //     _refreshProducts(context);
  //   }
  //   _isinit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        //  backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Consumer<Cart>(
            builder: (_, value, ch) => CartBadge(
              value: value.itemCount.toString(),
              child: ch as Widget,
              onTap: () {
                Navigator.of(context).pushNamed(
                  CartScreen.routeName,
                );
              },
            ),
            // child: Icon(Icons.shopping_cart),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CartScreen.routeName,
                );
              },
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.Favorites,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.All,
                child: Text('Show All'),
              ),
            ],
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<Products>(context, listen: false).fetchAndSetProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Something went wrong!\nTry to check your connection.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () {
                      // Trigger a new Future by rebuilding the FutureBuilder
                      setState(() {});
                    },
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .fetchAndSetProducts();
                } catch (error) {
                  setState(() {});
                }
              },
              child: ProductGrid(_showOnlyFavorites),
            );
          }
        },
      ),
      // RefreshIndicator(
      //   onRefresh: () => _refreshProducts(context),
      //   child: _isLoading
      //       ? const Center(
      //           child: CircularProgressIndicator(),
      //         )
      //       : ProductGrid(_showOnlyFavorites),
      // ),
    );
  }
}
