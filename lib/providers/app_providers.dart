import 'package:WeServeU/providers/address_provider.dart';
import 'package:WeServeU/providers/cart_provider.dart';
import 'package:WeServeU/providers/client_orders_provider.dart';
import 'package:WeServeU/providers/notifications_provider.dart';
import 'package:WeServeU/providers/payment_provider.dart';
import 'package:WeServeU/providers/product_provider.dart';
import 'package:WeServeU/providers/running_status_provider.dart';
import 'package:WeServeU/providers/user_provider.dart';
import 'package:WeServeU/providers/wallet_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'auth_provider.dart';
import 'notification_provider_client.dart';
import 'orders_provider.dart';

List<SingleChildWidget> getProviders() {
  return [
    ChangeNotifierProvider(
      create: (ctx) => AuthProvider(ctx),
    ),
    ChangeNotifierProvider(
      create: (ctx) => UserProvider(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => ProductProvider(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => CartProvider(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => OrdersProvider(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => PaymentProvider(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => AddressProvider(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => NotificationsProvider(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => WalletProvider(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => RunningStatusProvider(),
    ),
  ChangeNotifierProvider(
  create: (ctx) => ClientOrdersProvider()),
    ChangeNotifierProvider(create:
        (ctx) => NotificationsProviderClient(),),

  ];
}
