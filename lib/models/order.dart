import 'package:flutter/foundation.dart';
import './cart.dart';

class Order {
  String id;
  double amount;
  List<Cart> items;
  DateTime dateTime;

  Order({
    @required this.id,
    @required this.amount,
    @required this.items,
    @required this.dateTime,
  });
}
