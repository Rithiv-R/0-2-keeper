import 'dart:collection';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oxykeeper/services/auths.dart';

class SignUp extends StatefulWidget {
  final Function toogleView;

  SignUp({required this.toogleView});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String msg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Sign-Up",
          style: TextStyle(color: Color(0xff35C8F6)),
        ),
        backgroundColor: Colors.white,
        actions: [
          FlatButton.icon(
              onPressed: () {
                widget.toogleView();
              },
              icon: Icon(
                Icons.person,
                color: Color(0xff35C8F6),
              ),
              label: Text(
                'Sign-In',
                style: TextStyle(color: Color(0xff35C8F6), fontSize: 12),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          color: Colors.white,
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 450,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://image.freepik.com/free-vector/sign-page-abstract-concept-illustration_335657-2242.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                TextFormField(
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  validator: (val) =>
                      val!.length < 5 ? 'Enter a password count of 5+' : null,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  color: Color(0xff35C8F6),
                  child: Text('Register'),
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      dynamic result =
                          await _auth.signupEmailandPassword(email, password);
                      if (result == null) {
                        setState(() {
                          msg = 'Its is not a valid email';
                        });
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  msg,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
