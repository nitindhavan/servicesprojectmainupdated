import 'package:WeServeU/components/LocalityComponent.dart';
import 'package:WeServeU/components/emailcomponent.dart';
import 'package:WeServeU/components/provider_name_component.dart';
import 'package:WeServeU/components/shoptype.dart';
import 'package:WeServeU/components/usertype.dart';
import 'package:WeServeU/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:WeServeU/global.dart' as globals;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../components/name_component.dart';
import '../dashboards/client_dashboard.dart';
import '../dashboards/driverdashboard.dart';
import '../dashboards/provider_dashboard.dart';
import '../data/get_all_data.dart';
import '../global.dart';
import '../providers/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);
  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  int progress = 0;
  int total=5;
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
      getLocation(Provider.of<UserProvider>(context, listen: false));
    })
        .onError((err) {
      // Error getting token.
    });
    Provider.of<UserProvider>(context, listen: false).init();
    var local=AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Consumer<UserProvider>(builder: (context,provider,child) {
          if (!provider.inited) {
            return  Center(child:  Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color:Color(0xff5e7af3)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Barizah',
                    style: TextStyle(color: Colors.white, fontSize: 40,),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
            );
          }
          if (provider.userModel == null) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                          flex: progress,
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5)),
                            ),
                          )),
                      Expanded(
                        flex: total - progress,
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if(progress < total)Expanded(child: getDataComponent(progress)),
                if(progress == total) Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 200, child: Image.asset(
                        userType == 'client'
                            ? 'customer.png'
                            : 'client.png')),
                    SizedBox(height: 50,),
                    Text(local.addingyoutoourteam,
                      style: TextStyle(fontSize: 20),),
                    SizedBox(height: 50,),
                    CircularProgressIndicator(),
                  ],
                )),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (progress < total) {
                        progress++;
                      }
                      if (progress == total) {
                        addUser();
                      }
                      if (userType == 'client') {
                        total = 4;
                      }if(userType=='driver'){
                        total=2;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15)),
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                local.continueText,
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_right, color: Colors.white,),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
            initAllData(context);
          getLocation(provider);
          if(provider.userModel!.accountStatus=='blocked'){
            return FutureBuilder(builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
              return Center(child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('${snapshot.data}',style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
              ));
            },future: getString(),);
          }
            switch (provider.userModel!.role) {
              case 'client':
                return ClientDashBoard();
              case 'serviceProvider':
                return const ProviderDashBoard();
              case 'driver':
                return const DriverDashBoard();
              default:
            }
            return  Center(child:  Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color:Color(0xff5e7af3)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Barizah',
                    style: TextStyle(color: Colors.white, fontSize: 40,),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
            );
          }
        ),
      ),
    );
  }

  getDataComponent(int progress) {
    List<Widget> serviceProviderList=[UserType(),ProviderNameComponent(),EmailComponent(),ShopTypeComponent(),AddAdressComponent()];
    List<Widget> clientList=[UserType(),NameComponent(),EmailComponent(),AddAdressComponent()];
    List<Widget> driverList=[UserType(),NameComponent()];
    if(globals.userType == 'client') {
      return clientList[progress];
    }else if(globals.userType=='serviceProvider'){
      return serviceProviderList[progress];
    }else{
      return driverList[progress];
    }
  }

  void addUser() {
    UserModel model=new UserModel(dateTime : DateTime.now(),currencyCode:'JOD',name: username,email: email,mobile: FirebaseAuth.instance.currentUser?.phoneNumber!,role: userType,balance: 0,latitude: latitude,longitude: longitude,city:city,country: country,shopStatus: 'closed',shopType: shopType,charge: 1.0,accountStatus: 'unblocked');
    Future.delayed(Duration(seconds: 2)).then((value){
      Provider.of<UserProvider>(context,listen: false).addUser(model.toMap());
    });

  }
  void getLocation(UserProvider provider) async{
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      city = placemarks.first.locality!;
      country = placemarks.first.country!;
      latitude = position.latitude;
      longitude = position.longitude;
      if(provider.userModel!=null) {
        provider.updateLocation(latitude, longitude);
        provider.updateCity(city, country);
        provider.updateToken();
      }
    }catch(e){
      print(e);
    }
  }

  Future<String> getString() async{
    var local=AppLocalizations.of(context);
    String phone='';
    String email='';
    await FirebaseDatabase.instance.ref('data').child('phone').once().then((value){
      phone=value.snapshot.value as String;
    });
    await FirebaseDatabase.instance.ref('data').child('email').once().then((value){
      email=value.snapshot.value as String;
    });
    return '${local.yourAccountIsBlocked} $phone ${local.orEmailAddress} $email ${local.forSupport}';
  }
}


