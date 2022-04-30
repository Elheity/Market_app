
import 'package:firebasetest/providers/auth.dart';
import 'package:firebasetest/screens/auth_screen.dart';
import 'package:firebasetest/screens/orders_screen.dart';
import 'package:firebasetest/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Menu!',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.grey[800],
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            onTap: ()=> Navigator.of(context).pushReplacementNamed('home'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payment',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            onTap: ()=> Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('your products',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            onTap: ()=> Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('LogOut',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('login');
              Provider.of<Auth>(context,listen: false).logOut();
            },
          ),

        ],
      ),
    );
  }
}