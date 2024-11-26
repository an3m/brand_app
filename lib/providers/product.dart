// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool oldState) {
    isFavorite = oldState;
    notifyListeners();
  }

  Future<void> toggleIsFavorite(
      BuildContext context, String authToken, String userId) async {
    final oldState = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://giganigga-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(
          isFavorite,
        ),
      );

      // print(response.statusCode);
      if (response.statusCode >= 400) {
        _setFavValue(oldState);
        throw HttpException('Could not add product to favorite.');
      }
    } catch (error) {
      _setFavValue(oldState);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),

          content: Text('Adding/Removing failed'),
          // textAlign: TextAlign.center,
        ),
      );
    }
    if (isFavorite != oldState) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),

          content: isFavorite
              ? const Text('Added to favorites')
              : const Text('Removed from favorites'),
          // textAlign: TextAlign.center,
        ),
      );
    }
  }
}
