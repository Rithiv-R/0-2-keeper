import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:oxykeeper/models/users.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users _customuser(user) {
    return user.uid != null ? Users(uid: user.uid) : Users(uid: "");
  }

  Stream<Users>? get user {
    return _auth.authStateChanges().map((user) => _customuser(user));
  }

  //sign in anonymous
  Future signinanon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      var user = result.user;
      return _customuser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign up

  Future signupEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;
      return _customuser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signinEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;
      return _customuser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
