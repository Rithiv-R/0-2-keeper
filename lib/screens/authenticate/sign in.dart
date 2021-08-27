import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxykeeper/services/auths.dart';

class SignIn extends StatefulWidget {
  final Function toogleView;

  SignIn({required this.toogleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
          "Sign-In",
          style: GoogleFonts.rakkas(color: Color(0xff35C8F6)),
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
                'Sign-Up',
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
                            'https://image.freepik.com/free-vector/access-control-system-abstract-concept_335657-3180.jpg'),
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
                  validator: (val) =>
                      val!.length < 5 ? 'Enter a password count of 5+' : null,
                  obscureText: true,
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
                  child: Text('SIGN IN'),
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      dynamic result =
                          await _auth.signinEmailandPassword(email, password);
                      if (result == null) {
                        setState(() {
                          msg = "Check email couldn't SIGN IN";
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
