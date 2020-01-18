import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../viewmodels/product_viewmodel.dart';
import './product_provider.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items => [..._items];

  List<Product> get favorites {
    return _items.where((i) => i.isFavorite).toList();
  }

  Product getById(String id) {
    return _items.firstWhere((p) => p.id == id);
  }

  Future<void> fetchProducts() async {
    try {
      List<Product> data = [];
      var res =
          await http.get('https://flutter-ddz.firebaseio.com/products.json');

      if (res.statusCode == 200) {
        var list = json.decode(res.body) as Map<String, dynamic>;

        list.forEach((key, val) {
          var prod = Product(
            id: key,
            title: val['title'],
            description: val['description'],
            price: val['price'],
            imageUrl: val['imageUrl'],
          );
          prod.isFavorite = val['isFavorite'];
          data.add(prod);
        });

        _items = data;

        notifyListeners();
      } else {
        throw Exception(
          "Unable to fetch products. Server returned ${res.statusCode}",
        );
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future<void> insertProduct(ProductViewModel prodVm) async {
    const String url = 'https://flutter-ddz.firebaseio.com/products.json';

    String reqBody = json.encode({
      'title': prodVm.title,
      'description': prodVm.description,
      'price': prodVm.price,
      'imageUrl': prodVm.imageUrl,
      'isFavorite': false,
    });

    if (prodVm.id.isEmpty) {
      var res = await http.post(url, body: reqBody);

      try {
        // Add only if status code is 200
        if (res.statusCode == 200) {
          String genId = json.decode(res.body)['name'].toString();

          prodVm.id = genId;
          // assemble the product instance from vm
          var product = Product(
            id: prodVm.id,
            title: prodVm.title,
            description: prodVm.description,
            price: prodVm.price,
            imageUrl: prodVm.imageUrl,
          );
          product.isFavorite = false;

          _items.add(product);

          print('Added Product with ID: ${product.id}');
          notifyListeners();
        } else {
          throw Exception('Product creation failed');
        }
      } catch (ex) {
        // this will be hit if then resulted to error and the http library throw error
        print(ex.toString());
        throw ex;
      }
    }
  }

  Future<void> updateProduct(ProductViewModel prodVm) async {
    const String url = 'https://flutter-ddz.firebaseio.com/products';

    String reqBody = json.encode({
      'title': prodVm.title,
      'description': prodVm.description,
      'price': prodVm.price,
      'imageUrl': prodVm.imageUrl,
    });

    if (prodVm.id.isNotEmpty) {
      try {
        var res = await http.patch('$url/${prodVm.id}.json', body: reqBody);

        if (res.statusCode == 200) {
          var product = Product(
            id: prodVm.id,
            title: prodVm.title,
            description: prodVm.description,
            price: prodVm.price,
            imageUrl: prodVm.imageUrl,
          );

          int index = _items.indexWhere((p) => p.id == prodVm.id);
          if (index > -1) {
            var isFave = _items[index].isFavorite; // get the old is favorite
            product.isFavorite = isFave;

            _items[index] = product;

            print('Updated product with ID: ${_items[index].id}');
            notifyListeners();
          }
        } else {
          throw Exception('Product update failed');
        }
      } catch (ex) {
        print(ex.toString());
        throw ex;
      }
    }
  }

  Future<void> removeProduct(String id) async {
    const String url = 'https://flutter-ddz.firebaseio.com/products';

    try {
      var res = await http.delete('$url/$id.json');

      if (res.statusCode == 200) {
        int index = _items.indexWhere((p) => p.id == id);

        if (index >= 0) {
          _items.removeAt(index);
          notifyListeners();
        }
      } else {
        throw Exception('Unable to delete item with ID: $id');
      }
    } catch (err) {
      print(err.toString());
      throw err;
    }
  }
}
