import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:oxykeeper/models/oxymodels.dart';
import 'package:share/share.dart';

class AddressFinder extends StatefulWidget {
  var latitude;
  var longitude;
  String d1;
  AddressFinder(
      {@required this.latitude, @required this.longitude, required this.d1});
  @override
  _AddressFinderState createState() => _AddressFinderState();
}

class _AddressFinderState extends State<AddressFinder> {
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
    http.Response response =
        await http.get(Uri.parse('https://oxypro.herokuapp.com/oxyfind/'));
    setState(() {
      List temp = json.decode(response.body);
      temp.forEach((element) {
        if (element['district'] == currentAddress) {
          oxymodel ox = oxymodel(
            district: element['district'],
            groupname: element['groupname'],
            name_of_supplier: element['name_of_supplier'],
            phone_number: element['phone_number'],
          );
          mode.add(ox);
        }
      });
    });
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
