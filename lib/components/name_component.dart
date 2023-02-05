import 'package:flutter/material.dart';

import '../global.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NameComponent extends StatefulWidget {
  const NameComponent({Key? key}) : super(key: key);

  @override
  State<NameComponent> createState() => _NameComponentState();
}

class _NameComponentState extends State<NameComponent> {
  var controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      username=controller.text;
    });
    var localisation=AppLocalizations.of(context);
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            Center(child: Container(height:150,width:150,child: Image.asset(userType=='client' ? 'customer.png' : 'stearing.png'))),
            SizedBox(height: 32,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(localisation.yourName,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: localisation.enterYourName,
                  labelText: localisation.enterYourName,
                ),
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}