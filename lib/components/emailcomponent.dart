import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../global.dart';

class EmailComponent extends StatefulWidget {
  const EmailComponent({Key? key}) : super(key: key);

  @override
  State<EmailComponent> createState() => _EmailComponentState();
}

class _EmailComponentState extends State<EmailComponent> {
  var controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    var localisation=AppLocalizations.of(context);
    controller.addListener(() {
      email=controller.text;
    });
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            Center(child: Container(height:150,width:150,child: Image.asset('email.png'))),
            SizedBox(height: 32,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(localisation.yourEmail,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: localisation.enterYourEmail,
                  labelText: localisation.enterYourEmail,
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