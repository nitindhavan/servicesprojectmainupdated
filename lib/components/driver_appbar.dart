import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/product_provider.dart';
import '../providers/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screen/language_screen.dart';

class DriverAppBar extends StatefulWidget {
  const DriverAppBar({Key? key}) : super(key: key);
  static void show(BuildContext context){
    var localisation=AppLocalizations.of(context);
    var textStyle =
    TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16);
    showMaterialModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>LanguageScreen()
                      ), );
                    },
                    leading: Icon(
                      Icons.language,
                      color: textStyle.color,
                    ),
                    title: Text(
                      localisation.language,
                      style: textStyle,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      Provider.of<AuthProvider>(context, listen: false).logout();
                      Provider.of<CartProvider>(context, listen: false).logout();
                      Provider.of<OrdersProvider>(context, listen: false).logout();
                      Provider.of<UserProvider>(context, listen: false).logout();
                      Provider.of<ProductProvider>(context, listen: false).logout();

                      Navigator.of(context).pop();
                    },
                    leading: Icon(
                      Icons.logout_outlined,
                      color: textStyle.color,
                    ),
                    title: Text(
                      localisation.logout,
                      style: textStyle,
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  @override
  State<DriverAppBar> createState() => _DriverAppBarState();
}

class _DriverAppBarState extends State<DriverAppBar> {
  @override
  Widget build(BuildContext context) {
    var localisation=AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: IconButton(onPressed: (){
            // scaffoldKey.currentState?.openDrawer();
          }, icon: Icon(Icons.settings)),
        ),
        Expanded(
          flex: 5,
          child: Consumer<UserProvider>(builder: (context,provider,child){
            return Text('${localisation.hello}! ${provider.userModel?.name}',style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold),textAlign: TextAlign.left,);
          }),
        ),
      ],
    );
  }
}
