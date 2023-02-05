import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widget/widgets.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({Key? key}) : super(key: key);
  static String routeName = 'verify-otp';

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  List<FocusNode> focuses = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.grey,
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 144.0),
                child: Center(
                  child: Text(
                    appLocalization.fillthecode,
                    style: const TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _form,
                  child: LayoutBuilder(
                    builder: (ctx, constraint) {
                      return Consumer<AuthProvider>(builder:
                          (BuildContext context, provider, Widget? child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (int i = 0; i < 6; i++)
                              OtpUnit(
                                focuses: focuses,
                                i: i,
                                userOtp: provider.userOtp,
                                constraint: constraint,
                              ),
                          ],
                        );
                      });
                    },
                  ),
                ),
              ),
              Consumer<AuthProvider>(builder: (context,provider,child){
                return Visibility(
                  visible: provider.seconds<=0,
                  child: GestureDetector(
                    onTap: (){
                      provider.resend();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(right: 32),
                      child: Text(
                        appLocalization.resend,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0,color: Colors.indigo),textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                );
              },),
              Consumer<AuthProvider>(
                builder: (BuildContext context, provider, Widget? child) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 48.0, top: 48, right: 48.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: MyContainer(
                            borderStyle: BorderStyle.none,
                            background: Colors.indigo,
                            child: InkWell(
                              onTap: () {
                                _form.currentState!.save();
                                if (_form.currentState!.validate()) {
                                  provider.verifyOtp(provider.userOtp.values
                                      .map((e) => e.text)
                                      .toList()
                                      .join());
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  appLocalization.continueText,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50,),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(provider.info,style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
