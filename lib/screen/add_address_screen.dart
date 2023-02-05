import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

import '../global.dart';
import '../model/address_model.dart';
import '../providers/address_provider.dart';
import 'map.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///String? uid;
//
//   ///unique key of the Address
//   String? key;
//   String? recipientName;
//
//   /// product
//   String? line1;
//   String? line2;
//   String? city;
//   String? countryCode;
//   String? postalCode;
//   String? phone;
//   String? state;
//   String? name;

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);
  static const routeName = '/add-address-screen';

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  Map<String, dynamic> initData = {};
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool initialized=false;

  Timer? timer=null;
  bool once=false;
  @override
  void initState() {
    // TODO: implement initState
    _getUserLocation();
    super.initState();
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    if(!initialized){
      initialized=true;
      Timer? timer=null;

      if (Provider.of<AddressProvider>(context, listen: false).addressModel !=
          null) {
        setState(() {
          initData = (Provider.of<AddressProvider>(context, listen: false)
              .addressModel!
              .toMap());
        });
      }else{
        _getUserLocation();
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var local=AppLocalizations.of(context);
    if(!once) {
      _getUserLocation();
      once=true;
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(local.addNewAddress),
        backgroundColor: Color(
            0xff5e7af3),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textInput(
                        key: 'area', hint: local.areaStreet),
                    textInput(
                        key: 'buildingName', hint: local.buildingname),
                    Row(
                      children: [
                        Expanded(
                          child: textInput(
                              key: 'floorno', hint: local.floorNo),
                        ),
                        Expanded(
                          child: textInput(
                              key: 'apartmentno', hint: local.apartmentNo),
                        ),
                      ],
                    ),
                    Expanded(child: MyMap()),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Icon(Icons.location_pin,color: Colors.red,),
                        Text('${initData['line1']}'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(borderRadius:BorderRadius.circular(15),color: Color(0xffff7e26), ),
                  child: TextButton(
                      onPressed: () async {
                        _form.currentState!.save();
                        if (_form.currentState!.validate()) {
                          {
                            AddressModel model = AddressModel.fromMap(initData);
                            Provider.of<AddressProvider>(context, listen: false)
                                .update(model)
                                .then((value) {
                              if (value == null) {
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(value.toString(),),));
                              }
                            });
                          }
                        }
                      },
                      child:  Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(local.deliverHere,style: TextStyle(color: Colors.white)),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Padding textInput({required String key, required String hint}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        key: Key('${initData[key] ?? ''}'),
        initialValue: '${initData[key] ?? ''}',
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        validator: (v) {
          if (v!.isEmpty) {
            return hint;
          }
          return null;
        },
        onSaved: (v) {
          initData[key] = (v!).trim();
        },
        style: const TextStyle(
            color: Colors.blueGrey, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: hint,
          border: const OutlineInputBorder(),
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Padding numberInput({required String key, required String hint}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        key: Key('${initData[key] ?? ''}'),
        initialValue: '${initData[key] ?? ''}',
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        validator: (v) {
          if (v!.isEmpty) {
            return hint;
          }
          return null;
        },
        onSaved: (v) {
          initData[key] = double.tryParse(v!);
        },
        style: const TextStyle(
            color: Colors.blueGrey, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: hint,
          border: const OutlineInputBorder(),
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _getUserLocation() async{
      timer=Timer.periodic(Duration(seconds: 1), (timer) async {
        List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
        final map = {
          'latitude': latitude,
          'longitude': longitude,
          'phone': FirebaseAuth.instance.currentUser?.phoneNumber,
          'line1': placemarks[0].street,
          'state': placemarks[0].administrativeArea,
          'countryCode': placemarks[0].isoCountryCode,
          'postalCode': placemarks[0].postalCode,
          'city': placemarks[0].locality,
          'line2': placemarks[0].subLocality,
        };
        setState(() {
          initData=map;
        });
      });

  }
  updateUI() => setState(() {});
 }
