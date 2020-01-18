import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import '../cart/cart_screen.dart';
import './products_item.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _showFavorites = false;
  bool _isFetched = false;
  bool _fetching = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isFetched) {
      setState(() {
        _fetching = true;
      });

      Provider.of<ProductsProvider>(context).fetchProducts().then((_) {
        setState(() {
          _fetching = false;
        });
      });
      _isFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final _products =
        _showFavorites ? productsProvider.favorites : productsProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('Show Favorites'),
                value: 0,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: 1,
              ),
            ],
            onSelected: (val) {
              setState(() {
                if (val == 0)
                  _showFavorites = true;
                else
                  _showFavorites = false;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.route);
            },
          ),
          Consumer<CartProvider>(
              builder: (ctx, pvdr, child) => Container(
                  padding: const EdgeInsets.all(3),
                  alignment: Alignment.center,
                  child: Text(pvdr.itemCount.toString()))),
        ],
      ),
      drawer: MainDrawer(),
      body: _fetching
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () =>
                  Provider.of<ProductsProvider>(context).fetchProducts(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (ctx, idx) {
                    return ChangeNotifierProvider.value(
                      value: _products[idx],
                      child: Container(
                        child: ProductsItem(),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
