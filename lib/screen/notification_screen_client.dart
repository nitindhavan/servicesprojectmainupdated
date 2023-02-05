import 'package:WeServeU/data/constants.dart';
import 'package:WeServeU/providers/product_provider.dart';
import 'package:WeServeU/providers/user_provider.dart';
import 'package:WeServeU/widget/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:WeServeU/model/order_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'order_detail_screen_client.dart';

class NotificationScreenClient extends StatelessWidget {
  const NotificationScreenClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UserProvider>(context, listen: false);
    final products = Provider.of<ProductProvider>(context, listen: false);
    var local=AppLocalizations.of(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title:Text(local.notifications),backgroundColor: Color(0xff5e7af3),),
      body: FutureBuilder(builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if(snapshot.hasData) {
          List<OrderModel> notifications=[];
          for(DataSnapshot snap in snapshot.data!.snapshot.children){
            OrderModel model=OrderModel.fromMap(snap.value as Map);
            notifications.add(model);
          }
          if(notifications.isEmpty){
            return Center(child: Text(local.noNotifications));
          }
          notifications=notifications.reversed.toList();
          return ListView.separated(
              itemBuilder: (ctx, position) {
                final OrderModel orderModel = notifications[position];
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) {
                          return OrderDetailScreenClient(
                              orderModel: orderModel);
                        }));
                  },
                  leading: const Icon(Icons.shopping_cart_checkout),
                  title: FutureText(
                    future: products.getProductName(orderModel.productKey!),
                    label: '${orderModel.shippingStatus=='Pending' ? local.orderIsPending : orderModel.shippingStatus=='Shipped'? local.orderIsShipped : local.orderIsDelivered}  (${local.quantity}: ${orderModel.quantity} ) ${local.forString} ',
                  ),
                  subtitle: FutureText(
                    future: users.getName(orderModel.sellerUID!),
                    label:
                    '${orderModel.paymentMethod ??
                        'COD'} ( $currency ${orderModel.price} ) ${local.forString} ',
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                );
              },
              separatorBuilder: (ctx, position) {
                return const Divider();
              },
              itemCount: notifications.length);
        }else{
          return Center(child: Text(local.noNotifications));
        }
      },future: FirebaseDatabase.instance.ref().child('notifications').orderByChild('buyerUID').equalTo(users.userModel?.uid!).once()),);
  }
}
