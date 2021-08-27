import 'package:flutter/material.dart';
import 'package:oxykeeper/models/users.dart';
import 'package:oxykeeper/models/users.dart';
import 'package:oxykeeper/screens/authenticate/authenticate.dart';
import 'package:oxykeeper/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    if (user.uid == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
