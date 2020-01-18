import 'dart:math';
import 'package:flutter/material.dart';
import '../models/order.dart';

class OrdersItem extends StatefulWidget {
  final Order order;

  OrdersItem(this.order);

  @override
  _OrdersItemState createState() => _OrdersItemState();
}

class _OrdersItemState extends State<OrdersItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
        margin: const EdgeInsets.all(5),
        elevation: 5,
        child: ListTile(
          title: Text(
            '\$${widget.order.amount.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            widget.order.dateTime.toString(),
          ),
          trailing: IconButton(
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
        ),
      ),
      if (_expanded)
        Container(
          height: min(widget.order.items.length * 20.0 + 10, 180),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Card(
            color: Theme.of(context).accentColor.withAlpha(2),
            child: ListView(
              children: widget.order.items
                  .map((o) => Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              o.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${o.quantity}x',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
    ]);
  }
}
