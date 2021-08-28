import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oxykeeper/screens/states/displaydvise.dart';
import 'package:oxykeeper/screens/states/statename.dart';

class StateClass extends StatefulWidget {
  @override
  _StateClassState createState() => _StateClassState();
}

class _StateClassState extends State<StateClass> {
  List<Statename> sname = [];
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() async {
    await FirebaseFirestore.instance
        .collection('States')
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((element) {
              setState(() {
                Statename ox = Statename(
                  name: element['State'],
                  imageid: element['imageurl'],
                );
                sname.add(ox);
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
          itemCount: sname.length,
          itemBuilder: (context, index) => new Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          DistrictClass(sname: sname[index].name)));
                },
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          sname[index].imageid,
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
                        sname[index].name,
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
