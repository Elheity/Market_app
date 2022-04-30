import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetest/providers/auth.dart';
import 'package:firebasetest/providers/cart.dart';
import 'package:firebasetest/providers/products.dart';
import 'package:firebasetest/screens/cart_screen.dart';
import 'package:firebasetest/widgets/app_drawer.dart';
import 'package:firebasetest/widgets/auth_form.dart';
import 'package:firebasetest/widgets/badge.dart';
import 'package:firebasetest/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOption { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoading = false;
  var _showOnlyFavorites = false;

  //var _isInit = false;
  @override
  void initState() {
    super.initState();
    Provider.of<Products>(context, listen: false).fetchAndSetProduct().then(
          (_) => setState(() => _isLoading = false),
        );
  }

  @override
  Widget build(BuildContext context) {
    var _key=GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Colors.grey[800],
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption selectedVal) {
              setState(() {
                if (selectedVal == FilterOption.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                value: FilterOption.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                value: FilterOption.All,
              ),
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
            builder: (_, cart, ch) =>
                Badge(value: cart.itemCount.toString(), child: ch),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
      drawer: AppDrawer(),
    );
  }
}
