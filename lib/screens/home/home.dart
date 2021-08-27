import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_launcher_icons/android.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oxykeeper/drawer/menu.dart';
import 'package:oxykeeper/screens/home/Address1.dart';
import 'package:oxykeeper/screens/home/fetch1.dart';
import 'package:oxykeeper/services/auths.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double latitude;
  late double longitude;
  late String currentAddress = "";
  var object = [];
  late CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(36.67, -87.78), zoom: 14.4746);
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  Marker position1 = Marker(
    markerId: const MarkerId('user_location'),
    infoWindow: const InfoWindow(title: 'Your Location'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    position: LatLng(36.67, -87.78),
  );
  late GoogleMapController _googleMapController;
  var district;
  final TextEditingController t1 = new TextEditingController();
  String d1 = "";
  bool text = false;
  @override
  void initState() {
    // TODO: implement initState
    dual();
    super.initState();
  }

  void dual() {
    userlocation();
  }

  fetchData() async {
    http.Response response = await http.get(Uri.parse(
        'http://api.positionstack.com/v1/reverse?access_key=53088cf255c683168ac033eb263749a3&query=$latitude,$longitude'));
    Map temp = json.decode(response.body);
    setState(() {
      currentAddress = temp['data'][0]['county'];
    });
  }

  void userlocation() async {
    var location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    var _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      latitude = _locationData.latitude;
      longitude = _locationData.longitude;
      _kGooglePlex =
          CameraPosition(target: LatLng(latitude, longitude), zoom: 14.4746);
      fetchData();
    });
  }

  final AuthService _auth = AuthService();

  void addMarker(LatLng pos) {
    setState(() {
      position1 = Marker(
        markerId: const MarkerId('user_location'),
        infoWindow: const InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos,
      );
    });
  }

  void onmapcreated(GoogleMapController controller) {
    addMarker(LatLng(latitude, longitude));
    _controllerGoogleMap.complete(controller);
    _googleMapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        actions: [
          FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              label: Text(
                'logout',
                style: TextStyle(
                  color: Color(0xff35C8F6),
                ),
              ))
        ],
      ),
      drawer: MenuBar(),
      body: (currentAddress.isEmpty)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 200,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(hintText: "Enter the District:"),
                          controller: t1,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Color(0xff35C8F6),
                          ),
                          onPressed: () {
                            setState(() {
                              d1 = t1.text;
                            });
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Color(0xff35C8F6),
                          ),
                          onPressed: () {
                            setState(() {
                              d1 = '';
                              t1.text = '';
                            });
                          })
                    ],
                  ),
                ),
                (_kGooglePlex != null)
                    ? Container(
                        height: 450,
                        child: Stack(
                          children: [
                            GoogleMap(
                              markers: {if (position1 != null) position1},
                              zoomGesturesEnabled: true,
                              initialCameraPosition: _kGooglePlex,
                              mapType: MapType.normal,
                              myLocationButtonEnabled: true,
                              onMapCreated: onmapcreated,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: 450,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                if (position1 != null)
                  TextButton(
                      onPressed: () => _googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                              target: position1.position,
                              zoom: 17.5,
                              tilt: 50.0,
                            )),
                          ),
                      child: Text(
                        'YOUR CURRENT LOCATION IS ${currentAddress.toUpperCase()}',
                        style: GoogleFonts.rakkas(color: Colors.green),
                      )),
                (d1.isNotEmpty)
                    ? AddressFinder(
                        latitude: latitude,
                        longitude: longitude,
                        d1: d1,
                      )
                    : AddressFinder3(
                        currentAddress: currentAddress,
                      ),
              ],
            ),
    );
  }
}
