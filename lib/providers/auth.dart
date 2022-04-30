import 'dart:async';
import 'dart:convert';
import 'package:firebasetest/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier{
  String _token ;
  String _userId;
  DateTime _expiryDate;
  Timer _authTime;

  bool get isAuth{
    return token != null;
  }
  String get token{
    if(_token !=null ){
      return _token;
    }
    return null;
  }
  String get userId{
    return _userId;
  }

  Future <void> _authinticate(String email , String password, String urlSegment) async{
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDdy-SvLpiqz_MMMwjDFVKJnEqa-4u5MgA';
    try{
      final res = await http.post(url,body: json.encode({
        'email' : email,
        'password':password,
        'returnSecureToken':true,
      }));
      final responseData = json.decode(res.body);
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate= DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      String userData = json.encode({
        'token' : _token,
        'userId': _userId,
        'expiryDate':_expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);

    }catch(e){
      throw e;
    }

  }


  Future <void> signUp(String email , String password) async{
    return _authinticate(email, password, 'signUp');
  }
  Future <void> logIn(String email , String password) async{
    return _authinticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')) return false;

    final Map<String, dynamic> extractData = json.decode(prefs.getString('userData')) as Map<String, dynamic>;

    final expiryDate=DateTime.parse(extractData['expiryDate']);

    
    _token = extractData['token'];
    _userId= extractData['userId'];
    _expiryDate= expiryDate;

    notifyListeners();

    return true;
  }
  Future<void> logOut() async{
    _token = null;
    _userId=null;
    _expiryDate=null;
    if(_authTime != null){
      _authTime.cancel();
      _authTime=null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    print('Loged out');
  }

}