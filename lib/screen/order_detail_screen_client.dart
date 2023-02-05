import 'package:WeServeU/model/order_model.dart';
import 'package:WeServeU/providers/user_provider.dart';
import 'package:WeServeU/widget/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/constants.dart';
import '../model/product_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class OrderDetailScreenClient extends StatefulWidget {
  OrderDetailScreenClient({Key? key, required this.orderModel}) : super(key: key);
  final OrderModel orderModel;
  @override
  State<OrderDetailScreenClient> createState() => _OrderDetailScreenClientState(orderModel);
}

class _OrderDetailScreenClientState extends State<OrderDetailScreenClient> {
  final OrderModel orderModel;
  _OrderDetailScreenClientState(this.orderModel);
  String key='';
  double subtotal=0;
  num deliveryCharge=0;
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UserProvider>(context, listen: false);
    var local=AppLocalizations.of(context);
    // TODO: implement build
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
            SizedBox(height: 20,),
            Container(padding:EdgeInsets.only(left: 8),width: double.infinity,child: Text(local.shopDetails,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
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
              deliveryCharge=0;
              for(DataSnapshot snap in snapshot.data!.snapshot.children){
                OrderModel model = OrderModel.fromMap(snap.value as Map);
                modelList.add(model);
                subtotal+=(model.price??0) * (model.quantity??0);
                deliveryCharge=model.deliveryCharge?? 0;
              }
              return ListView.builder(itemBuilder: (BuildContext context, int index) {
                if(index == modelList.length-1) {
                  return Column(
                    children: [
                      OrderListUnit(orderModel: modelList[index]),
                      const SizedBox(height: 8,),
                      const Divider(),
                      const SizedBox(height: 16,),
                      Container(padding:const EdgeInsets.only(left: 8),width: double.infinity,child: Text(local.note,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
                      const SizedBox(height: 8,),
                      Container(width: double.infinity,padding: EdgeInsets.all(8),child: Text(modelList[index].note == null ? local.noteNotAdded :  modelList[index].note!.isEmpty ? local.noteNotAdded : modelList[index].note!,textAlign: TextAlign.start,style: TextStyle(fontSize: 16),)),
                      const Divider(),
                      Container(padding:const EdgeInsets.only(left: 8),width: double.infinity,child: Text(local.paymentSummary,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
                      const SizedBox(height: 16,),
                      Container(
                        key: Key(subtotal.toString()),
                        margin: const EdgeInsets.all(8),
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
                                  Text('${deliveryCharge} $currency',style: TextStyle(fontSize: 16,),),
                                ],
                              ),
                              SizedBox(height: 16,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(local.appCharges,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                  Text('${orderModel.appEarning!.toStringAsFixed(2)} $currency',style: TextStyle(fontSize: 16,),),
                                ],
                              ),
                              SizedBox(height: 16,),
                              Text('---------------------------------------------------'),
                              SizedBox(height: 16,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(local.total,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                  Text('${(subtotal + deliveryCharge +orderModel.appEarning!).toStringAsFixed(2)} $currency',style: TextStyle(fontSize: 16,),),
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
            SizedBox(height: 16,),
          ],
        ),
      ),
    );
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
                    child: LoadImage(path: p.photoUrl?[0] as String)),
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
                            text: '${AppLocalizations.of(context).quantity}: ${orderModel.quantity ?? 0.0} $currency'),
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
