import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const route = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final prodId = ModalRoute.of(context).settings.arguments as String;
    final product = productsProvider.getById(prodId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      '\$${product.price}',
                      style: TextStyle(fontSize: 25, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    child: Text(
                      product.description,
                      style: TextStyle(fontSize: 20),
                      softWrap: true,
                    ),
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.shopping_cart,
          color: Theme.of(context).primaryTextTheme.title.color,
        ),
        onPressed: () {
          cartProvider.addCartItem(product.id, product.title, product.price);
        },
      ),
    );
  }
}
