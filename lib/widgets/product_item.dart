import 'package:firebasetest/providers/auth.dart';
import 'package:firebasetest/providers/cart.dart';
import 'package:firebasetest/providers/product.dart';
import 'package:firebasetest/providers/products.dart';
import 'package:firebasetest/screens/product_detial_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final cart = Provider.of<Cart>(context,listen: false);
    final authData = Provider.of<Auth>(context,listen: false);
    return ClipRRect(borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: ()=> Navigator.of(context).pushNamed(ProductDetailScreen.routeName,arguments: product.id),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:AssetImage('assets/images/product-placeholder.png'),
              image:(product.imgUrl==null)?AssetImage('assets/images/product-placeholder.png'): NetworkImage(product.imgUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx,product,_)=> IconButton(
                onPressed: (){
                  product.toggleFavoriteStatus(authData.token, authData.userId);
                },
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border
                ),
                color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(product.title,textAlign: TextAlign.center,),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: (){
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Added To Cart!'),
                duration: Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: ()=> cart.removeSingleItem(product.id),
                ),
              ));

            },
          ),
        ),
    ),);
  }
}
