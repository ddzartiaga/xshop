import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import './product_detail_screen.dart';

class ProductsItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.route, arguments: product.id);
      },
      child: GridTile(
        header: Container(
          padding: const EdgeInsets.all(5),
          child: Text(product.title),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: Container(
          color: Colors.black45,
          //padding: const EdgeInsets.all(2.0),
          child: GridTileBar(
            leading: Consumer<Product>(
              builder: (ctx, data, child) => IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(data.isFavorite ? Icons.star : Icons.star_border),
                onPressed: () {
                  data.toggleIsFavorite();
                },
              ),
            ),
            title: Container(
              alignment: Alignment.center,
              child: Text(
                '\$${product.price}',
                style: TextStyle(fontSize: 15),
              ),
            ),
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cartProvider.addCartItem(
                  product.id,
                  product.title,
                  product.price,
                );

                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Item added to your cart'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cartProvider.removeRecentItem(product.id);
                    },
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
