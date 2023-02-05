import 'package:WeServeU/model/order_model.dart';
import 'package:WeServeU/providers/user_provider.dart';
import 'package:WeServeU/screen/order_detail_screen_client.dart';
import 'package:WeServeU/screen/shop_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/user_model.dart';
import '../providers/client_orders_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/product_provider.dart';
import '../widget/widgets.dart';

class ClientOrders extends StatefulWidget {
  const ClientOrders({Key? key}) : super(key: key);
  static const String rootname = '/myorders';
  @override
  State<ClientOrders> createState() => _ClientOrdersState();
}

class _ClientOrdersState extends State<ClientOrders> {
  String currentSort = 'Time';
  String currentValue = 'Type';
  String orderStatus = 'Pending';
  bool sort = false;
  @override
  Widget build(BuildContext context) {
    var local=AppLocalizations.of(context);
    return Scaffold(
        body: SafeArea(
      child: Consumer<ClientOrdersProvider>(
          key: Key(currentValue),
          builder: (ctx, provider, c) {
            print(provider.ordersList.length);
            return provider.loading
                ? const ListLoadingShimmer()
                : Column(
                    children: [
                      SizedBox(height: 16,),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  orderStatus='Pending';
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.pending_actions,color: orderStatus=='Pending' ? Colors.green : Colors.black),
                                        SizedBox(width: 8,),
                                        Text(local.pending,style: TextStyle(fontSize: 16,color: orderStatus=='Pending' ? Colors.green : Colors.black),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  orderStatus='Delivered';
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.local_shipping,color: orderStatus=='Delivered' ? Colors.green : Colors.black,),
                                        SizedBox(width: 4,),
                                        Text(local.delivered,style: TextStyle(color: orderStatus=='Delivered' ? Colors.green : Colors.black),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  sort=!sort;
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
                                      mainAxisAlignment: MainAxisAlignment.center,
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
                      SizedBox(height: 16,),
                      if(sort)Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          height: 270,
                          decoration: BoxDecoration(
                            color: Color(0xffd4e8ff),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(local.sortBy,style: TextStyle(fontSize: 20),),
                              ),
                              Row(
                                children: [
                                  Checkbox(value: currentSort=='A-Z' , onChanged: (value){
                                    if(value==true){
                                      setState(() {
                                        currentSort='A-Z';
                                        sort=!sort;
                                      });
                                    }
                                  }),
                                  Text(local.sortByShop,style: TextStyle(fontSize: 16),),
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(value: currentSort=='Location' , onChanged: (value){
                                    if(value==true){
                                      setState(() {
                                        currentSort='Location';
                                        sort=!sort;
                                      });
                                    }
                                  }),
                                  Text('${local.sortBy} ${local.areaStreet}',style: TextStyle(fontSize: 16),),
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(value: currentSort=='Time' , onChanged: (value){
                                    if(value==true){
                                      setState(() {
                                        currentSort='Time';
                                        sort=!sort;
                                      });
                                    }
                                  }),
                                  Text(local.sortByTime,style: TextStyle(fontSize: 16),),
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(value: currentSort=='Rating' , onChanged: (value){
                                    if(value==true){
                                      setState(() {
                                        currentSort='Rating';
                                        sort=!sort;
                                      });
                                    }
                                  }),
                                  Text('${local.sortByRating}',style: TextStyle(fontSize: 16),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: FutureBuilder(builder: (context,AsyncSnapshot<List<OrderModel>> snapshot) {
                          if(snapshot.hasData) {
                            print(snapshot.data);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.separated(
                                key: Key(orderStatus),
                                  itemBuilder: (ctx, index) {
                                  return OrderCard(
                                            orderModel: snapshot.data![index]);
                                  },
                                  separatorBuilder: (ctx, index) {
                                    return const Divider();
                                  },
                                  itemCount: snapshot.data!.length),
                            );
                          }else{
                            return const ListLoadingShimmer();
                          }
                        },future: sortList(provider.ordersList,currentSort),),
                      ),
                    ],
                  );
          }),
    ));
  }

  Future<List<OrderModel>> sortList(List<OrderModel> ordersList, String currentSort) async{
    List<OrderModel> modelList=[];
    List<OrderModel> removeList=[];
    List<DateTime> dateList=[];
    for (int i = 0; i < ordersList.length; i++) {
      if(!dateList.contains(ordersList[i].date)){
        ordersList[i].orderId=(i+1).toString();
        modelList.add(ordersList[i]);
      }
      dateList.add(ordersList[i].date!);
    }

    if(currentSort == 'A-Z'){
      for(OrderModel model in modelList) {
        await Provider.of<UserProvider>(context,listen: false).getName(model.sellerUID!).then((value){
          model.productName=(value.value ?? 'Deleted').toString();
        });
      }
      modelList.sort((a, b) => (a.productName ?? '').compareTo(b.productName ?? ''));
    }else if(currentSort == 'Location'){
      for(OrderModel model in modelList) {
        await Provider.of<UserProvider>(context,listen: false).getArea(model.sellerUID!).then((value){
          model.productName=value;
        });
      }
      modelList.sort((a, b) => a.productName!.compareTo(b.productName!));
    }else if(currentSort=='Time'){
      modelList.sort((a, b) => b.date!.compareTo(a.date!));
    }else{
      for(OrderModel model in modelList) {
        await Provider.of<UserProvider>(context,listen: false).getRating(model.sellerUID!).then((value){
          model.productName=value.toString();
        });
      }
      modelList.sort((a, b) => double.parse(a.productName!).compareTo(double.parse(b.productName!)));
    }
    if(orderStatus=='Pending'){
      for(OrderModel model in modelList){
        if(model.shippingStatus=='Delivered'){
          removeList.add(model);
        }
      }
    }else{
      for(OrderModel model in modelList){
        if(model.shippingStatus!='Delivered'){
          removeList.add(model);
        }
      }
    }
    for(OrderModel model in removeList ){
      modelList.remove(model);
    }
    return modelList;
  }
}
class OrderCard extends StatelessWidget {
  const OrderCard({Key? key,required this.orderModel}) : super(key: key);
  final OrderModel orderModel;
  @override
  Widget build(BuildContext context) {
    print(orderModel.date!.toIso8601String());
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
                      FutureText(label: '${local.shopName} :-',
                          future: value.getName(orderModel.sellerUID!)),
                      SizedBox(height: 8,),
                      FutureBuilder(
                        builder: (context,
                            AsyncSnapshot<String>
                            snapshot) {
                          if (!snapshot.hasData)
                            return SizedBox();
                          return Text(
                            '${local.shopAddress} :- ${snapshot.data}',
                            style: TextStyle(
                                fontSize: 14),
                          );
                        },
                        future: getAdress(orderModel.sellerUID!,context),
                      ),
                    ],
                  ),
                ),
                value.userModel?.photoUrl==null ? Image.asset('client.png',height: 70,width: 70,) : Image.network((value.userModel?.photoUrl)!,height: 70,width: 70,),
              ],
            ),
            SizedBox(height: 8,),
            Container(height: 2,width: double.infinity,color: Colors.black,),
            SizedBox(height: 8,),
            Text('${local.orderTime} :- ${DateFormat('H:m dd-MMMM-yyyy',).format(orderModel.date!)}'),
            SizedBox(height: 8,),
            Text('${local.orderStatus} :- ${orderModel.shippingStatus=='Pending' ? local.pending : (orderModel.shippingStatus=='Accepted' ? local.accepted :(orderModel.shippingStatus=='Rejected') ?local.rejected : local.delivered)}'),
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
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopScreen(uid: orderModel.sellerUID!,)));
                    },
                    child: Container(width:double.infinity,height: 50,decoration: BoxDecoration(
                      color: Colors.blue.shade400,),
                        child: Center(child: Text('${local.orderAgain}',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),))),
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetailScreenClient(orderModel: orderModel,)));
                    },
                    child: Container(width:double.infinity,height: 50,decoration: BoxDecoration(
                      color: Colors.blue.shade400,),
                        child: Center(child: Text('${local.orderDetail}',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),))),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16,),
            if(orderModel.shippingStatus == 'Delivered' && orderModel.rating==0)Text(local.rateOrders),
            if(orderModel.shippingStatus == 'Delivered' && orderModel.rating==0)SizedBox(height: 16,),
            if (orderModel.shippingStatus == 'Delivered' && orderModel.rating==0)
              Card(
                child: RatingBar(
                  initialRating: orderModel.rating?.toDouble() ?? 0,
                  direction: Axis.horizontal,
                  itemSize: 45,
                  allowHalfRating: false,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: Image.asset('assets/yellowheart.png'),
                    empty: Image.asset('assets/whiteheart.png'),
                    half: SizedBox(),
                    // half: _image('assets/heart_half.png'),
                    // empty: _image('assets/heart_border.png'),
                  ),
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  onRatingUpdate: (rating) {
                    orderModel.rating = rating.toInt();
                    Provider.of<OrdersProvider>(context, listen: false)
                        .update(orderModel);
                  },
                ),
              )
          ],
        ),
      );
    });

  }
  Future<String> getAdress(String uid,BuildContext context) async {
    return FirebaseDatabase.instance.ref('users').child(uid).once().then((value) async{
      UserModel userModel = UserModel.formMap(value.snapshot.value as Map);
      print(userModel.latitude);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          userModel.latitude ?? 0, userModel.longitude ?? 0);
      return '${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality as String} ';
    });
  }
}
