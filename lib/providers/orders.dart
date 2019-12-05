import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String token;
  final String userid;
  Orders(this.token, this.userid, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrdersData() async {
    final url = 'https://myshop-10a89.firebaseio.com/orders/$userid.json?auth=$token';
    try {
      final response = await http.get(url);
      final List<OrderItem> loadOrder = [];
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      extractData.forEach((/* orderid */ key, /*orderData*/ value) {
        loadOrder.add(OrderItem(
            id: key,
            amount: value['amount'],
            dateTime: DateTime.parse(value['dateTime']),
            products: (value['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title']))
                .toList()));
        _orders = loadOrder.reversed.toList();
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final stampTime = DateTime.now();
    final url = 'https://myshop-10a89.firebaseio.com/orders/$userid.json?auth=$token';
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': stampTime.toIso8601String(),
            'products': cartProducts
                .map((pro) => {
                      'id': pro.id,
                      'title': pro.title,
                      'quantity': pro.quantity,
                      'price': pro.price,
                    })
                .toList(),
          }));

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: stampTime,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
