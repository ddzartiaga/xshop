import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final int qty;
  final double price;

  CartItem({this.id, this.title, this.qty, this.price});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.startToEnd,
      background: Container(
        //margin: const EdgeInsets.symmetric(horizontal: 15),
        color: Theme.of(context).errorColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        alignment: Alignment.centerLeft,
      ),
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Delete Item'),
            content: Text('Are you sure you want to delete the item?'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'YES',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
              FlatButton(
                child: Text(
                  'NO',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        cartProvider.removeItem(id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        elevation: 5,
        child: ListTile(
          leading: CircleAvatar(
            child: FittedBox(
              child: Text(
                'x$qty',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          title: Text(title),
          trailing: Text(
            'Php ${(qty * price).toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
