import 'dart:convert';

import 'package:firebasetest/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;


  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}
class Orders with ChangeNotifier{
  List<OrderItem> _orders= [];
  String authToken;
  String userId;
  getData(String authTok,String uId, List<OrderItem> orders){
    authToken = authTok;
    userId = uId;
    _orders = orders;
    notifyListeners();
  }
  List<OrderItem> get orders{
    return[..._orders];
  }
  Future<void> fetchAndSetOrder ()async{

    final url = 'https://product-caa98-default-rtdb.firebaseio.com/orders/$userId.json?auth$authToken';
    try{
      final res =await http.get(url);
      final extractData = json.decode(res.body) as Map<String,dynamic>;
      if(extractData == null){
        return;
      }
      final List<OrderItem> loadedOrders = [];
      extractData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>).map((item) => CartItem(
                id: item['id'],
                title: item['title'],
                quntity: item['quntity'],
                price: item['price'],
            )).toList(),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    }catch(e){

    }
  }
  Future<void> addOrders(List<CartItem> cartProduct , double total)async{
    final url = 'https://product-caa98-default-rtdb.firebaseio.com/orders/$userId.json?auth$authToken';
    try{
      final timeStamp = DateTime.now();
      final res = await http.post(url,body: json.encode({
        'amount' : total,
        'dateTime':timeStamp.toIso8601String(),
        'products':cartProduct.map((cp) => {
          'id' : cp.id,
          'title':cp.title,
          'quntity':cp.quntity,
          'price':cp.price,
        }).toList(),
      }));
      _orders.insert(0, OrderItem(
          id: json.decode(res.body)['name'],
          amount: total,
          products: cartProduct,
          dateTime: timeStamp
      ));
      notifyListeners();
    }catch(e){
      throw e;
    }
  }

}