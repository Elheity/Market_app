import 'package:firebasetest/providers/products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail';

  /*Future<void> _calling ()async{
    var url = '';
    if(! await canLaunch(url)){
      await launch(url);
    }else{
      throw 'could not launch $url';
    }
  }*/
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context).findById(productId);
   // final url = /*'tel:+20${loadedProduct.phone}'*/'https://www.google.com/';
    Future<void> _calling ()async{
      var url = 'tel:+1 555 010 999';

      /*if(! await canLaunch(url)){
        await launch(url);
      }else{
        throw 'could not launch $url';
      }*/
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imgUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text(
                  '\$${loadedProduct.price}',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(
                  '\0${loadedProduct.phone}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                trailing:
                RaisedButton(
                  onPressed: (){
                    UrlLauncher.launch('tel:+20${loadedProduct.phone}');
                  },
                      /*() async {
                    if (!await canLaunch(url)) {
                      await launch(
                        url,
                      );
                    } else {
                      throw 'Could not launch $url';
                    }
                  },*/
                  child: Text(
                    'Call Now',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                width: double.infinity,
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87, fontSize: 20),
                  softWrap: true,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
