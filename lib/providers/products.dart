import 'dart:core';

import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _itemsProduct = []; //DummyProductData;
  final String authToken;
  final String userId;

  Products(this.authToken, this._itemsProduct, this.userId);

  List<Product> get itemsProduct {
    return [..._itemsProduct];
  }

  Product findById(String id) {
    return _itemsProduct.firstWhere((prod) => prod.id == id);
  }

  List<Product> get favoriteItems {
    return _itemsProduct.where((pro) => pro.isFavorite).toList();
  }

  Future<void> fetchProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    var url =
        'https://myshop-10a89.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final List<Product> loadProduct = [];
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      url =
          'https://myshop-10a89.firebaseio.com/userFavourit/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      extractData.forEach((proId, proData) {
        loadProduct.add(Product(
            id: proId,
            title: proData['title'],
            description: proData['description'],
            imageUrl: proData['imageUrl'],
            price: proData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[proId] ?? false));
      });
      _itemsProduct = loadProduct;
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://myshop-10a89.firebaseio.com/products.json?auth=$authToken';
    Map<String, String> headers = {};
    headers['Accept'] = 'application/json';
    headers['Content-type'] = 'application/json';
    try {
      final respose = await http.post(url,
          headers: headers,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }));

      _itemsProduct.add(Product(
          id: json.decode(respose.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          isFavorite: product.isFavorite));
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }

    //_itemsProduct.add(value);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _itemsProduct.indexWhere((pro) => pro.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://myshop-10a89.firebaseio.com/products/$id.json?auth=$authToken';
      Map<String, String> headers = {};
      headers['Accept'] = 'application/json';
      headers['Content-type'] = 'application/json';
      try {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price
            }));
        _itemsProduct[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('Not Found');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://myshop-10a89.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _itemsProduct.indexWhere((prod) => prod.id == id);
    var existingProduct = _itemsProduct[existingProductIndex];
    _itemsProduct.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _itemsProduct.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
