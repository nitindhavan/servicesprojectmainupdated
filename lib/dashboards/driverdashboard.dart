import 'package:WeServeU/components/appbar.dart';
import 'package:WeServeU/components/driver_appbar.dart';
import 'package:WeServeU/providers/user_provider.dart';
import 'package:WeServeU/screen/orders_driver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/user_model.dart';
import '../screen/auth_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DriverDashBoard extends StatefulWidget {
  const DriverDashBoard({Key? key}) : super(key: key);

  @override
  State<DriverDashBoard> createState() => _DriverDashBoardState();
}

class _DriverDashBoardState extends State<DriverDashBoard> {
  @override
  void initState() {
    super.initState();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var local=AppLocalizations.of(context);
    UserModel? model = Provider.of<UserProvider>(context,listen: false).userModel;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(child:
      Container(
        child: const OrdersDriver(),
      ),),
      appBar: AppBar(
        elevation: 0,
        leading: model?.photoUrl == null ? GestureDetector(
          child: GestureDetector(
            onTap: (){
              DriverAppBar.show(context);
              },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(borderRadius: BorderRadius.circular(30),child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('stearing.png'),
              )),
            ),
          ),
        ) : GestureDetector(
          onTap: (){
            MyAppBar.show(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(borderRadius: BorderRadius.circular(30),child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Image.network((model?.photoUrl)!),
            )),
          ),
        ),
        title: Text('${local.hello}! ${(model?.name) ?? 'User'}'),
        backgroundColor: Color(0xff5e7af3),
      ),
    );
  }
}

InternetStatus internetStatus = InternetStatus.online;
