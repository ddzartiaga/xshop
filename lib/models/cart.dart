import 'package:flutter/foundation.dart';

class Cart {
  String cartId;
  String productId;
  String title;
  int quantity;
  double price;

  Cart({
    @required this.cartId,
    @required this.productId,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
}
