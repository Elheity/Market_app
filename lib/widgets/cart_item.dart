import 'package:firebasetest/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final int price ;
  final double quntity;
  final String title;

  const CartItem(this.id, this.productId, this.quntity,this.price,  this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(
          context: context,
          builder: (ctx)=>AlertDialog(
            backgroundColor: Colors.red[100],
            title: Text('Are you Sure'),
            content: Text('delete your order'),
            actions: [
              FlatButton(
                child: Text('NO'),
                onPressed: ()=> Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: ()=> Navigator.of(context).pop(true),
              ),
            ],
          )
        );
      },
      onDismissed: (direction){
        Provider.of<Cart>(context,listen: false).removeItem(productId);
      },
      child: Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[800],
            child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: Text('\$$price',style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total \$${(price*quntity)}'),
          trailing: Text('$quntity x'),
        ),
      ),
    ));
  }
}
