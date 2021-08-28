import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oxykeeper/models/oxymodels.dart';
import 'package:share/share.dart';

class AddressFinder2 extends StatefulWidget {
  String d1;
  AddressFinder2({required this.d1});
  @override
  _AddressFinderState createState() => _AddressFinderState();
}

class _AddressFinderState extends State<AddressFinder2> {
  late String currentAddress;
  List<oxymodel> mode = [];
  void initState() {
    // TODO: implement initState

    currentAddress = widget.d1.toString();
    fetchData();
    super.initState();
  }

  /*void trio() {
    _getAddressFromLatLng(widget.d1.toString());
  }

  _getAddressFromLatLng(String val) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(widget.latitude, widget.longitude);
      Placemark place = placemarks[0];
      setState(() {
        if (val.isEmpty) {
          currentAddress = "${place.locality}";
        } else {
          currentAddress = 'Trichy';
        }
        fetchData();
      });
    } catch (e) {
      print(e);
    }
  }*/

  fetchData() async {
    try {
      FirebaseFirestore.instance
          .collection('${widget.d1}')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            oxymodel ox = oxymodel(
              district: element['district'],
              groupname: element['group_name'],
              name_of_supplier: element['name_of_supplier'],
              phone_number: element['phone_number'],
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
      height: 200,
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
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(phno.toString()),
                Text(district),
              ],
            ),
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
              child: Text('no vendors till date'),
            ),
          )
        : Expanded(
            child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: mode.length,
            itemBuilder: (context, index) => Container(
              child: Card(
                child: Tile(
                  text: mode[index].groupname,
                  name: mode[index].name_of_supplier,
                  phno: mode[index].phone_number,
                  district: mode[index].district,
                ),
              ),
            ),
          ));
  }
}
