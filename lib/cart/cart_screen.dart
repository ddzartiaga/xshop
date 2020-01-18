import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../orders/orders_screen.dart';
import './cart_item.dart';

class CartScreen extends StatelessWidget {
  static const route = '/cart';

  void _showMessage(BuildContext context, String message) {
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(5),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Grand Total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    padding: const EdgeInsets.all(5),
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      'Php ${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                  ),
                  OrderNowButton(
                    ordersProvider: ordersProvider,
                    cartProvider: cartProvider,
                    parentContext: context,
                    callbackFn: _showMessage,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (ctx, idx) {
                final cart = cartProvider.items.values.toList()[idx];
                return CartItem(
                  id: cart.productId,
                  title: cart.title,
                  qty: cart.quantity,
                  price: cart.price,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class OrderNowButton extends StatefulWidget {
  final OrdersProvider ordersProvider;
  final CartProvider cartProvider;
  final BuildContext parentContext;
  final Function callbackFn;

  const OrderNowButton({
    @required this.ordersProvider,
    @required this.cartProvider,
    this.parentContext,
    this.callbackFn,
  });

  @override
  _OrderNowButtonState createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FittedBox(child: CircularProgressIndicator()))
        : FlatButton(
            child: Text(
              'ORDER NOW',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () async {
              setState(() {
                _loading = true;
              });

              try {
                await widget.ordersProvider.addOrders(
                    widget.cartProvider.totalAmount,
                    widget.cartProvider.items.values.toList());

                widget.cartProvider.clearCart();

                Navigator.of(context).pushNamed(OrdersScreen.route);
              } catch (ex) {
                widget.callbackFn(
                    widget.parentContext, 'ERROR: Add order(s) failed.');
              } finally {
                setState(() {
                  _loading = false;
                });
              }
            },
          );
  }
}
