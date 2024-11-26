import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import '../helpers/custom_routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(null, [], ''),
          // value: Products(),
          //////another way to declare a provider if we have a list of Widgets like GridView
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            previousProducts == null ? [] : previousProducts.items,
            auth.userId,
          ),
          //an instance of provider data
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders('', [], ''),
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            previousOrders == null ? [] : previousOrders.orders,
            auth.userId,
          ),
        ),
      ],
      child: Builder(builder: (context) {
        return Consumer<Auth>(
          builder: (cxt, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              // useMaterial3: false,

              // The AppBar.backgroundColor uses the ColorScheme.surface by default.
              hintColor: Colors.lightGreen,
              textTheme:
                  const TextTheme(titleLarge: TextStyle(color: Colors.white)),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal,
                brightness: Brightness.light,
              ),
              applyElevationOverlayColor: false,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
              }),
              appBarTheme: AppBarTheme(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal.shade800,
              ),
            ),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (cxt, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              ProductsOverviewScreen.routName: (context) =>
                  ProductsOverviewScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              UserProductsScreen.routeName: (context) =>
                  const UserProductsScreen(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen()
            },
            debugShowCheckedModeBanner: false,
          ),
        );
      }),
    );
  }
}
