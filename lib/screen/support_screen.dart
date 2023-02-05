
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    var local=AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff5e7af3),
        automaticallyImplyLeading: false,
        title: Text(local.supportUS),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(child:Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('followImage.jpg'),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(local.supportuson,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FutureBuilder(builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if(!snapshot.hasData) return CircularProgressIndicator();
                return GestureDetector(
                  onTap: () async{
                    Uri url = Uri.parse(snapshot.data!.snapshot.value as String);
                    if (await canLaunchUrl(url))
                      await launchUrl(url);
                    else
                      // can't launch url, there is some error
                      throw "Could not launch $url";
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/c/cd/Facebook_logo_%28square%29.png'),
                  ),
                );
              },future: FirebaseDatabase.instance.ref('data').child('facebook').once(),),
              FutureBuilder(builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if(!snapshot.hasData) return CircularProgressIndicator();
                return GestureDetector(
                  onTap: () async{
                    Uri url = Uri.parse(snapshot.data!.snapshot.value as String);
                    if (await canLaunchUrl(url))
                      await launchUrl(url);
                    else
                      // can't launch url, there is some error
                      throw "Could not launch $url";
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdItA7OlF1GEtUsYu8InDPwIFXr3f9tseHZ3G8fzQ&s'),
                  ),
                );
              },future: FirebaseDatabase.instance.ref('data').child('twitter').once(),),
            ],
          )
        ],
      ),
    )),);
  }
}
