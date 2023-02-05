import 'package:WeServeU/screen/my_orders.dart';
import 'package:WeServeU/screen/my_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../components/appbar.dart';
import '../model/user_model.dart';
import '../providers/user_provider.dart';
import '../screen/auth_screen.dart';

class ProviderDashBoard extends StatefulWidget {
  const ProviderDashBoard({Key? key}) : super(key: key);
  @override
  State<ProviderDashBoard> createState() => _ProviderDashBoardState();
}

class _ProviderDashBoardState extends State<ProviderDashBoard> {
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
    final List<Widget> widgets = [
      MyOrders(),
      const MyProductsScreen()
    ];
    return DefaultTabController(
      length: widgets.length,
      child: Scaffold(
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
        key: _scaffoldKey,
        // appBar: AppBar(
        //   title: const SetLocationWidget(),
        //   actions: [
        //     TextButton(onPressed: (){
        //       Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
        //         return const NotificationsScreen();
        //       }));
        //     }, child: const Text('Orders',style: TextStyle(color: Colors.white),))
        //   ],
        // ),
        body: SafeArea(child: TabBarView(children: widgets)),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              text: local.myOrders,
              icon: Icon(Icons.category_outlined),
            ),

            Tab(
              text: local.myProducts,
              icon: Icon(Icons.library_books),
            ),
          ],
        ),
      ),
    );
  }


}


InternetStatus internetStatus = InternetStatus.online;
