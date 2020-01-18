import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../models/order.dart';
import '../models/cart.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  Future<void> getOrders() async {
    var res = await http.get('https://flutter-ddz.firebaseio.com/orders.json');

    List<Order> _loadedOrders = [];

    if (res.statusCode == 200) {
      var data = json.decode(res.body) as Map<String, dynamic>;

      data.forEach((key, val) {
        _loadedOrders.add(Order(
          id: key,
          amount: val['amount'],
          dateTime: DateFormat.yMMMd().parse(val['dateTime']),
          items: (val['items'] as List<dynamic>).map((item) {
            var cartData = item as Map<String, dynamic>;

            return Cart(
              productId: cartData['productId'],
              price: cartData['price'],
              quantity: cartData['quantity'],
              title: cartData['title'],
            );
          }).toList(),
        ));

        //print(_loadedOrders.toString());
      });

      _orders = _loadedOrders;
      notifyListeners();
    }
  }

  Future<void> addOrders(double totalAmount, List<Cart> cart) async {
    const url = 'https://flutter-ddz.firebaseio.com/orders.json';

    List<Map<String, dynamic>> cartProds = [];

    final orderDate = DateTime.now();

    cart.forEach((f) {
      cartProds.add(
        {
          'productId': f.productId,
          'title': f.title,
          'price': f.price,
          'quantity': f.quantity,
        },
      );
    });

    var orderMap = {
      'amount': totalAmount,
      'dateTime': DateFormat.yMMMd().format(orderDate),
      'items': cartProds
    };

    try {
      var res = await http.post(url, body: json.encode(orderMap));
      if (res.statusCode == 200) {
        _orders.add(
          Order(
            id: json.decode(res.body)['name'],
            amount: totalAmount,
            items: cart,
            dateTime: orderDate,
          ),
        );

        print('Orders successfully saved!');
        notifyListeners();
      } else {
        throw Exception(
          "Unable to fetch products. Server returned ${res.statusCode}",
        );
      }
    } catch (ex) {
      print(ex.toString());
      throw ex;
    }
  }
}
