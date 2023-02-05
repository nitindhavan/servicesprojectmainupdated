import 'dart:async';
import 'package:WeServeU/model/order_model.dart';
import 'package:WeServeU/providers/product_provider.dart';
import 'package:WeServeU/providers/user_provider.dart';
import 'package:WeServeU/screen/shop_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/product_model.dart';
import '../model/user_model.dart';
import '../providers/offer_model.dart';


class ShopListScreen extends StatefulWidget {
  const ShopListScreen({Key? key,required this.type,required this.title}) : super(key: key);
  final String type;
  final String title;
  @override
  State<ShopListScreen> createState() => _ShopListScreenState(type : type,title: title);
}

class _ShopListScreenState extends State<ShopListScreen> {
  final String type;
  final String title;
  _ShopListScreenState({required this.type,required this.title});
  List<UserModel> userList=[];
  String currentSort='A-Z';
  bool sort=false;
  var searchController=TextEditingController();
  Timer? searchOnStoppedTyping=null;
  @override
  Widget build(BuildContext context) {
    var local=AppLocalizations.of(context);
    searchController.addListener(() {
      const duration = Duration(milliseconds:1500); // set the duration that you want call search() after that.
      if (searchOnStoppedTyping != null) {
        setState(() => searchOnStoppedTyping?.cancel()); // clear timer
      }
      setState(() => searchOnStoppedTyping = new Timer(duration, () {
        setState(() {
          searchController.text;
        });
      }));
    });
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        sort=!sort;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xffd4e8ff),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.sort),
                              SizedBox(width: 8,),
                              Text(local.sort,style: TextStyle(fontSize: 16),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xffd4e8ff),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.search),
                            SizedBox(width: 8,),
                            Expanded(
                              child: Center(
                                child: TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    hintText: local.search,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                height: 220,
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
                        Text(local.sortbyAz,style: TextStyle(fontSize: 16),),
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
                        Text(local.sortByLocation,style: TextStyle(fontSize: 16),),
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
                        Text(local.sortByRating,style: TextStyle(fontSize: 16),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Container(
              key: Key(currentSort),
              child: FutureBuilder(
                key: Key(searchController.text),
                builder: (context,AsyncSnapshot<List<UserModel>> event){
                if(event.hasData){
                  return ListView.builder(itemBuilder: (context,index){
                    if(index==0){
                      return Column(
                        children: [
                          Container(padding: EdgeInsets.all(16),width: double.infinity,child: Text(local.offersOnlyforyou,style: TextStyle(fontSize: 20),textAlign: TextAlign.start,),),
                          FutureBuilder(builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                            if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
                            List<OfferModel> offerList=[];
                            for(DataSnapshot snap in snapshot.data!.snapshot.children){
                              OfferModel model=OfferModel.fromMap(snap.value as Map);
                              if(model.status=='Active')offerList.add(model);
                            }
                            if(offerList.isEmpty) return Container(height: 170,child: Center(child: Text(local.noOffersForNow),));
                            return CarouselSlider(
                              options: CarouselOptions(height: 170.0),
                              items: offerList.map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      height:200,
                                      child: GestureDetector(onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopScreen(uid: i.shopUID!)));
                                      },child: Image.network(i.imageUrl!)),
                                    );
                                  },
                                );
                              }).toList(),
                            );
                          },future:FirebaseDatabase.instance.ref('offers').once()),
                          SizedBox(height: 20,),
                          Container(padding: EdgeInsets.all(16),width: double.infinity,child: Text(local.shops,style: TextStyle(fontSize: 20),textAlign: TextAlign.start,)),
                          SizedBox(height: 16,),
                         GestureDetector(onTap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopScreen(uid: userList[index].uid!,)));
                    },child: ShopUnit(usermodel: userList[index],)),

                    ],
                      );
                    }else {
                      return GestureDetector(onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopScreen(uid: userList[index].uid!,)));
                      },child: ShopUnit(usermodel: userList[index],));
                    }
                  },itemCount: userList.length,);
                }else{
                  return Center(child: Center(child: Text(local.noShopsFound),),);
                }
              },future: getList()),
            ))
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff5e7af3),
        title: Text('${title}'),
      ),
    );
  }
  Future<List<UserModel>> getList() async {
    UserModel model1=Provider.of<UserProvider>(context,listen: false).userModel!;
    await FirebaseDatabase.instance.ref().child('users').orderByChild('role').equalTo('serviceProvider').once().then((value) async {
      userList.clear();
      for(DataSnapshot snap in (value.snapshot.children)) {
        UserModel model = UserModel.formMap((snap.value)! as Map);
        // print(model.shopType!.toLowerCase());
        // print(type.toLowerCase());
        if (model.shopStatus == 'open' && model.shopType!.toLowerCase()==type.toLowerCase() && model.accountStatus!='blocked') {
          if (currentSort == 'Location') {
            model.distance = Geolocator.distanceBetween(
                model1.latitude ?? 0, model1.longitude ?? 0,
                model.latitude ?? 180, model.longitude ?? 180);
          }
          if (currentSort == 'Rating') {
            await FirebaseDatabase.instance.ref().child('orders').orderByChild(
                'sellerUID').equalTo(model.uid!).once().then((value) {
              double rating = 0;
              int total = 0;
              for (DataSnapshot snap in (value.snapshot.children)) {
                OrderModel? orderModel = OrderModel.fromMap(snap.value! as Map);
                rating += orderModel.rating ?? 0;
                if (orderModel.rating != 0) {
                  total++;
                }
              }
              model.rating = rating / total;
            });
          }
          if (searchController.text.isNotEmpty) {
            if ((model.name?.toLowerCase().contains(searchController.text.toLowerCase()))!) {
              userList.add(model);
            }
          } else {
            userList.add(model);
          }
        }
      }
      if(currentSort=='A-Z'){
        userList.sort((a,b)=> (b.name?.compareTo(a.name!))!);
      }else if(currentSort=='Location'){
        userList.sort((a,b)=>(a.distance?.compareTo(b.distance as num))!);
      }else if(currentSort=='Rating'){
        userList.sort((a,b)=>(b.rating?.compareTo(a.rating as num))!);
      }
      // UserModel model=userList.elementAt(0);
      // userList.insert(0, new UserModel());
      // userList.insert(1, model);
      // userList.add(model);
    });
    return userList;
    }
}
class ShopUnit extends StatelessWidget {
  const ShopUnit({Key? key,required this.usermodel}) : super(key: key);
  final UserModel usermodel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Color(0xffd4e8ff),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            SizedBox(width: 16,),
            Container(height: 100, width: 100,
            decoration: BoxDecoration(
              color: Color(0xfff1f7ff),
              borderRadius: BorderRadius.circular(20),
            ),
            child: usermodel.photoUrl==null ? Image.asset('client.png') : Image.network(usermodel.photoUrl!),),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xfff1f7ff),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.only(left: 16,top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(usermodel.name ?? 'Shop Name',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                     SizedBox(height: 8,),
                     Consumer<ProductProvider>(builder:(context,provider,child){
                       List<ProductModel> productList = provider.allList;
                       String value='';
                       for(ProductModel model in productList){
                         if(model.sellerUID==usermodel.uid) {
                           value += '${model.name ?? ''}, ';
                         }
                       }
                       if (value != null && value.length > 0) {
                         value = value.substring(0, value.length - 1);
                       }
                       return SingleChildScrollView(scrollDirection:Axis.horizontal,child: Text(value.isNotEmpty ? '$value' : 'No Products'));
                     }),
                      SizedBox(height: 8,),
                      Row(
                        children: [
                          Icon(Icons.local_shipping),
                          SizedBox(width: 10,),
                          Consumer<UserProvider>(builder:(context,provider,child){
                            int distance=Geolocator.distanceBetween((provider.userModel?.latitude)??0, (provider.userModel?.longitude)??0, (usermodel.latitude)?? 0, usermodel.longitude??0).toInt();
                            return Text('${distance/1000} km');
                          }),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Row(
                        children: [
                          Icon(Icons.star,color: Color(0xFFFF7E26),),
                          FutureBuilder(builder: (context,AsyncSnapshot<DatabaseEvent>snapshot){
                            if(snapshot.hasData){
                              double rating=0;
                              int total=0;
                              for(DataSnapshot snap in (snapshot.data?.snapshot.children)!){
                                OrderModel orderModel=OrderModel.fromMap(snap.value as Map);
                                if(orderModel.rating!=0){
                                  rating+=orderModel.rating ?? 0;
                                  total++;
                                }
                              }
                              return Text('${(rating/total).toStringAsFixed(2)} ( $total )');
                            }else{
                              return SizedBox();
                            }
                          },future: FirebaseDatabase.instance.ref().child('orders').orderByChild('sellerUID').equalTo(usermodel.uid!).once(),)
                        ],
                      ),
                      SizedBox(height: 8,),
                      FutureBuilder(builder: (context,AsyncSnapshot<String> snapshot){
                        if(snapshot.hasData){
                          return Row(
                            children: [
                              Icon(Icons.location_pin,color: Colors.red,),
                              Text('${snapshot.data}'),
                            ],
                          );
                        }else{
                          return Row(
                            children: [
                              Icon(Icons.location_pin,color:Colors.red),
                              Text(AppLocalizations.of(context).noAdress),
                            ],
                          );
                        }
                      },future: getSubLocality(usermodel.latitude ?? 0,usermodel.longitude??0),),
                  ],),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String>getSubLocality(double latitude,double longitude) async{
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    String? subLocality=placemarks.first.subLocality;
    if(subLocality!=null && subLocality.isNotEmpty) return subLocality;
    for(Placemark mark in placemarks){
      if(subLocality==null || subLocality.isEmpty) subLocality=mark.subLocality;
    }
    for(Placemark mark in placemarks){
      if(subLocality==null || subLocality.isEmpty) subLocality=mark.locality;
    }
    return subLocality ?? 'Address not found';
  }
}

