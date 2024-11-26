import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    // return _items.length;
    int count = 0;
    _items.forEach((key, value) => count += value.quantity);
    // var itemsList =
    //     _items.values.toList();

    // for (var element in itemsList) {
    //   count += element.quantity;
    // }
    return count;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      //... Change the quantity

      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    // _items.removeWhere((key, value) => value.id == productId);
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    
    if (!_items.containsKey(productId)) {
      print('zoo');
      return; // If the item doesn't exist, no action is taken
    }

    if (_items[productId]!.quantity > 1) {
      // Decrease quantity by 1 if it’s greater than 1
      _items.update(productId, (existingItem) {
        print(existingItem.quantity);
        return CartItem(
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity - 1,
          price: existingItem.price,
        );
      });
    } else {
      // Remove the item if quantity is 1
      _items.remove(productId);
    }

    notifyListeners(); // Notify listeners about the update
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
          price: existingCartItem.price,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
