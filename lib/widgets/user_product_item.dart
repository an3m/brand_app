import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  const UserProductItem(this.id, this.title, this.imageUrl, {super.key});

  Future<void> confirmDeleteProduct(
      BuildContext context, ScaffoldMessengerState scaffold) async {
    await showDialog(
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
              Navigator.of(cxt).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(cxt).pop();
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id);
              } catch (error) {
                scaffold.showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Deleting faild',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: CircleAvatar(
            //circleAvatar will fit and size the image automatically
            backgroundImage: NetworkImage(
                imageUrl), //NetworkImge is not a widget but an object
          ),
          trailing: SizedBox(
            // width: 100,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName, arguments: id);
                  },
                  icon: const Icon(Icons.edit),
                  color: Theme.of(context).colorScheme.primary,
                ),
                IconButton(
                  onPressed: () => confirmDeleteProduct(context, scaffold),
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          ),
        ),
        const Divider(
          indent: 8,
          endIndent: 8,
        ),
      ],
    );
  }
}
