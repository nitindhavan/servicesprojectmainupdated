import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../providers/auth_provider.dart';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:country_calling_code_picker/picker.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static const routeName = '/login-screen';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Country? country;
  bool checkbox1 = false;
  bool checkbox2 = false;
  var controller = TextEditingController();
  bool clicked = false;
  @override
  void initState() {
    /*
    Default country code for india
     */
    getCountry();
    initData['country'] = "+968";
    super.initState();
  }

  void getCountry() async {
    country = await getCountryByCountryCode(context, 'IN');
    initData['country'] = '${country?.callingCode}';
  }

  String languageCode = 'en';
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () async {
                      var sharep = await SharedPreferences.getInstance();
                      setState(() {
                        languageCode=languageCode=='en' ?'ar':'en';
                        sharep.setString('languagecode', languageCode);
                        MyApp.of(context)
                            ?.setLocale(Locale.fromSubtags(languageCode: languageCode));
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 70,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xffd4e8ff),
                          borderRadius: BorderRadius.circular(10),
                        ),
                          child: Center(
                            child: Text('Switch to Language : ${
                        languageCode=='en'?'العربية':'English'}',
                        textAlign: TextAlign.center,
                      ),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Text(
                  local.enterYourNumber,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 32,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      _showCountryPicker();
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xffd4e8ff),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  local.countryRegion,
                                  style: TextStyle(color: Colors.black45),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, bottom: 8,right: 8),
                                child: Text(
                                    '${initData['country']} ${country?.name ?? 'Country'}'),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_drop_down),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0,),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xffd4e8ff),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    height: 61,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                          child: Center(
                            child: TextField(
                              decoration: InputDecoration(
                                  labelText: local.yourPhone,
                                  icon: Icon(Icons.call)),
                              controller: controller,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 150,
                ),
                //TODO add this change to arabic file too
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: checkbox1,
                      onChanged: (v) {
                        setState(() {
                          checkbox1 = v!;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                        child: Text(
                          local.ihavereadandacceptedtheprivacypolicy,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Consumer<AuthProvider>(
                  builder: (BuildContext context, authProvider, Widget? child) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 50),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 50,
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                if (checkbox1 && controller.text.isNotEmpty) {
                                  initData['mobile'] = controller.text;
                                  authProvider.signIn(initData, context);
                                  setState(() {
                                    clicked = true;
                                  });
                                }
                              },
                              child: Text(
                                local.next,
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.indigo),
                              ),
                            ),
                          ),
                        ),
                        if (clicked)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 16),
                            child: LinearProgressIndicator(
                              color: Colors.cyanAccent,
                            ),
                          ),
                      ],
                    );
                  },
                )
              ],
            ),
          )),
    );
  }

  final Map<String, dynamic> initData = {};

  void _showCountryPicker() async {
    final currentcountry = await showCountryPickerSheet(
      context,
    );
    if (currentcountry != null) {
      setState(() {
        country = currentcountry;
        initData['country'] = country?.callingCode;
      });
    }
  }
}
