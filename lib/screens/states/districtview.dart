import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxykeeper/screens/states/fetcher.dart';

class Viewer extends StatefulWidget {
  String district;
  String imageurl;
  Viewer({required this.district, required this.imageurl});
  _ViewerState createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xff35C8F6)),
        elevation: 0.0,
        title: Text(
          "O2 - Keeper",
          style: GoogleFonts.rakkas(
            color: Color(0xff35C8F6),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.imageurl,
                    height: 240,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  )),
              Container(
                height: 240,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.district,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Rakkas', fontSize: 40),
                ),
              )
            ],
          ),
          AddressFinder2(
            d1: widget.district,
          ),
        ],
      ),
    );
  }
}
