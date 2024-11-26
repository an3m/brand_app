import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatefulWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String productId;

  const CartItem(
      this.id, this.price, this.quantity, this.title, this.productId);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Dismissible(
        key: ValueKey(widget.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            //because the show dialog returns a Future
            context: context,
            builder: (cxt) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text(
                'Do you want to remove the item from the cart ?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(cxt).pop(false);
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(cxt).pop(true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) => Provider.of<Cart>(context, listen: false)
            .removeItem(widget.productId), //he used productId
        background: Container(
          // margin: const EdgeInsets.symmetric(
          //   horizontal: 15,
          //   vertical: 4,
          // ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),

        child: Card(
          margin: EdgeInsets.zero,
          // semanticContainer: true,

          // margin: const EdgeInsets.symmetric(
          //   horizontal: 15,
          //   vertical: 4,
          // ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              // contentPadding: EdgeInsets.all(8),
              leading: CircleAvatar(
                radius: 25,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: FittedBox(
                    child: Text('\$${widget.price}'),
                  ),
                ),
              ),
              title: Text(widget.title),
              subtitle: Text(
                  'Total: \$${(widget.price * widget.quantity).toStringAsFixed(2)}'),

trailing: TextButton(
  onPressed: () {
    Provider.of<Cart>(context, listen: false)
        .decreaseQuantity(widget.productId); // Ensure widget.id or widget.productId matches
  },
  child: Row(
    mainAxisSize: MainAxisSize.min, // Keeps the Row as compact as possible
    children: [
      Consumer<Cart>(
        builder: (ctx, cart, child) => Text(
          '${cart.items.values.firstWhere((element) => element.id == widget.id).quantity} x',
          style: TextStyle(color: Theme.of(context).textTheme.button?.color), // Optional styling for text
        ),
      ),
      const SizedBox(width: 4), // Space between text and icon
      Icon(
        Icons.remove_circle_outline,
        color: Theme.of(context).colorScheme.error,
      ),
    ],
  ),
),
              
              //  TextButton.icon(
              //     label: Consumer<Cart>(
              //       builder: (ctx, cart, child) => Text(
              //           '${cart.items.values.firstWhere((element) => element.id == widget.id).quantity} x'),
              //     ),
              //     icon: Icon(
              //       Icons.remove_circle_outline,
              //       color: Theme.of(context).colorScheme.error,
              //     ),
              //     onPressed: () {
              //       Provider.of<Cart>(context, listen: false)
              //           .decreaseQuantity(widget.productId);
              //     }),
            ),
          ),
        ),
      ),
    );
  }
}
