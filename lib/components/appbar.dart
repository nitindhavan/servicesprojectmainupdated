import 'package:WeServeU/screen/driver_management.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/product_provider.dart';
import '../providers/user_provider.dart';
import '../screen/adresses_screen.dart';
import '../screen/contact_screen.dart';
import '../screen/get_paid.dart';
import '../screen/invite_screen.dart';
import '../screen/language_screen.dart';
import '../screen/notification_screen.dart';
import '../screen/notification_screen_client.dart';
import '../screen/profile_screen.dart';
import '../screen/shop_type_screen.dart';

import '../screen/summary_screen.dart';
import '../screen/support_screen.dart';
import '../screen/wallet_screen.dart';
import '../widget/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({Key? key}) : super(key: key);
  static void show(BuildContext context){
    var localisation=AppLocalizations.of(context);
    var textStyle =
    TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16);
    showMaterialModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        UserModel user=Provider.of<UserProvider>(context).userModel!;
        return Container(
          height: 600,
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
                      child: user.photoUrl == null
                          ? Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.onSecondary,
                      )
                          : LoadImage(path: user.photoUrl),
                    ),
                    trailing: Text('${user.rewardBalance ?? 0} j',style: TextStyle(color: Colors.green),),
                    title: Text(
                      '${user.name}',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.black),
                    ),
                    subtitle: Text(
                      '${user.role}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    },
                    leading: Icon(
                      Icons.person,
                      color: textStyle.color,
                    ),
                    title: Text(
                      localisation.profile,
                      style: textStyle,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.local_shipping_outlined,
                      color: textStyle.color,
                    ),
                    title: Text(
                      localisation.addresses,
                      style: textStyle,
                    ),
                    onTap: () {
                      if(user.role==client) {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed(
                            AddressListScreen.routeName);
                      }else{
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>AddressListScreen()));
                      }
                    },
                  ),
                  if(user.role=='serviceProvider')const Divider(),
                  if(user.role=='serviceProvider')ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DriverManagement()));
                    },
                    leading: Icon(
                      Icons.person,
                      color: textStyle.color,
                    ),
                    title: Text(
                      localisation.manageDrivers,
                      style: textStyle,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      if(user.role==client){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => NotificationScreenClient()));
                      }else {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => NotificationsScreen()));
                      }
                    },
                    leading: Icon(
                      Icons.notifications,
                      color: textStyle.color,
                    ),
                    title: Text(
                      localisation.notifications,
                      style: textStyle,
                    ),
                  ),
                  Visibility(
                    visible: user.role == serviceProvider,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.local_shipping_outlined,
                            color: textStyle.color,
                          ),
                          title: Text(
                            localisation.shopType,
                            style: textStyle,
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>ShopType()));
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
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
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>WalletScreen()
                      ), );
                    },
                    leading: Icon(
                      Icons.wallet,
                      color: textStyle.color,
                    ),
                    title: Text(
                      localisation.wallet,
                      style: textStyle,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>SupportScreen()
                      ), );
                    },
                    leading: Icon(
                      Icons.support,
                      color: textStyle.color,
                    ),
                    title: Text(
                      localisation.supportUS,
                      style: textStyle,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>InviteScreen()),);
                    },
                    leading: Icon(
                      Icons.person_add,
                      color: textStyle.color,
                    ),
                    title: Text(
                      localisation.invite,
                      style: textStyle,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>ContactScreen()),);
                    },
                    leading: Icon(
                      Icons.support_agent,
                      color: textStyle.color,
                    ),
                    title: Text(
                      localisation.contactUs,
                      style: textStyle,
                    ),
                  ),
                  Visibility(
                    visible: user.role == serviceProvider,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.local_shipping_outlined,
                            color: textStyle.color,
                          ),
                          title: Text(
                            localisation.getPaid,
                            style: textStyle,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).pushNamed(GetPaidScreen.routeName);
                          },
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: user.role == serviceProvider,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.summarize_rounded,
                            color: textStyle.color,
                          ),
                          title: Text(
                            localisation.summary,
                            style: textStyle,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SummaryScreen()));
                          },
                        ),
                      ],
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
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
