import 'package:flutter/material.dart';
import 'package:oxykeeper/screens/authenticate/sign%20in.dart';
import 'package:oxykeeper/screens/authenticate/sign%20up.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showsign = true;
  void toogleView() {
    setState(() => showsign = !showsign);
  }

  @override
  Widget build(BuildContext context) {
    if (showsign) {
      return SignIn(toogleView: toogleView);
    } else {
      return SignUp(toogleView: toogleView);
    }
  }
}
