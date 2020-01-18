import 'dart:convert';
import 'package:http/http.dart' as http;
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

  Future<void> toggleIsFavorite(String id) async {
    this.isFavorite = !this.isFavorite;
    notifyListeners();

    try {
      var res = await http.patch(
          'https://flutter-ddz.firebaseio.com/products/$id.json',
          body: json.encode({'isFavorite': this.isFavorite}));

      print(res.statusCode);

      if (res.statusCode != 200)
        throw Exception('Server returned error with code: ${res.statusCode}');
    } catch (ex) {
      print(ex.toString());
      this.isFavorite = !this.isFavorite;
    } finally {
      notifyListeners();
    }
  }
}
