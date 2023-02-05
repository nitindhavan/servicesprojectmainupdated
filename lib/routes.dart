import 'package:WeServeU/screen/add_product_screen.dart';
import 'package:WeServeU/screen/adresses_screen.dart';
import 'package:WeServeU/screen/carts.dart';
import 'package:WeServeU/screen/get_paid.dart';
import 'package:WeServeU/screen/my_orders.dart';
import 'package:WeServeU/screen/profile_screen.dart';
import 'package:WeServeU/screen/wallet_screen.dart';
import 'package:flutter/cupertino.dart';

import 'screen/auth_screen.dart';
import 'screen/login_screen.dart';
import 'screen/otp_verify_screen.dart';

Map<String, WidgetBuilder> routes() {
  return {
    Login.routeName: (ctx) => const Login(),
    MyAuth.routeName: (ctx) => const MyAuth(),
    AddProductScreen.routeName: (ctx) => const AddProductScreen(),
    OtpVerifyScreen.routeName: (ctx) => const OtpVerifyScreen(),
    CartsScreen.routeName: (ctx) => const CartsScreen(),
    ProfileScreen.routeName: (ctx) => const ProfileScreen(),
    AddressListScreen.routeName: (ctx) => const AddressListScreen(),
    GetPaidScreen.routeName: (ctx) => const GetPaidScreen(),
    WalletScreen.routeName: (ctx)=>const WalletScreen(),
    MyOrders.rootname:(ctx)=> const MyOrders(),
    // OrderDetailScreen.routeName: (ctx) => const OrderDetailScreen(orderModel: orderModel),

  };
}
