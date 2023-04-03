import 'package:flutter/material.dart';
import 'package:shopapp/Providers/orders.dart';
import 'package:shopapp/helpers/custom_route.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/splash_screen.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './Providers/products.dart';
import 'package:provider/provider.dart';
import './Providers/cart.dart';
import './screens/order_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit__product_screen.dart';
import './screens/auth_screen.dart';
import './Providers/auth.dart';
import './Providers/orders.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items,
            ),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, authToken, previousOrders) => Orders(
              authToken.token,
              authToken.userId,
              previousOrders == null ? [] : previousOrders.orders,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MyShop',
              theme: ThemeData(
                  primarySwatch: Colors.red,
                  accentColor: Colors.redAccent,
                  fontFamily: 'Lato',
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CustomPageTransitonBuilder(),
                    TargetPlatform.iOS: CustomPageTransitonBuilder()
                  })),
              home: auth.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductScreen.routeName: (ctx) => UserProductScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen()
              }),
        ));
  }
}
