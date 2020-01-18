import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/main_drawer.dart';
import './user_products_item.dart';
import './user_product_form_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const route = '/user-products';

  void _showMessage(BuildContext ctx, String message) {
    Scaffold.of(ctx).removeCurrentSnackBar();
    Scaffold.of(ctx).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final prodsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(ProductFormScreen.route),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => prodsProvider.fetchProducts(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: prodsProvider.items.length,
              itemBuilder: (ctx, idx) => Column(
                children: [
                  UserProductsItem(
                    prodsProvider.items[idx].id,
                    prodsProvider.items[idx].title,
                    prodsProvider.items[idx].imageUrl,
                    _showMessage,
                  ),
                  Divider()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
