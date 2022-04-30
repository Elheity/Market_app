import 'package:firebase_core/firebase_core.dart';
import 'package:firebasetest/providers/auth.dart';
import 'package:firebasetest/providers/cart.dart';
import 'package:firebasetest/providers/orders.dart';
import 'package:firebasetest/providers/products.dart';
import 'package:firebasetest/screens/Intro.dart';
import 'package:firebasetest/screens/auth_screen.dart';
import 'package:firebasetest/screens/cart_screen.dart';
import 'package:firebasetest/screens/edit_product_screen.dart';
import 'package:firebasetest/screens/orders_screen.dart';
import 'package:firebasetest/screens/product_detial_screen.dart';
import 'package:firebasetest/screens/product_overview_screen.dart';
import 'package:firebasetest/screens/splash_screen.dart';
import 'package:firebasetest/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth,Orders>(
          create: (_)=> Orders(),
          update: (ctx,authVal,previousOrders)=>previousOrders..getData(
              authVal.token,
              authVal.userId,
              previousOrders==null?null: previousOrders.orders,
          ),
        ),
        ChangeNotifierProxyProvider<Auth,Products>(
          create: (_)=> Products(),
          update: (ctx,authVal,previousProducts)=>previousProducts..getData(
              authVal.token,
              authVal.userId,
              previousProducts==null?null: previousProducts.items
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx,auth,_)=> MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductOverviewScreen(): FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (ctx, AsyncSnapshot authSnapshot)=> authSnapshot.connectionState == ConnectionState.waiting ? SplashScreen():Intro(),
          ),
          routes: {
            ProductDetailScreen.routeName : (_) => ProductDetailScreen(),
            CartScreen.routeName : (_) => CartScreen(),
            OrdersScreen.routeName : (_) => OrdersScreen(),
            EditProductScreen.routeName : (_) => EditProductScreen(),
            UserProductScreen.routeName : (_) => UserProductScreen(),
            'home': (context) => ProductOverviewScreen(),
            'intro': (context) => Intro(),
            'login': (context) => AuthScreen(authType: AuthType.login),
            'register': (context) => AuthScreen(authType: AuthType.register),
          },
        ),
      )

    );
  }
}




