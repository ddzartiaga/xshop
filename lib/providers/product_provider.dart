import 'package:flutter/foundation.dart';

class Product extends ProductProvider {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
  });
}

class ProductProvider with ChangeNotifier {
  bool isFavorite = false;

  void toggleIsFavorite() {
    this.isFavorite = !this.isFavorite;
    notifyListeners();
  }
}
