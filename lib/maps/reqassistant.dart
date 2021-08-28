import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const double zoom = 16;
const double tilt = 80;
const double bearing = 35;

class MyMap extends StatefulWidget {
  LatLng source;
  LatLng destination;
  String groupname;
  MyMap(
      {required this.source,
      required this.destination,
      required this.groupname});
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Completer<GoogleMapController> mapcontroller = Completer();
  Set<Marker> markerset = Set<Marker>();
  late BitmapDescriptor sicon;
  late BitmapDescriptor dicon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.setmarkericons();
  }

  void setmarkericons() async {
    sicon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.0),
      'assets/spin.png',
    );

    dicon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.0),
      'assets/dpin.png',
    );
  }

  void pinmap() {
    setState(() {
      markerset.add(Marker(
        markerId: MarkerId('src'),
        position: widget.source,
        icon: sicon,
        infoWindow: InfoWindow(title: "Your Location"),
      ));
      markerset.add(Marker(
        markerId: MarkerId('dest'),
        position: widget.destination,
        icon: dicon,
        infoWindow: InfoWindow(title: "${widget.groupname}"),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: zoom,
      tilt: tilt,
      bearing: bearing,
      target: widget.source,
    );
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
        child: GoogleMap(
          myLocationEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: false,
          markers: markerset,
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
            mapcontroller.complete(controller);
            pinmap();
          },
        ),
      ),
    );
  }
}
