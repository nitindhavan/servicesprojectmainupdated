import 'package:flutter/material.dart';
import 'package:WeServeU/global.dart' as globals;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef StringCallback = void Function(String val);

class ShopTypeComponent extends StatefulWidget {
  const ShopTypeComponent({super.key});

  @override
  State<ShopTypeComponent> createState() => _ShopTypeComponentState();

}

class _ShopTypeComponentState extends State<ShopTypeComponent> {
  int selected=1;
  @override
  Widget build(BuildContext context) {
    var localisation=AppLocalizations.of(context);
    if(selected==1){
      globals.shopType='gas';
    }else if (selected==2){
      globals.shopType='water';
    }else if(selected==3){
      globals.shopType='car';
    }else if(selected==4){
      globals.shopType='mobile';
    }else if(selected==5){
      globals.shopType='realestatesale';
    }else if(selected==6){
      globals.shopType='realestaterent';
    }else if(selected==7){
      globals.shopType='electronics';
    }else if(selected==8){
      globals.shopType='supermarket';
    }else if(selected==9){
      globals.shopType='restaurant';
    }else if(selected==10){
      globals.shopType='clothing';
    }else if(selected==11){
      globals.shopType='shoes';
    }else if(selected==12){
      globals.shopType='wholesale';
    }else if(selected==13){
      globals.shopType='furniture';
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40,),
          Text('${localisation.yourShopTypeis} ',style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24),),
          const SizedBox(height: 32,),
          GestureDetector(
            onTap: (){
              setState(() {
                selected=1;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: selected==1 ? const Color(0xffb6ff9f) : const Color(0xffb3d6ff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset('cylinder.png',height: 100,width: 100,),
                    ),
                    Text('${localisation.gasSevices}',style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selected=2;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: selected==2 ? Color(0xffb6ff9f) : Color(0xffb3d6ff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset('water.png',height: 100,width: 100,),
                    ),
                    Text('${localisation.waterServices}',style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selected=3;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: selected==3 ? Color(0xffb6ff9f) : Color(0xffb3d6ff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset('bike_icon.png',height: 100,width: 100,),
                    ),
                    Text('${localisation.carsAndBikes}',style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selected=4;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: selected==4 ? const Color(0xffb6ff9f) : const Color(0xffb3d6ff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset('mobile_icon.png',height: 100,width: 100,),
                    ),
                    Text('${localisation.mobilesAndTablets}',style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selected=5;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: selected==5 ? Color(0xffb6ff9f) : Color(0xffb3d6ff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset('for_sale.png',height: 100,width: 100,),
                    ),
                    Text('${localisation.realEstateForSale}',style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selected=6;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: selected==6 ? Color(0xffb6ff9f) : Color(0xffb3d6ff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset('for_rent.png',height: 100,width: 100,),
                    ),
                    Text('${localisation.realEstateForRent}',style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selected=7;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: selected==7 ? const Color(0xffb6ff9f) : const Color(0xffb3d6ff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset('electronics.png',height: 100,width: 100,),
                    ),
                    Text('${localisation.electronics}',style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selected=8;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: selected==8 ? const Color(0xffb6ff9f) : const Color(0xffb3d6ff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset('supermarket.png',height: 100,width: 100,),
                    ),
                    Text('${localisation.supermarket}',style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selected=9;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: selected==9 ? const Color(0xffb6ff9f) : const Color(0xffb3d6ff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset('restaurant.jpg',height: 100,width: 100,),
                    ),
                    Text('${localisation.restaurantAndSweets}',style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selected=10;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: selected==10 ? const Color(0xffb6ff9f) : const Color(0xffb3d6ff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset('clothing.png',height: 100,width: 100,),
                    ),
                    Text('${localisation.clothing}',style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selected=11;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: selected==11 ? const Color(0xffb6ff9f) : const Color(0xffb3d6ff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset('shoes.jpg',height: 100,width: 100,),
                    ),
                    Text('${localisation.shoes}',style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selected=12;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: selected==12 ? const Color(0xffb6ff9f) : const Color(0xffb3d6ff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset('wholesale.jpg',height: 100,width: 100,),
                    ),
                    Text('${localisation.wholesaleMarket}',style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              setState(() {
                selected=13;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: selected==13 ? const Color(0xffb6ff9f) : const Color(0xffb3d6ff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Image.asset('furniture.jpg',height: 100,width: 100,),
                    ),
                    Text('${localisation.homeFurniture}',style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
