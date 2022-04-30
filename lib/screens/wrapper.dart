import 'dart:ffi';

import 'package:firebasetest/screens/product_overview_screen.dart';

import '../Authenticate/authentication.dart';
import '../screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isToggle = false;
  void toggleScreen(){
    setState(() {
      isToggle = ! isToggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user != null){
      return ProductOverviewScreen();
    }else{
      return LogIn();
    }
  }
}
