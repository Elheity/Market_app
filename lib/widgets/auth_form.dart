import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetest/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/auth_screen.dart';
import './orugunal_button.dart';
import '../providers/auth.dart';

class AuthForm extends StatefulWidget {
  final AuthType authType;

  const AuthForm({Key key, @required this.authType}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String  _email = '', _password = '';
  Map<String,String> _authData = {
    'email' : '',
    'password':'',
  };

  void _showErrorDialog(String message) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text('An error Occurred'),
      content: Text(message),
      actions: [
        FlatButton(
            onPressed:  ()=> Navigator.of(ctx).pop(),
            child: Text('Okay!')
        ),
      ],
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          child: Column(
            children: <Widget>[
             /* if (widget.authType == AuthType.register)
                TextFormField(
                    validator: (input) => (input.isEmpty) ? 'Enter Name' : null,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                  onSaved: (input) => _name = input,
                ),*/
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  hintText: 'ex: test@gmail.com',
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: (value) {
                  _authData['email'] = value;
                },
                validator: (value) =>
                value.isEmpty ? 'You must enter a valid email' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter your password',
                  prefixIcon: Icon(Icons.password),
                ),
                obscureText: true,
                onChanged: (value) {
                  _authData['password'] = value;
                },
                validator: (value) => value.length <= 6
                    ? 'Your password must be larger than 6 characters'
                    : null,
              ),
              SizedBox(height: 10),
              if (widget.authType == AuthType.register)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter your comfirm password',
                    prefixIcon: Icon(Icons.password),
                  ),
                  obscureText: true,
                  validator: (value) =>
                  _authData['password'] != value ? 'Your password is not true' : null,
                ),
              SizedBox(height: 20),
              OriginalButton(
                text: widget.authType == AuthType.login ? 'Login' : 'Register',
                color: Colors.black87,
                textColor: Colors.white,
                onPressed: () async {
                    try{
                      if (_formKey.currentState.validate()) {
                        if (widget.authType == AuthType.login) {
                        await Provider.of<Auth>(context ,listen: false).logIn(_authData['email'], _authData['password']);
                        Navigator.of(context).pushReplacementNamed('home');

                        } else {
                        await Provider.of<Auth>(context , listen: false).signUp(_authData['email'], _authData['password']);
                        Navigator.of(context).pushReplacementNamed('home');
                        }
                      }
                     }
                    on HttpException catch(error){
                      var errorMessage ='Authentication Failed';
                      if(error.toString().contains('EMAIL_EXISTS')){
                        errorMessage='This email is already use';
                      }
                      if(error.toString().contains('INVALID_EMAIL')){
                        errorMessage='This email is not a valid ';
                      }
                      if(error.toString().contains('WEAK_PASSWORD')){
                        errorMessage='This password is too weak';
                      }
                      if(error.toString().contains('INVALID_PASSWORD')){
                        errorMessage='This password is not a valid';
                      }
                      if(error.toString().contains('EMAIL_NOT_FOUND')){
                        errorMessage='could not find this email ';
                      }
                      if(error.toString().contains('INVALID')){
                        errorMessage='could not find this email ';
                      }
                      _showErrorDialog(errorMessage);
                    }
                    catch(error){
                      const errorMessage='could not authenticate ,please try later ';
                      _showErrorDialog('$error');
                      throw error;
                    }
                    print(_authData['email']);
                    print(_authData['password']);
                  }
              ),
              SizedBox(height: 6),
              FlatButton(
                onPressed: () {
                  if (widget.authType == AuthType.login) {
                    Navigator.of(context).pushReplacementNamed('register');
                    print(widget.authType);
                  } else {
                    Navigator.of(context).pushReplacementNamed('login');
                  }
                },
                child: Text(
                  widget.authType == AuthType.login
                      ? 'Do not have an account?'
                      : 'Already have an account?',
                  style: TextStyle(fontSize: 18, color: Colors.black87,fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
