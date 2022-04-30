import 'package:firebasetest/widgets/app_drawer.dart';
import 'package:firebasetest/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/order';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: Colors.grey[800],
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
        builder: (ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.error != null) {
              return Center(child: Text('An occurred Error'),);
            } else {
              return Consumer<Orders>(builder: (ctx, orderData, child) =>
                  ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder:(BuildContext context,int index)=> OrderItem(orderData.orders[index]),
                  ),);
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}