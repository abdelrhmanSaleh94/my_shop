import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggelFav(String id, String token, String userdId) async {
    isFavorite = !isFavorite;
    final url =
        'https://myshop-10a89.firebaseio.com/userFavourit/$userdId/$id.json?auth=$token';
    try {
      await http.put(url, body: jsonEncode(isFavorite));
      notifyListeners();
    } catch (error) {
      throw HttpException('Could not Fav product.');
    }
  }
}
