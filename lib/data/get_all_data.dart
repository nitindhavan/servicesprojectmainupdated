import 'package:WeServeU/providers/address_provider.dart';
import 'package:WeServeU/providers/client_orders_provider.dart';
import 'package:WeServeU/providers/notifications_provider.dart';
import 'package:WeServeU/providers/wallet_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/notification_provider_client.dart';
import '../providers/orders_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/product_provider.dart';

initAllData(BuildContext context){
  Provider.of<ProductProvider>(context, listen: false).getAllData();
  Provider.of<ProductProvider>(context, listen: false).getMyData();
  Provider.of<CartProvider>(context, listen: false).getMyData();
  Provider.of<OrdersProvider>(context, listen: false).getMyData();
  Provider.of<PaymentProvider>(context, listen: false).init();
  Provider.of<AddressProvider>(context, listen: false).init();
  Provider.of<NotificationsProvider>(context, listen: false).init();
  Provider.of<WalletProvider>(context, listen: false).init();
  Provider.of<ClientOrdersProvider>(context,listen: false).getMyData();
  Provider.of<NotificationsProviderClient>(context, listen: false).init();
}