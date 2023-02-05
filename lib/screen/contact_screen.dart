import 'package:WeServeU/widget/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    var local=AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff5e7af3),
        automaticallyImplyLeading: false,
        title: Text(local.contactUs),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(child:
        Column(
          children: [
            Image.asset('contactus.jpg'),
            SizedBox(height: 32,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(local.contactUs,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureText(
                label: local.email + ' : ',
                future: FirebaseDatabase.instance.ref('data').child('email').once().then((value) => value.snapshot),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureText(
                label: local.phoneNumber + ' : ',
                future: FirebaseDatabase.instance.ref('data').child('phone').once().then((value) => value.snapshot),
              ),
            ),
          ],
        ),),
    );
  }
}
