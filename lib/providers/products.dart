import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  final String? authToken;
  final String userId;

  List<Product> _items = [];
  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    return [..._items]; //to return a copy of them
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product? findById(String id) {
    return _items.firstWhereOrNull((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://giganigga-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      // print(json.decode(response.body));
      final extractData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractData == null) {
        _items = [];
        notifyListeners();
        return;
      }
      url =
          'https://giganigga-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'] ??
              '', // Check for null and provide a default value
          description: prodData['description'] ??
              '', // Check for null and provide a default value
          price: prodData['price'] ??
              0.0, // Check for null and provide a default value
          imageUrl: prodData['imageUrl'] ?? '',
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      _items = [];
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://giganigga-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          },
        ),
      ); // print(json.decode(response.body)); //a map that is generated by the server
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      if (kDebugMode) {
        print(newProduct.id);
      }
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      // print(error);
      rethrow;
    }
  }

  //...

  Future<void> updateProduct(String? id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://giganigga-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      if (kDebugMode) {
        print('...');
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://giganigga-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    // notifyListeners();
    final response = await http.delete(Uri.parse(url));

    if (kDebugMode) {
      print(response.statusCode); //404
    }
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      // notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;

    notifyListeners();
  }
}