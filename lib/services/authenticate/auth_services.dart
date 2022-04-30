import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthServices with ChangeNotifier{

  bool _isLoading  = false;
  String _errorMessage;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future register (String email , String password) async{
    setLoading(true);
    try{
      UserCredential authResult = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = authResult.user;
      return user;
    }
    on SocketException{
      setLoading(false);
      setMessage("No internet , please try again ");
    }
    catch(e){
      setLoading(false);
      setMessage(e);
    }
    notifyListeners();
  }
  Future logIn (String email , String password) async{
    setLoading(true);
    try{
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User user = authResult.user;
      return user;
    }
    on SocketException{
      setLoading(false);
      setMessage("No internet , please try again ");
    }
    catch(e){
      setLoading(false);
      setMessage(e);
    }
    notifyListeners();

  }
  Stream<User> get user =>  firebaseAuth.authStateChanges().map((event) => event);
  Future logOut () async{
    await firebaseAuth.signOut();
  }
  void setLoading(val){
    _isLoading = val;
    notifyListeners();
  }
  void setMessage(message){
    _errorMessage = message;
    notifyListeners();
  }


}