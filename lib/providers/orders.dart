import 'dart:convert';

import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? authToken;
  final String userId;
  Orders(this.authToken, this._orders, this.userId);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://giganigga-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));

      if (kDebugMode) {
        print(response.body);
      }
      final extractData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractData == null) {
        _orders = [];
        notifyListeners();
        return;
      }

      final List<OrderItem> loadedOrders = [];

      extractData.forEach((ordId, ordData) {
        loadedOrders.add(
          OrderItem(
            id: ordId,
            amount: ordData['amount'],
            products: (ordData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      quantity: item['quantity'],
                      price: item['price']),
                )
                .toList(),
            dateTime: DateTime.parse(ordData['date']),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      _orders = [];
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://giganigga-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(
        {
          'amount': total,
          'date': timestamp
              .toIso8601String(), //because the ability of return it to dateTime type
          'products': cartProducts
              .map(
                (e) => {
                  'id': e.id,
                  'title': e.title,
                  'quantity': e.quantity,
                  'price': e.price,
                },
              )
              .toList()
        },
      ),
    );

    _orders.insert(
      0, //to make it above old orders
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}
