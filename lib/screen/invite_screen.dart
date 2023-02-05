import 'package:WeServeU/data/constants.dart';
import 'package:WeServeU/model/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/user_provider.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({Key? key}) : super(key: key);

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  @override
  Widget build(BuildContext context) {
    var local=AppLocalizations.of(context);
    UserModel value=Provider.of<UserProvider>(context).userModel!;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(0xff5e7af3),
            automaticallyImplyLeading: false,
            title: Text(local.refer),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        body:Column(
          children: [
            Image.asset('referal.jpg'),
            const SizedBox(height: 30),
            Text(local.mYREWARD, style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 30),
            FutureBuilder(builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
              int total=0;
              if(snapshot.hasData){
                List<UserModel> list=[];
                for(DataSnapshot snap in snapshot.data!.snapshot.children){
                  UserModel usermodel;
                  usermodel = UserModel.formMap(snap.value as Map);
                  list.add(usermodel);
                  if(usermodel.referer_code==value.referal_code){
                    total++;
                  }
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('$total j',style: TextStyle(fontSize: 24),),
                );
              }else{
                return Text('0 j');
              }
            }, future: FirebaseDatabase.instance.ref().child('users').orderByChild('referer_code').equalTo(value.referal_code).once(),),
            const SizedBox(height: 20),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 48,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffb3d6ff),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(onPressed: (){
                  Share.share('${local.thisisawesomeappforGasandwaterservices} ${value.referal_link}');
                }, child: Text(local.inviteNow)),
              ),
            ),
          ],
        ),
    ));

  }
  void createLink() async {
    String link = dynamicomain + 'hello'; // it can be any url, it does not have to be an existing one
    final DynamicLinkParameters parameters =
     DynamicLinkParameters(
        uriPrefix: dynamicomain,
        link: Uri.parse(link),
        androidParameters: AndroidParameters(
          packageName: 'com.weserveu.rent',
          minimumVersion: 25,
        ),
        iosParameters: IOSParameters(
          bundleId: 'com.weserveu.rent',
          minimumVersion: '1.0.1',
          appStoreId: '1405860595',
        ),
    );
    await FirebaseDynamicLinks.instance.buildLink(parameters).then((value){

    }).onError((error, stackTrace){
    });
  }

}
