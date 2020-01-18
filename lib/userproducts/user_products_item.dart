import 'package:flutter/material.dart';
import 'package:myshop/providers/products_provider.dart';
import 'package:provider/provider.dart';

import './user_product_form_screen.dart';

class UserProductsItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Function _deleteCallback;

  UserProductsItem(this.id, this.title, this.imageUrl, this._deleteCallback);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        alignment: Alignment.centerRight,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.grey,
              ),
              onPressed: () => Navigator.of(context)
                  .pushNamed(ProductFormScreen.route, arguments: id),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Delete Product'),
                    content:
                        Text('Are you sure you want to delete the product?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('YES'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                      FlatButton(
                        child: Text('NO'),
                        onPressed: () => Navigator.of(context).pop(false),
                      )
                    ],
                  ),
                ).then((proceed) async {
                  if (proceed) {
                    try {
                      await Provider.of<ProductsProvider>(
                        context,
                        listen: false,
                      ).removeProduct(id);

                      _deleteCallback(context, 'Product removal successful!');
                    } catch (ex) {
                      _deleteCallback(context, 'Product removal failed!');
                    }
                  }
                });
                // call the provider delete
              },
            ),
          ],
        ),
      ),
    );
  }
}
