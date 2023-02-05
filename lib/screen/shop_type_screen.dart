import 'package:WeServeU/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ShopType extends StatefulWidget {
  const ShopType({Key? key}) : super(key: key);

  @override
  State<ShopType> createState() => _ShopTypeState();
}

class _ShopTypeState extends State<ShopType> {
  @override
  Widget build(BuildContext context) {
    var local=AppLocalizations.of(context);
    return Scaffold(body:SafeArea(child:Container(
      child: Consumer<UserProvider>(builder:(context,provider,child){
        return SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget>[
                Image.asset('shopimage.jpg'),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(local.shopType,style: TextStyle(fontSize: 20),textAlign: TextAlign.start,),
                ),
                GestureDetector(
                  onTap: () async {
                    provider.updateShopType('water');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(local.water,textAlign: TextAlign.start,style: TextStyle(color:provider.userModel?.shopType=='water' ? Colors.green : Colors.black),),
                  ),
                ),
                GestureDetector(
                  onTap: () async {

          provider.updateShopType('gas');},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(local.gas,textAlign: TextAlign.start,style: TextStyle(color:provider.userModel?.shopType=='gas' ? Colors.green : Colors.black),),
                  ),
                ),
                GestureDetector(
                  onTap: () async {provider.updateShopType('car');},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(local.carsAndBikes,textAlign: TextAlign.start,style: TextStyle(color:provider.userModel?.shopType=='car' ? Colors.green : Colors.black),),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    provider.updateShopType('mobile');},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(local.mobilesAndTablets,textAlign: TextAlign.start,style: TextStyle(color:provider.userModel?.shopType=='mobile' ? Colors.green : Colors.black),),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    provider.updateShopType('electronics');},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(local.electronics,textAlign: TextAlign.start,style: TextStyle(color:provider.userModel?.shopType=='electronics' ? Colors.green : Colors.black),),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    provider.updateShopType('supermarket');},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(local.supermarket,textAlign: TextAlign.start,style: TextStyle(color:provider.userModel?.shopType=='supermarket' ? Colors.green : Colors.black),),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    provider.updateShopType('restaurant');},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(local.restaurantAndSweets,textAlign: TextAlign.start,style: TextStyle(color:provider.userModel?.shopType=='restaurant' ? Colors.green : Colors.black),),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    provider.updateShopType('clothing');},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(local.clothing,textAlign: TextAlign.start,style: TextStyle(color:provider.userModel?.shopType=='clothing' ? Colors.green : Colors.black),),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    provider.updateShopType('shoes');},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(local.shoes,textAlign: TextAlign.start,style: TextStyle(color:provider.userModel?.shopType=='shoes' ? Colors.green : Colors.black),),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    provider.updateShopType('wholesale');},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(local.wholesaleMarket,textAlign: TextAlign.start,style: TextStyle(color:provider.userModel?.shopType=='wholesale' ? Colors.green : Colors.black),),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    provider.updateShopType('furniture');},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(local.homeFurniture,textAlign: TextAlign.start,style: TextStyle(color:provider.userModel?.shopType=='furniture' ? Colors.green : Colors.black),),
                  ),
                ),
              ]
          ),
        );
      }
      ),
    )));
  }
}
