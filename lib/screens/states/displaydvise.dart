import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxykeeper/screens/home/home.dart';
import 'package:oxykeeper/screens/states/districtnames.dart';
import 'package:oxykeeper/screens/states/districtview.dart';

class DistrictClass extends StatefulWidget {
  String sname;
  DistrictClass({required this.sname});
  @override
  _DistrictClassState createState() => _DistrictClassState();
}

class _DistrictClassState extends State<DistrictClass> {
  List<Districtname> districtname = [];
  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  fetchData() async {
    await FirebaseFirestore.instance
        .collection('${widget.sname}')
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((element) {
              setState(() {
                Districtname ox = Districtname(
                  district: element['name'],
                  imageurl: element['imageurl'],
                );
                districtname.add(ox);
              });
            }));
  }

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
      body: Container(
        child: ListView.builder(
          itemCount: districtname.length,
          itemBuilder: (context, index) => new Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Viewer(
                          district: districtname[index].district,
                          imageurl: districtname[index].imageurl)));
                },
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          districtname[index].imageurl,
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
                        districtname[index].district,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Rakkas',
                            fontSize: 40),
                      ),
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Divider(
                height: 3,
                thickness: 2,
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
