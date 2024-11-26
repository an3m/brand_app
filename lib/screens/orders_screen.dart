import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const String routeName = '/order';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;

  // @override
  // void initState() {
  //   // _isLoading = true;
  //   // Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then(
  //   //   (_) {
  //   //     setState(() {
  //   //       _isLoading = false;
  //   //     });
  //   //   },
  //   // );
  //   super.initState();
  // }

  // Future<void> _fetchOrders(BuildContext context) {
  //   return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  // }

  @override
  Widget build(BuildContext context) {
    // print('object');
    // final value = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
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
            return Consumer<Orders>(
              builder: (ctx, orderData, child) => orderData.orders.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (ctx, index) =>
                          OrderItem(orderData.orders[index]),
                      itemCount: orderData.orders.length,
                    )
                  : const Center(
                      child: Text('You don\'t have any orders yet!'),
                    ),
            );
          }
        },
      ),
    );
  }
}
