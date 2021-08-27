import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oxykeeper/models/users.dart';
import 'package:oxykeeper/screens/authenticate/authenticate.dart';
import 'package:oxykeeper/screens/home/home.dart';
import 'package:oxykeeper/screens/wrapper.dart';
import 'package:oxykeeper/services/auths.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users>.value(
      value: AuthService().user,
      initialData: Users.initialData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
