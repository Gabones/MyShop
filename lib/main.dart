import 'package:flutter/material.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/cart_screen.dart';
import './screens/auth_screen.dart';
import './screens/orders_screen.dart';
import './screens/splash_screen.dart';

import './providers/products.dart';
import './providers/orders.dart';
import './providers/cart.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products('', '', []),
            update: (ctx, auth, previousProduct) => Products(
                auth.token,
                auth.userId,
                previousProduct == null ? [] : previousProduct.items),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders('', '', []),
            update: (ctx, auth, previousOrder) => Orders(
                auth.token!,
                auth.userId!,
                previousOrder == null ? [] : previousOrder.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, child) => MaterialApp(
              title: 'Autoria035',
              theme: ThemeData(
                  primarySwatch: Colors.primaryWhite,
                  accentColor: Colors.black,
                  fontFamily: 'Lato'),
              home: authData.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: authData.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
                UserProductScreen.routeName: (ctx) => UserProductScreen(),
                OrderScreen.routeName: (ctx) => OrderScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
              }),
        ));
  }
}
