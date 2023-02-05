import 'dart:convert';

import 'package:WeServeU/model/order_model.dart';
import 'package:WeServeU/providers/orders_provider.dart';
import 'package:WeServeU/providers/user_provider.dart';
import 'package:WeServeU/widget/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../data/constants.dart';
import '../model/product_model.dart';
import '../model/user_model.dart';
import '../model/wallet_model.dart';
import '../providers/product_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
class OrderDetailScreenProvider extends StatefulWidget {
  OrderDetailScreenProvider({Key? key, required this.orderModel,required this.navigationType}) : super(key: key);
  final OrderModel orderModel;
  final String navigationType;
  @override
  State<OrderDetailScreenProvider> createState() => _OrderDetailScreenProviderState(orderModel,navigationType);
}

class _OrderDetailScreenProviderState extends State<OrderDetailScreenProvider> {
  final OrderModel orderModel;
  final String navigationType;
  _OrderDetailScreenProviderState(this.orderModel,this.navigationType);
  String key='';
  double subtotal=0;
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UserProvider>(context, listen: false);
    final orders = Provider.of<OrdersProvider>(context, listen: false);
    var local=AppLocalizations.of(context);
    String value=orderModel.shippingStatus!;
    String paymentStatus=orderModel.paymentStatus ?? 'Pending';
    print(paymentStatus);
    var timeController=new TextEditingController();
    print(orderModel.orderId);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.orderDetail),
        backgroundColor: Color(0xff5e7af3),
      ),
      body: SingleChildScrollView(
        key: Key(key),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(orderModel.shippingStatus=='Pending')SizedBox(height: 20,),
            if(orderModel.shippingStatus=='Pending')Container(padding:EdgeInsets.only(left: 8),width: double.infinity,child: Text('${local.accept} ${local.orders}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
            if(orderModel.shippingStatus=='Pending')SizedBox(height: 8,),
            if(orderModel.shippingStatus=='Pending') Container(
              decoration: BoxDecoration(color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.only(left: 8,right: 8,top: 16,bottom: 16),
              padding: EdgeInsets.only(left: 16,right: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '${local.expectedDeliveryTime}',
                  border: InputBorder.none,
                ),
                controller: timeController,
              ),
            ),

            if(orderModel.shippingStatus=='Pending')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                        height: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.red.shade400,
                        child: Text(local.reject,style: TextStyle(fontSize: 16,color: Colors.white),),
                        onPressed: (){
                          orderModel.shippingStatus='Rejected';
                          FirebaseDatabase.instance.ref('orders').child(orderModel.key!).set(orderModel.toMap()).then((value){
                            setState(() {
                              orderModel.shippingStatus;
                            });
                          });
                        }),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                        height: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.green.shade400,
                        child: Text(local.accept,style: TextStyle(fontSize: 16,color: Colors.white),),
                        onPressed: (){
                          var dialog = AlertDialog(title: Text(local.confirmOrder),content: Text(local.sureToAccept),actions: [
                            TextButton(onPressed: () {
                              Navigator.pop(context);
                            }, child: Text(local.cancel),),
                            TextButton(onPressed: () async {
                              await FirebaseDatabase.instance.ref('wallets').child(FirebaseAuth.instance.currentUser!.uid).get().then((value) async {
                                 WalletModel walletModel;
                                if(value.value==null){
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(local.notEnoughBalance)));
                                }else {
                                  walletModel = WalletModel.formMap(value.value as Map);
                                  if(orderModel.paymentMethod=='RazorPay' || orderModel.paymentMethod=='WALLET')
                                    walletModel.amount+=subtotal+orderModel.deliveryCharge!;
                                  if(walletModel.amount < orderModel.appEarning!){
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(local.notEnoughBalance)));
                                  }else {
                                    walletModel.amount -= orderModel.appEarning ?? 0;
                                    await FirebaseDatabase.instance.ref('wallets').child(FirebaseAuth.instance.currentUser!.uid).set(walletModel.toMap());
                                    orderModel.shippingStatus='Accepted';
                                    orderModel.deliveryTime=timeController.text;
                                    FirebaseDatabase.instance.ref('orders').child(orderModel.key!).set(orderModel.toMap()).then((value){
                                      FirebaseDatabase.instance.ref('users').orderByChild('shopId').equalTo(FirebaseAuth.instance.currentUser!.uid).once().then((value) async {
                                        List<String> token=[];
                                        for(DataSnapshot snap in value.snapshot.children){
                                          UserModel model = UserModel.formMap(snap.value as Map);
                                          token.add(model.token??'');
                                        }

                                        final postUrl = 'https://fcm.googleapis.com/fcm/send';

                                        final data = {
                                          "registration_ids" : token,
                                          "collapse_key" : "type_a",
                                          "notification" : {
                                            "title": 'Order placed!',
                                            "body" : 'New order is placed',
                                          }
                                        };

                                        final headers = {
                                          'content-type': 'application/json',
                                          'Authorization': 'key=AAAAPrlEjcw:APA91bEGV--lCW4RuO2lM_OCRneq0uIEsMbeVV2BS2PMj6E83P2f2HnqviLAREWsl1j8t6E9ETuvwW-xSJwOYfSpseJ2FekzvxKeE3dWIxlK3sDipU4mRk_pks2cXB6y_ARNDDvi-uQ_' // 'key=YOUR_SERVER_KEY'
                                        };

                                        final response = await http.post(Uri.parse(postUrl),
                                            body: json.encode(data),
                                            encoding: Encoding.getByName('utf-8'),
                                            headers: headers);

                                        if (response.statusCode == 200) {
                                          // on success do sth
                                          print('test ok push CFM');
                                          return true;
                                        } else {
                                          print(' CFM error');
                                          // on failure do sth
                                          return false;
                                        }
                                      });
                                      setState(() {
                                        Navigator.pop(context);
                                        orderModel.shippingStatus;
                                      });
                                    });
                                  }

                                }
                              });
                            }, child: Text(local.confirm),),
                          ],);
                          showDialog(context: context, builder: (BuildContext context) {
                            return dialog;
                          });
                        }),
                  ),
                ),
              ],
            ),
            if(orderModel.shippingStatus=='Pending')Divider(),
            SizedBox(height: 20,),
            Container(padding:EdgeInsets.only(left: 8),width: double.infinity,child: Text(local.clientDetail,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
            SizedBox(height: 8,),
            MyCustomCard(
                elevation: 1.0,
                color: Colors.blue.shade100,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureText(
                        future: users.getName(orderModel.buyerUID!,),style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
                      ),

                      //TODO implement
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(orderModel.addressModel?.toMultiLine(context) ?? '',
                            maxLines: null,style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                      ),

                    ],
                  ),
                )),
            const Divider(),
            Container(padding:EdgeInsets.only(left: 8),width: double.infinity,child: Text(local.orderDetail,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
            SizedBox(height: 8,),
            FutureBuilder(builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
             if(!snapshot.hasData) return SizedBox();
             List<OrderModel> modelList=[];
             subtotal=0;
             for(DataSnapshot snap in snapshot.data!.snapshot.children){
                OrderModel model = OrderModel.fromMap(snap.value as Map);
                modelList.add(model);
                  subtotal+=(model.price??0) * (model.quantity??0);
             }
             return ListView.builder(itemBuilder: (BuildContext context, int index) {
               if(index == modelList.length-1) {
                 return Column(
                   children: [
                     OrderListUnit(orderModel: modelList[index]),
                     Divider(),
                     SizedBox(height: 16,),
                     Container(padding:EdgeInsets.only(left: 8),width: double.infinity,child: Text(local.note,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
                     SizedBox(height: 8,),
                     Container(width: double.infinity,padding: EdgeInsets.all(8),child: Text(modelList[index].note == null ? local.noteNotAdded :  modelList[index].note!.isEmpty ? local.noteNotAdded : modelList[index].note!,textAlign: TextAlign.start,style: TextStyle(fontSize: 16),)),
                     const Divider(),
                     Container(padding:EdgeInsets.only(left: 8),width: double.infinity,child: Text(local.paymentSummary,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
                     SizedBox(height: 16,),
                     Container(
                       key: Key(subtotal.toString()),
                       margin: EdgeInsets.all(8),
                       decoration: BoxDecoration(
                         color: Colors.blue.shade100,
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child: Padding(
                         padding: const EdgeInsets.all(16.0),
                         child: Column(
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(local.subTotal,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                 Text('${subtotal} $currency',style: TextStyle(fontSize: 16),),
                               ],
                             ),
                             SizedBox(height: 16,),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(local.deliveryCharge,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                 Text('${orderModel.deliveryCharge} $currency',style: TextStyle(fontSize: 16,),),
                               ],
                             ),
                             SizedBox(height: 16,),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(local.appCharges,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                 Text('${orderModel.appEarning?.toStringAsFixed(2)} $currency',style: TextStyle(fontSize: 16,),),
                               ],
                             ),
                             SizedBox(height: 16,),
                             Text('---------------------------------------------------'),
                             SizedBox(height: 16,),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(local.total,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                 Text('${(subtotal + orderModel.deliveryCharge! + orderModel.appEarning!).toStringAsFixed(2)} $currency',style: TextStyle(fontSize: 16,),),
                               ],
                             ),
                           ],
                         ),
                       ),
                     ),
                   ],
                 );
               }
               return OrderListUnit(orderModel: modelList[index]);
             },itemCount: modelList.length,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),);
            },future: FirebaseDatabase.instance.ref('orders').orderByChild('date').equalTo(orderModel.date?.toIso8601String()).once(),),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(local.showLocationOnMap,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: MaterialButton(
                    height: 50,
                    color: Colors.blue.shade100,
                    child: Text(local.showLocationOnMap,style: TextStyle(fontSize: 16),),
                    onPressed: () async{
                      String googleUrl = 'google.navigation:q=${orderModel.addressModel!.latitude},${orderModel.addressModel!.longitude}&mode=d';
                      if (await UrlLauncher.canLaunchUrl(Uri.parse(googleUrl))) {
                      await UrlLauncher.launchUrl(Uri.parse(googleUrl));
                      } else {
                      throw 'Could not open the map.';
                      }
                    }),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(local.updateShippingStatus,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            Container(
              margin: EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  borderRadius: BorderRadius.circular(10),
                  items:  [
                    if(value=='Pending')DropdownMenuItem(
                      value: 'Pending',
                      child: Text(local.pending),
                    ),
                    if(value=='Pending' || value=='Accepted')DropdownMenuItem(
                      value: 'Accepted',
                      child: Text(local.accepted),
                    ),
                    if(value=='Pending' || value=='Rejected')DropdownMenuItem(
                      value: 'Rejected',
                      child: Text(local.rejected),
                    ),
                    if(value=='Pending' || value=='Accepted' || value=='Shipped' || value=='Delivered')DropdownMenuItem(
                      value: 'Delivered',
                      child: Text(
                        local.delivered,
                      ),
                    ),
                  ],
                  onChanged: (v) async {
                    if (v == null) {
                      return;
                    }
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text(local.confirm),
                          content: Text(
                              '${local.updateShipping} $v? ${local.onceDone}'),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text(local.no),
                              onPressed: () {
                                Navigator.of(dialogContext)
                                    .pop(); // Dismiss alert dialog
                              },
                            ),
                            ElevatedButton(
                              child: Text(local.yes),
                              onPressed: () {
                                Navigator.of(dialogContext)
                                    .pop(); // Dismiss alert dialog
                                orders.updateShippingStatus(
                                    orderKey: orderModel.key!, status: v,model: orderModel);
                                this.setState(() {
                                  key;
                                  orderModel.shippingStatus=v;
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },value:orderModel.shippingStatus,),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(local.updatePaymentStatus,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            Container(
              margin: EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  borderRadius: BorderRadius.circular(10),
                  items:  [
                    if(paymentStatus=='Pending')DropdownMenuItem(
                      value: 'Pending',
                      child: Text(local.pending),
                    ),
                    if(paymentStatus=='Pending' || paymentStatus=='Paid')DropdownMenuItem(
                      value: 'Paid',
                      child: Text(local.completed),
                    ),
                  ],
                  onChanged: (v) async {
                    if (v == null) {
                      return;
                    }
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text(local.confirm),
                          content: Text(
                              '${local.updatePaymentStatus} $v? ${local.onceDone}'),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text(local.no),
                              onPressed: () {
                                Navigator.of(dialogContext)
                                    .pop(); // Dismiss alert dialog
                              },
                            ),
                            ElevatedButton(
                              child: Text(local.yes),
                              onPressed: () {
                                Navigator.of(dialogContext)
                                    .pop(); // Dismiss alert dialog
                                orders.updatePaymentStatus(
                                    orderKey: orderModel.key!, status: v,model: orderModel);
                                this.setState(() {
                                  key;
                                  orderModel.paymentStatus=v;
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },value:orderModel.paymentStatus,),
              ),
            ),
            if(navigationType!='Driver')const Divider(),
            if(navigationType!='Driver')Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(local.notifyClient,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            if(navigationType!='Driver')Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                        height: 50,
                        color: Colors.blue.shade100,
                        child: Text(local.sendMessage,style: TextStyle(fontSize: 16),),
                        onPressed: (){
                          _sendSMS(local.hellowehavearrivedatyourlocation, ['${orderModel.addressModel?.phone!}']);
                        }),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                        height: 50,
                        color: Colors.green.shade100,
                        child: Text(local.call,style: TextStyle(fontSize: 16),),
                        onPressed: (){
                          UrlLauncher.launch("tel://${orderModel.addressModel?.phone}");
                        }),
                  ),
                ),
              ],
            ),
            const Divider(),
            SizedBox(height: 16,),
          ],
        ),
      ),
    );
  }
  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
    });
  }
}
class OrderListUnit extends StatelessWidget {
  final OrderModel orderModel;

  const OrderListUnit({Key? key, required this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: FutureBuilder(
          future: firebaseDatabase
              .ref(productsReferenceWithCurrency)
              .child(currency)
              .child(orderModel.productKey!)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
            final hasData = snapshot.hasData && snapshot.data != null;

            ProductModel p = !hasData
                ? ProductModel(currency: currency)
                : ProductModel.fromMap(
                snapshot.data?.value as Map<dynamic, dynamic>);

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 8,
                ),
                SizedBox(
                    width: 100,
                    height: 100,
                    child: LoadImage(path: p.photoUrl![0] as String)),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyTitle(text: '${p.name}'),
                          ],
                        ),
                        MySubTitle(
                            text: '${AppLocalizations.of(context).price}:  ${orderModel.price ?? 0.0} $currency'),
                        MySubTitle(
                            text: '${AppLocalizations.of(context).quantity}: ${orderModel.quantity ?? 0.0} '),
                        MySubTitle(
                            text: '${AppLocalizations.of(context).total}: ${((orderModel.quantity?? 0) * (orderModel.price ?? 0)) } $currency'),
                      ],
                    ))
              ],
            );
          },
        ),
      ),
    );
  }
}
