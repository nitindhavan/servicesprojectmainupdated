import 'package:WeServeU/global.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddAdressComponent extends StatefulWidget {
  const AddAdressComponent({Key? key}) : super(key: key);
  static const routeName = '/add-address-screen';

  @override
  State<AddAdressComponent> createState() => _AddAdressComponentState();
}

class _AddAdressComponentState extends State<AddAdressComponent> {
  Map<String, dynamic> initData = {};

  final GlobalKey<FormState> _form = GlobalKey<FormState>();


  bool initialized=false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  var cityController=TextEditingController();
  var countryController=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }
  @override
  Widget build(BuildContext context) {
    var localisation=AppLocalizations.of(context);
    cityController.addListener(() {
      city=cityController.text;
    });
    countryController.addListener(() {
      country=countryController.text;
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 150,child: Image.asset(userType=='client' ? 'customer.png' : 'client.png' )),
            SizedBox(height: 50,),
            Text(localisation.whereareYouFrom, style: TextStyle(fontSize: 30),),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: localisation.country,
                        labelText: localisation.country,
                      ),
                      controller: countryController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: localisation.city,
                          labelText: localisation.city,
                      ),controller: cityController,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getLocation() async{
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    cityController.text=placemarks.first.locality!;
    countryController.text=placemarks.first.country!;
    latitude=position.latitude;
    longitude=position.longitude;
  }
}
