import 'package:WeServeU/model/order_model.dart';
import 'package:WeServeU/providers/user_provider.dart';
import 'package:WeServeU/screen/order_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widget/widgets.dart';

class OrdersDriver extends StatefulWidget {
  const OrdersDriver({Key? key}) : super(key: key);
  static const String rootname = '/OrdersDriver';
  @override
  State<OrdersDriver> createState() => _OrdersDriverState();
}

class _OrdersDriverState extends State<OrdersDriver> {
  String currentSort = 'Time';
  String currentValue = 'Type';
  String orderStatus = 'Accepted';
  String productType='gas';
  bool sort = false;
  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context);
    var userProvider=Provider.of<UserProvider>(context,listen: false);
    return Scaffold(
        body: SafeArea(
          child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: orderStatus=='Accepted' ? 3 : 1,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                orderStatus = 'Accepted';
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Color(0xffd4e8ff),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check,color: orderStatus=='Accepted' ? Colors.green : Colors.black),
                                      SizedBox(width: 8,),
                                      if(orderStatus=='Accepted')Text(
                                        local.accepted,
                                        style: TextStyle(
                                            color: orderStatus == 'Accepted'
                                                ? Colors.green
                                                : Colors.black),
                                      ),


                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: orderStatus=='Delivered' ? 3 : 1 ,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                orderStatus = 'Delivered';
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Color(0xffd4e8ff),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.local_shipping,color: orderStatus=='Delivered' ? Colors.green : Colors.black),
                                      SizedBox(width: 8,),
                                      if(orderStatus=='Delivered')Text(
                                        local.completed,
                                        style: TextStyle(
                                            color: orderStatus == 'Delivered'
                                                ? Colors.green
                                                : Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                sort = !sort;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Color(0xffd4e8ff),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.sort),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    if (sort)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xffd4e8ff),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  local.sortBy,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      value: currentSort == 'Time',
                                      onChanged: (value) {
                                        if (value == true) {
                                          setState(() {
                                            currentSort = 'Time';
                                            sort = !sort;
                                          });
                                        }
                                      }),
                                  Text(
                                    '${local.sortBy} ${local.orderno}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      value: currentSort == 'Location',
                                      onChanged: (value) {
                                        if (value == true) {
                                          setState(() {
                                            currentSort = 'Location';
                                            sort = !sort;
                                          });
                                        }
                                      }),
                                  Text(
                                    '${local.sortBy} ${local.areaStreet}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Checkbox(
                              //         value: currentSort == 'Type',
                              //         onChanged: (value) {
                              //           if (value == true) {
                              //             setState(() {
                              //               currentSort = 'Type';
                              //               sort = !sort;
                              //             });
                              //           }
                              //         }),
                              //     Row(
                              //       children: [
                              //         Text('${local.sortByProductType}',style: TextStyle(fontSize: 16),),
                              //         SizedBox(width: 8,),
                              //         DropdownButton(
                              //             value: productType,
                              //             borderRadius: BorderRadius.zero,
                              //             items: productTypeList
                              //                 .map((e) => DropdownMenuItem(
                              //                       value: e,
                              //                       child: Text(e=='gas'?  local.gas :(e=='water' ? local.water : local.other)),
                              //                     ))
                              //                 .toList(),
                              //             onChanged: (v) {
                              //               this.setState(() {
                              //                 productType = v as String;
                              //               });
                              //             }),
                              //       ],
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    Expanded(
                      flex: 10,
                      child: FutureBuilder(
                        builder: (context,
                            AsyncSnapshot<DatabaseEvent> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: Center(child: CircularProgressIndicator()));
                          }
                          List<OrderModel> orderList=[];
                          List<DateTime> dateList=[];
                          if (snapshot.hasData) {
                            for(DataSnapshot snap in snapshot.data!.snapshot.children){
                              OrderModel model=OrderModel.fromMap(snap.value as Map);
                                if(!dateList.contains(model.date)){
                                  model.orderId=(orderList.length + 1).toString();
                                  orderList.add(model);
                                }
                                dateList.add(model.date!);
                              }
                            List<OrderModel> removeList=[];
                            orderList.forEach((model){
                              if (orderStatus == 'Accepted') {
                                if(model.shippingStatus!='Accepted'){
                                  removeList.add(model);
                                }
                              }else if(orderStatus=='Delivered'){
                                if(model.shippingStatus!='Delivered'){
                                  removeList.add(model);
                                }
                              }
                            });
                            for (var element in removeList) {
                              orderList.remove(element);
                            }
                            if(currentSort=='Time')orderList=orderList.reversed.toList();
                            if(currentSort!= 'Time'){
                              orderList.sort((a,b)=> (a.addressModel?.area?.compareTo((b.addressModel)!.area!))!);
                            }
                            if(orderList.isEmpty){
                              return Center(child: Text(local.noOrdersFound));
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.separated(
                                  itemBuilder: (ctx, index) {
                                    return OrderCard(
                                        orderModel:
                                        orderList[index]);
                                  },
                                  separatorBuilder: (ctx, index) {
                                    return Divider();
                                  },
                                  itemCount: orderList.length),
                            );
                          } else {
                            return Center(child: Text(local.noOrdersFound));
                          }
                        },
                        future: FirebaseDatabase.instance.ref('orders').orderByChild('sellerUID').equalTo(userProvider.userModel?.shopId ?? 'no').once(),
                      ),
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: Card(
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(16),
          height: 80,
          child: Column(
            children: [
              Icon(Icons.local_shipping,color: Colors.indigo,),
              SizedBox(height: 8,),
              Text('Orders'),
            ],
          ),
        ),
      )
    );
  }
}
class OrderCard extends StatelessWidget {
  const OrderCard({Key? key,required this.orderModel}) : super(key: key);
  final OrderModel orderModel;
  @override
  Widget build(BuildContext context) {
    print(orderModel.key);
    var local=AppLocalizations.of(context);
    return Consumer<UserProvider>(builder: (BuildContext context, value, Widget? child) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8,),
                      Text('${local.orderno} :- ${orderModel.orderId}',),
                      SizedBox(height: 8,),
                      FutureText(label: '${local.name} :-',
                          future: value.getName(orderModel.buyerUID!)),
                      SizedBox(height: 8,),
                      Text('${local.address} :- ${orderModel.addressModel!.toMultiLine(context)}')
                    ],
                  ),
                ),
                value.userModel?.photoUrl==null ? Image.asset('customer.png',height: 70,width: 70,) : Image.network((value.userModel?.photoUrl)!,height: 70,width: 70,),
              ],
            ),
            SizedBox(height: 8,),
            Container(height: 2,width: double.infinity,color: Colors.black,),
            SizedBox(height: 8,),
            Text('${local.orderTime} :- ${DateFormat('H:m dd-MMMM-yyyy').format(orderModel.date!)}'),
            SizedBox(height: 8,),
            Text('${local.orderStatus} :- ${orderModel.shippingStatus=='Pending' ? local.pending : (orderModel.shippingStatus=='Accepted' ? local.accepted : local.delivered)}'),
            SizedBox(height: 8,),
            Text('${local.paymentStatus} :- ${orderModel.paymentStatus=='Pending' ? local.pending : local.completed}'),
            SizedBox(height: 8,),
            Text('${local.paymentMethod} :- ${orderModel.paymentMethod=='COD' ? local.cashOnDelivery : local.wallet}'),
            SizedBox(height: 8,),
            Text('${local.deliveryTime} :- ${orderModel.deliveryTime?? local.deliveryTimeNotSet}'),
            SizedBox(height: 8,),
            Row(
              children: [
                Text('${local.rating} :- ${orderModel.rating == 0 ? local.notRatedYet : ''}'),
                SizedBox(width: 8,),
                if(orderModel.rating! > 0)Image.asset('yellowheart.png',height: 20,width: 20,),
                if(orderModel.rating! >1)Image.asset('yellowheart.png',height: 20,width: 20,),
                if(orderModel.rating! >2)Image.asset('yellowheart.png',height: 20,width: 20,),
                if(orderModel.rating!> 3)Image.asset('yellowheart.png',height: 20,width: 20,),
                if(orderModel.rating! > 4)Image.asset('yellowheart.png',height: 20,width: 20,),
              ],
            ),
            SizedBox(height: 16,),
            Container(height: 2,width: double.infinity,color: Colors.black,),
            SizedBox(height: 16,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetailScreenProvider(orderModel: orderModel, navigationType: value.userModel!.notifyAllowed !='Allowed' ? 'Driver' : 'AllowedDriver',)));
              },
              child: Container(width:double.infinity,height: 50,decoration: BoxDecoration(
                color: Colors.blue.shade400,),
                  child: Center(child: Text('${local.orderDetail}',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),))),
            ),
            SizedBox(height: 8,),
          ],
        ),
      );
    });
  }
}
