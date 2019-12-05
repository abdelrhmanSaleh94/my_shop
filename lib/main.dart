import 'package:flutter/material.dart';
import './screen/products_overview.dart';
import './screen/product_detils.dart';
import 'package:provider/provider.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screen/order_screen.dart';
import './screen/cart_screen.dart';
import './screen/edit_product.dart';
import './screen/user_product.dart';
import './screen/auth_screen.dart.dart';
import './providers/auth.dart';
import './screen/splash_screen.dart';
import './helper/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            
            builder: (ctx, auth, previousProducts) => Products(
                auth.token,
                previousProducts == null ? [] : previousProducts.itemsProduct,
                auth.userId),
          ),
          ChangeNotifierProvider.value(value: Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            builder: (ctx, auth, previousOrders) => Orders(
                auth.token,
                auth.userId,
                previousOrders == null ? [] : previousOrders.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.orangeAccent,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android:CustomPageTransitionBuilder(),
                    TargetPlatform.iOS:CustomPageTransitionBuilder(),
                    TargetPlatform.fuchsia:CustomPageTransitionBuilder(),
                  }
                ),
                textTheme: TextTheme(title: TextStyle(fontFamily: 'Anton'))),
            routes: {
              ProductDetils.routeName: (ctx) => ProductDetils(),
              CartScreen.routName: (ctx) => CartScreen(),
              OrdersScreen.routename: (ctx) => OrdersScreen(),
              UserProducts.routeName: (ctx) => UserProducts(),
              EditProduct.routeName: (ctx) => EditProduct(),
            },
            home: auth.isAuth
                ? ProductsOverViewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            debugShowCheckedModeBanner: false,
          ),
        ));
  }
}
