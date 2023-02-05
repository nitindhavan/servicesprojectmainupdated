import 'package:WeServeU/components/appbar.dart';
import 'package:WeServeU/providers/user_provider.dart';
import 'package:WeServeU/screen/all_products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../screen/auth_screen.dart';
import '../screen/client_orders.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClientDashBoard extends StatefulWidget {
  const ClientDashBoard({Key? key}) : super(key: key);

  @override
  State<ClientDashBoard> createState() => _ClientDashBoardState();
}

class _ClientDashBoardState extends State<ClientDashBoard> {
  @override
  void initState() {
    super.initState();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var local=AppLocalizations.of(context);
    final List<Widget> widgets = [
      AllProductsScreen(scaffoldKey: _scaffoldKey),
      const ClientOrders()
    ];
    UserModel? model = Provider.of<UserProvider>(context,listen: false).userModel;
    return DefaultTabController(
      length: widgets.length,
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(child: TabBarView(children: widgets,)),
        appBar: AppBar(
          elevation: 0,
          leading: model?.photoUrl == null ? GestureDetector(
            onTap: (){
              MyAppBar.show(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(borderRadius: BorderRadius.circular(30),child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('customer.png'),
              )),
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
        bottomNavigationBar:  TabBar(
          tabs: [
            Tab(
              text: local.allProducts,
              icon: Icon(Icons.category_outlined),
            ),
            Tab(
              text: local.orders,
              icon: Icon(Icons.local_shipping_outlined),
            ),
          ],
        ),
      ),
    );
  }
}

InternetStatus internetStatus = InternetStatus.online;
