import 'package:WeServeU/providers/payment_provider.dart';
import 'package:WeServeU/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class GetPaidScreen extends StatefulWidget {
  const GetPaidScreen({Key? key}) : super(key: key);
  static const routeName = '/get-paid';

  @override
  State<GetPaidScreen> createState() => _GetPaidScreenState();
}

class _GetPaidScreenState extends State<GetPaidScreen> {
  Map<String, dynamic> initData = {};

  bool edit = false;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  getInitData() {
    Future.delayed(const Duration(seconds: 0)).whenComplete(() {
      if (Provider.of<PaymentProvider>(context, listen: false).paymentModel !=
          null) {
        setState(() {
          initData = (Provider.of<PaymentProvider>(context, listen: false)
              .paymentModel!
              .toMap());
        });
      } else {
        getInitData();
      }
    });
  }

  @override
  void initState() {
    getInitData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var local=AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.credentials),
        backgroundColor: Color(0xff5e7af3),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: MyCustomCard(
                  elevation: 1,
                  child: Column(
                    children: [
                      Label(text: local.payPalCredentials),
                      MySubTitle(
                          text:
                              local.wewilpayyoubyusingyourpaypalemailaddresssopleaseentercorrectemailaddressusedtologinonpaypal),
                      textInput(
                          key: 'name', hint: local.pleaseEnteryournameonPayPal),
                      textInput(
                          key: 'email',
                          hint: local.pleaseenterPayPalemailaddress),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (!edit) {
              setState(() {
                edit = true;
              });
            } else {
              _form.currentState!.save();
              if (_form.currentState!.validate()) {
                Provider.of<PaymentProvider>(context, listen: false)
                    .update(initData)
                    .then((value) {
                  if (value == null) {
                    setState(() {
                      edit = false;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(value)));
                  }
                });
              }
            }
          },
          label: Text(edit ?  local.save : local.update)),
    );
  }

  Padding textInput({required String key, required String hint}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        key: Key('${initData[key] ?? ''}'),
        initialValue: '${initData[key] ?? ''}',
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        validator: (v) {
          if (v!.isEmpty) {
            return hint;
          }
          return null;
        },
        enabled: edit,
        onSaved: (v) {
          initData[key] = v!;
        },
        style: const TextStyle(
            color: Colors.blueGrey, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: hint,
          border: const OutlineInputBorder(),
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
