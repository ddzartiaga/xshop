import 'package:flutter/foundation.dart';

import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  Map<String, Cart> _items = {};

  Map<String, Cart> get items => {..._items};

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;

    _items.forEach((p, c) => total += (c.price * c.quantity));

    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void addCartItem(
    String productId,
    String title,
    double price,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (ex) => Cart(
              cartId: DateTime.now().toString(),
              productId: ex.productId,
              title: ex.title,
              price: ex.price,
              quantity: ex.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => Cart(
                cartId: DateTime.now().toString(),
                productId: productId,
                title: title,
                price: price,
                quantity: 1,
              ));
    }

    notifyListeners();
  }

  void removeRecentItem(String prodId) {
    if (_items.containsKey(prodId)) {
      if (items[prodId].quantity > 1) {
        // remove one item
        _items.update(
            prodId,
            (ex) => Cart(
                  cartId: ex.cartId,
                  productId: ex.productId,
                  price: ex.price,
                  title: ex.title,
                  quantity: ex.quantity - 1,
                ));
      } else {
        // remove entirely the item
        _items.remove(prodId);
      }

      notifyListeners();
    }
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
