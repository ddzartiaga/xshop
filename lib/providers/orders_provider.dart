import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/order.dart';
import '../models/cart.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  Future<void> addOrders(double totalAmount, List<Cart> cart) async {
    const url = 'https://flutter-ddz.firebaseio.com/orders.json';

    List<Map<String, dynamic>> t = [];

    cart.forEach((f) {
      t.add(
        {
          'cartId': f.cartId,
          'productId': f.productId,
          'title': f.title,
          'price': f.productId,
          'quantity': f.quantity,
        },
      );
    });

    try {
      var res = await http.post(url, body: json.encode(t));
      print(res.statusCode);
      if (res.statusCode == 200) {
        _orders.add(
          Order(
            id: DateTime.now().toString(),
            amount: totalAmount,
            items: cart,
            dateTime: DateTime.now(),
          ),
        );
        print('Orders Posted');
        notifyListeners();
      }
    } catch (ex) {
      print('Error posting order');
    }
  }
}
