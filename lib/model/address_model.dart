import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class AddressModel {
  ///UID OF USER
  String? uid;

  ///unique key of the Address
  String? key;
  String? recipientName;

  /// product
  String? line1;
  String? line2;
  String? city;
  String? countryCode;
  String? postalCode;
  String? phone;
  String? state;
  String? name;
  double? latitude;
  double? longitude;

  String? area;
  String? buildingName;
  String? floorno;
  String? appartmentno;

  AddressModel(
      {required this.uid,
      required this.key,
      required this.countryCode,
      required this.line1,
      required this.postalCode,
      required this.phone,
      required this.state,
      required this.name,
      required this.recipientName,
      required this.city,
      required this.line2,
      required this.latitude,
      required this.longitude,
      required this.area,
      required this.buildingName,
      required this.floorno,
      required this.appartmentno});

  AddressModel.fromMap(Map<dynamic, dynamic> map)
      : uid = map['uid'],
        key = map['key'],
        line1 = map['line1'],
        state = map['state'],
        phone = map['phone'],
        name = map['name'],
        countryCode = map['countryCode'],
        recipientName = map['recipientName'],
        postalCode = map['postalCode'],
        city = map['city'],
        line2 = map['line2'],
  latitude=map['latitude'],
  longitude=map['longitude'],
  area=map['area'],
  buildingName=map['buildingName'],
  floorno=map['floorno'],
  appartmentno=map['apartmentno'];

  Map<String, Object?> toMap() {
    final map = {
      'uid': uid,
      'key': key,
      'line1': line1,
      'phone': phone,
      'state': state,
      'name': name,
      'countryCode': countryCode,
      'recipientName': recipientName,
      'postalCode': postalCode,
      'city': city,
      'line2': line2,
      'latitude': latitude,
      'longitude': longitude,
      'area': area,
      'buildingName': buildingName,
      'floorno':floorno,
      'apartmentno': appartmentno,
    };
    map.removeWhere((key, value) => value==null);
    return map;
  }

  String toMultiLine(BuildContext context){
    var local=AppLocalizations.of(context);
    return [
      '${local.floorNo}:$floorno','${local.apartmentNo}:$appartmentno','${local.buildingname}: $buildingName','${local.areaStreet}:$area'
    ].join(', ');
  }
}
