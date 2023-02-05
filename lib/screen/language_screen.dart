import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);
  static _LanguageScreenState? of(BuildContext context) => context.findAncestorStateOfType<_LanguageScreenState>();
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String languageCode='en';
  @override
  Widget build(BuildContext context) {
    var local=AppLocalizations.of(context);
    getSharedPreferences();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff5e7af3),
          automaticallyImplyLeading: false,
          title: Text(local.language),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body:SafeArea(child:Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget>[
          Image.asset('limage.jpg'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(local.selectAppLanguage,style: TextStyle(fontSize: 20),textAlign: TextAlign.start,),
          ),
          GestureDetector(
            onTap: () async {
              var sharep=await SharedPreferences.getInstance();
              setState(() {
                sharep.setString('languagecode','en');
                MyApp.of(context)?.setLocale(Locale.fromSubtags(languageCode: 'en'));
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('English',textAlign: TextAlign.start,style: TextStyle(color: languageCode=='en' ? Colors.green : Colors.black),),
            ),
          ),
          GestureDetector(
            onTap: () async {
              var sharep=await SharedPreferences.getInstance();
              setState(() {
                sharep.setString('languagecode','ar');
                MyApp.of(context)?.setLocale(Locale.fromSubtags(languageCode: 'ar'));
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('العربية',textAlign: TextAlign.start,style: TextStyle(color: languageCode=='ar' ? Colors.green : Colors.black),),
            ),
          ),

        ]
      ),
    )));
  }

  void getSharedPreferences() async{
    var sharep=SharedPreferences.getInstance();
    sharep.then((value) => {
    setState(() {
    languageCode=value.getString('languagecode') ?? 'en';
    })
    });
  }
}
