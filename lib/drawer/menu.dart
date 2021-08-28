import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxykeeper/screens/home/home.dart';
import 'package:oxykeeper/screens/states/display.dart';
import 'package:oxykeeper/webview.dart';

class MenuBar extends StatefulWidget {
  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff6FD8F9), Colors.white])),
        child: ListView(
          padding: EdgeInsets.all(25),
          children: <Widget>[
            ProfileTile(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              child: ButtonTile(
                icon: Icons.home,
                text: 'Home',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StateClass()));
              },
              child: ButtonTile(
                icon: Icons.star_outline,
                text: 'StatewiseView',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ButtonTile({@required icon, @required text}) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Text(
            text.toString().toUpperCase(),
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Rakkas'),
          ),
          trailing: Icon(
            icon,
            color: Colors.black,
          ),
        ),
        Divider(
          height: 2,
          thickness: 2,
        ),
      ],
    );
  }

  Widget ProfileTile() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 20)),
          Text('O-2 Keeper',
              style: GoogleFonts.rakkas(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 23)),
          Padding(padding: EdgeInsets.only(top: 20)),
          Divider(
            height: 2,
            thickness: 3,
          )
        ],
      ),
    );
  }
}
