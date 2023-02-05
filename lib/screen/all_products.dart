
import 'package:WeServeU/screen/shop_list_screen.dart';
import 'package:WeServeU/screen/shop_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:WeServeU/model/order_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../data/constants.dart';
import '../model/user_model.dart';
import '../providers/orders_provider.dart';

class AllProductsScreen extends StatelessWidget {
  AllProductsScreen({
    Key? key, required this.scaffoldKey,
  }) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {

    var local=AppLocalizations.of(context);
    return Container(
          height: double.infinity,
              alignment: Alignment.topCenter,
              child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child:SingleChildScrollView(
            child: Column(
              children: [
                Row(children: [
                    Expanded(child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopListScreen(type: 'gas',title: local.gasSevices,)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffb3d6ff) ,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Image.asset('cylinder.png',height: 150,width: 150,),
                                ),
                                Text(local.gasSevices,style: TextStyle(fontSize: 16),),
                                SizedBox(height: 16,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
                    Expanded(child: GestureDetector(
                      onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopListScreen(type: 'water',title: local.waterServices,)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffb3d6ff),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Image.asset('water.png',height: 150,width: 150,),
                              ),
                              Text(local.waterServices,style: TextStyle(fontSize: 16),),
                              SizedBox(height: 16,),
                            ],
                          ),
                        ),
                      ),
                    )),
                ],),
                SizedBox(height: 16,),

                Row(children: [
                  Expanded(child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopListScreen(type: 'supermarket',title: local.supermarket,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffb3d6ff),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset('supermarket.png',height: 150,width: 150,),
                            ),
                            Text(local.supermarket,style: TextStyle(fontSize: 16),),
                            SizedBox(height: 16,),
                          ],
                        ),
                      ),
                    ),
                  )),
                  Expanded(child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopListScreen(type: 'restaurant',title: local.restaurantAndSweets,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffb3d6ff) ,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Image.asset('restaurant.jpg',height: 134, width: 150),
                              ),
                              Text(local.restaurantAndSweets,style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),
                              SizedBox(height: 16,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),

                ],),
                SizedBox(height: 16,),

                Row(children: [
                  Expanded(child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopListScreen(type: 'mobile',title: local.mobilesAndTablets,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffb3d6ff),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset('mobile_icon.png',height: 150,width: 150,),
                            ),
                            Text(local.mobilesAndTablets,style: TextStyle(fontSize: 16),),
                            SizedBox(height: 16,),
                          ],
                        ),
                      ),
                    ),
                  )),
                  Expanded(child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopListScreen(type: 'electronics',title: local.electronics,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffb3d6ff) ,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Image.asset('electronics.png',height: 150, width: 150),
                              ),
                              Text(local.electronics,style: TextStyle(fontSize: 16),),
                              SizedBox(height: 16,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),

                ],),

                SizedBox(height: 16,),
                Row(children: [
                  Expanded(child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopListScreen(type: 'clothing',title: local.clothing,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffb3d6ff),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset('clothing.png',height: 150,width: 150,),
                            ),
                            Text(local.clothing,style: TextStyle(fontSize: 16),),
                            SizedBox(height: 16,),
                          ],
                        ),
                      ),
                    ),
                  )),
                  Expanded(child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopListScreen(type: 'shoes',title: local.shoes,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffb3d6ff) ,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Image.asset('shoes.jpg',height: 150, width: 150),
                              ),
                              Text(local.shoes,style: TextStyle(fontSize: 16),),
                              SizedBox(height: 16,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),

                ],),
                SizedBox(height: 16,),
                Row(children: [
                  Expanded(child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopListScreen(type: 'realestatesale',title: local.realEstateForSale,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffb3d6ff) ,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Image.asset('for_sale.png',height: 150, width: 150),
                              ),
                              Text(local.realEstateForSale,style: TextStyle(fontSize: 16),),
                              SizedBox(height: 16,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
                  Expanded(child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopListScreen(type: 'realestaterent',title: local.realEstateForRent,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffb3d6ff),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset('for_rent.png',height: 150,width: 150,),
                            ),
                            Text(local.realEstateForRent,style: TextStyle(fontSize: 16),),
                            SizedBox(height: 16,),
                          ],
                        ),
                      ),
                    ),
                  )),

                ],),
                SizedBox(height: 16,),
                Row(children: [
                  Expanded(child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopListScreen(type: 'furniture',title: local.homeFurniture,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffb3d6ff) ,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Image.asset('furniture.jpg',height: 150, width: 150),
                              ),
                              Text(local.homeFurniture,style: TextStyle(fontSize: 16),),
                              SizedBox(height: 16,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
                  Expanded(child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopListScreen(type: 'wholesale',title: local.wholesaleMarket,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffb3d6ff),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset('wholesale.jpg',height: 150,width: 150,),
                            ),
                            Text(local.wholesaleMarket,style: TextStyle(fontSize: 16),),
                            SizedBox(height: 16,),
                          ],
                        ),
                      ),
                    ),
                  )),
                ],),
                SizedBox(height: 16,),
                Row(children: [
                  Expanded(child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopListScreen(type: 'car',title: local.carsAndBikes,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffb3d6ff) ,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Image.asset('bike_icon.png',height: 150,width: 150,),
                              ),
                              Text(local.carsAndBikes,style: TextStyle(fontSize: 16),),
                              SizedBox(height: 16,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
                  Expanded(child: SizedBox()),
                ],),
              ],
            ),
          ),
        ),
    );
  }
  shopUnit(UserModel userModel,context){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: ((context) => ShopScreen(uid: userModel.uid!,))));
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 150,
              width:150,
              child:userModel.photoUrl == null ? Image.asset('cod.jpg') : Image.network(userModel.photoUrl!),),
          ),
          Text(userModel.name!),
          SizedBox(height: 5,),
          Consumer<OrdersProvider>(builder: (context,provider,child){
            int count=0;
            int total=0;
            for(OrderModel orderModel in provider.ordersList){
              if(orderModel.sellerUID==userModel.uid){
                if(orderModel.rating!=null){
                  total+=orderModel.rating!;
                  count++;
                }
              }
            }
            if(count==0) count=1;
            return RatingBar(
              initialRating: total/count,
              direction: Axis.horizontal,
              itemSize: 15,
              allowHalfRating: false,
              itemCount: 5,
              ratingWidget: RatingWidget(
                full: Image.asset('assets/yellowheart.png'),
                empty: Image.asset('assets/whiteheart.png'), half: SizedBox(),
                // half: _image('assets/heart_half.png'),
                // empty: _image('assets/heart_border.png'),
              ),
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              onRatingUpdate: (rating) {
              },
            );
          }),

        ],
      )
    );
    }
  Future<List<UserModel>?> getData(String type) async {
    List<UserModel> userModels=[];
    await firebaseDatabase.ref(userReference).once().then((value){
      for(DataSnapshot snap in value.snapshot.children) {
        UserModel? userModel = UserModel.formMap(snap.value as Map<dynamic, dynamic>);
        if(userModel.role==serviceProvider) {
          if(userModel.shopType==type) {
            userModels.add(userModel);
          }
        }
      }
    });
    return userModels;
    }
}
