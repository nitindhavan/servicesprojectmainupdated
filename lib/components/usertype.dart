import 'package:flutter/material.dart';
import 'package:WeServeU/global.dart' as globals;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class UserType extends StatefulWidget {
  @override
  State<UserType> createState() => _UserTypeState();

}

class _UserTypeState extends State<UserType> {
  int selected=1;
  @override
  Widget build(BuildContext context) {
    var local=AppLocalizations.of(context);
    if(selected==1){
      globals.userType='client';
    }else if(selected==2){
      globals.userType='serviceProvider';
    }else{
      globals.userType='driver';
    }
    return Container(
      child: Column(
        children: [
          SizedBox(height: 40,),
          Text('${local.youarea} ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24),),
          SizedBox(height: 32,),
          Row(children: [
            Expanded(child: GestureDetector(
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
                    color: selected==1 ? Color(0xffb6ff9f) : Color(0xffb3d6ff),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Image.asset('customer.png'),
                      ),
                      Text(local.customer,style: TextStyle(fontSize: 16),),
                    ],
                  ),
                ),
              ),
            )),
            Expanded(child: GestureDetector(
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Image.asset('client.png'),
                      ),
                      Text(local.serviceProvider,style: TextStyle(fontSize: 16),),
                    ],
                  ),
                ),
              ),
            )),
          ],),
          Row(children: [
            Expanded(child: GestureDetector(
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Image.asset('stearing.png'),
                      ),
                      Text(local.driver,style: TextStyle(fontSize: 16),),
                    ],
                  ),
                ),
              ),
            )),
            Expanded(child: Container()),
          ],)
        ],
      ),
    );
  }
}
