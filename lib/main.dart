import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/cart_provider.dart';
import './providers/products_provider.dart';
import './providers/orders_provider.dart';
import './products/products_screen.dart';
import './products/product_detail_screen.dart';
import './cart/cart_screen.dart';
import './orders/orders_screen.dart';
import './userproducts/user_products_screen.dart';
import './userproducts/user_product_form_screen.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductsProvider()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => OrdersProvider()),
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.yellow,
          fontFamily: 'Lato',
          textTheme: ThemeData.light().textTheme.copyWith(),
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => ProductsScreen(),
          ProductDetailScreen.route: (ctx) => ProductDetailScreen(),
          CartScreen.route: (ctx) => CartScreen(),
          OrdersScreen.route: (ctx) => OrdersScreen(),
          UserProductsScreen.route: (ctx) => UserProductsScreen(),
          ProductFormScreen.route: (ctx) => ProductFormScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
