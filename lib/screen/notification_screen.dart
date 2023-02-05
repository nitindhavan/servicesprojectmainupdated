import 'package:WeServeU/data/constants.dart';
import 'package:WeServeU/providers/notifications_provider.dart';
import 'package:WeServeU/providers/product_provider.dart';
import 'package:WeServeU/providers/user_provider.dart';
import 'package:WeServeU/widget/widgets.dart';
 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'order_detail_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UserProvider>(context, listen: false);
    final products = Provider.of<ProductProvider>(context, listen: false);
    var local=AppLocalizations.of(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title:Text(local.orders),backgroundColor: Color(0xff5e7af3),),
      body: Consumer<NotificationsProvider>(builder: (context, provider, _) {
        return ListView.separated(
            itemBuilder: (ctx, position) {
              final orderModel = provider.providerNotifications[provider.providerNotifications.length-1-position];
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return OrderDetailScreenProvider(orderModel: orderModel,navigationType: 'serviceProvidern  ',);
                  }));
                },
                leading: const Icon(Icons.shopping_cart_checkout),
                title: FutureText(
                  future: products.getProductName(orderModel.productKey!),
                  label: '${local.orderReceivedqty} ${orderModel.quantity} ) ${local.forString} ',
                ),
                subtitle: FutureText(
                  future: users.getName(orderModel.buyerUID!),
                  label:
                      '${orderModel.paymentMethod??'COD'} ( $currency ${orderModel.price} ) by ',
                ),
                trailing: const Icon(Icons.arrow_forward),
              );
            },
            separatorBuilder: (ctx, position) {
              return const Divider();
            },
            itemCount: provider.providerNotifications.length);
      }),
    );
  }
}
