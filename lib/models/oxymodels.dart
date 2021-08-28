import 'dart:ffi';

class oxymodel {
  String groupname;
  String name_of_supplier;
  var district;
  int phone_number;
  var latitude;
  var longitude;
  oxymodel(
      {required this.groupname,
      required this.name_of_supplier,
      this.district,
      required this.phone_number,
      this.latitude,
      this.longitude});
}
