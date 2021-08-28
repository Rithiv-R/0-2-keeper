import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oxykeeper/maps/reqassistant.dart';
import 'package:oxykeeper/models/oxymodels.dart';
import 'package:oxykeeper/screens/home/home.dart';
import 'package:share/share.dart';

// ignore: must_be_immutable
class AddressFinder3 extends StatefulWidget {
  String currentAddress;
  double latitude;
  double longitude;
  AddressFinder3(
      {required this.currentAddress,
      required this.latitude,
      required this.longitude});
  @override
  _AddressFinderState createState() => _AddressFinderState();
}

class _AddressFinderState extends State<AddressFinder3> {
  late var x;
  List<oxymodel> mode = [];
  void initState() {
    trio();
    x = this.widget.latitude;
    super.initState();
  }

  void trio() {
    fetchData();
  }

  fetchData() async {
    try {
      FirebaseFirestore.instance
          .collection('${widget.currentAddress}')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            oxymodel ox = oxymodel(
              district: element['district'],
              groupname: element['group_name'],
              name_of_supplier: element['name_of_supplier'],
              phone_number: element['phone_number'],
              latitude: element['latitude'],
              longitude: element['longitude'],
            );
            mode.add(ox);
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Widget Tile(
      {@required text, @required name, @required phno, @required district}) {
    return Container(
      height: 150,
      child: Column(
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
            title: Text(phno.toString()),
            subtitle: Text(district),
            trailing: Text(name),
          ),
          Divider(
            height: 2,
            thickness: 2,
          ),
          Container(
            child: IconButton(
                icon: Icon(
                  Icons.share,
                  color: Color(0xff35C8F6),
                ),
                onPressed: () {
                  Share.share(phno.toString() + '-' + '$name-' + '$text');
                }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (mode.length == 0)
        ? Center(
            child: Container(
              child: Text('$x'),
            ),
          )
        : Expanded(
            child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: mode.length,
            itemBuilder: (context, index) => Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    child: Card(
                      child: Tile(
                        text: mode[index].groupname,
                        name: mode[index].name_of_supplier,
                        phno: mode[index].phone_number,
                        district: mode[index].district,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => MyMap(
                          source: LatLng(widget.latitude, widget.longitude),
                          destination: LatLng(
                            mode[index].latitude,
                            mode[index].longitude,
                          ),
                          groupname: mode[index].groupname,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ));
  }
}
