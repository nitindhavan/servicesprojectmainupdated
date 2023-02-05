import 'dart:math';
import 'package:WeServeU/dashboards/provider_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../dashboards/client_dashboard.dart';
import '../data/constants.dart';
import '../data/get_all_data.dart';
import '../model/user_model.dart';
import '../providers/user_provider.dart';
import '../widget/widgets.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final Map<String, dynamic> initData = {};

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    Provider.of<UserProvider>(context, listen: false).init();
    return Scaffold(
      body: Consumer<UserProvider>(builder: (context, provider, _) {
        if (!provider.inited) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (provider.userModel == null) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: MyTitle(
                      text: 'Please enter below details',
                      alignment: Alignment.center,
                    ),
                  ),
                  textInput(key: 'name', hint: 'Enter your name'),
                  textInput(
                      key: 'idCard',
                      hint: 'Enter your id card / passport number'),
                  Row(
                    children: [
                      const Spacer(),
                      Radio(
                          value: serviceProvider,
                          groupValue: initData['role'],
                          onChanged: (v) {
                            setState(() {
                              initData['role'] = v;
                            });
                          }),
                      const Text('Service provider'),
                      const Spacer(),
                      Radio(
                          value: client,
                          groupValue: initData['role'],
                          onChanged: (v) {
                            setState(() {
                              initData['role'] = v;
                            });
                          }),
                      const Text('Client'),
                      const Spacer(),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Title(
                            color: Colors.blueGrey,
                            child: const Text('Please select Currency')),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Autocomplete<Map<String, String>>(
                            displayStringForOption: (m) {
                              return '${m['name']}';
                            },
                            optionsBuilder: (
                                TextEditingValue textEditingValue) {
                              return (currencies.where((element) =>
                              element['name']!.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase()) ||
                                  element['code']!.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase())));
                            },
                            onSelected: (m) {
                              initData['currencyCode'] = m['code'];
                            },
                            fieldViewBuilder: (context,
                                textEditingController,
                                focusNode,
                                onFieldSubmitted,) {
                              if (textEditingController.text.isEmpty) {
                                textEditingController.text =
                                    initData['currencyCode'] ??
                                        currencies.first['code'];
                              }

                              return TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                onFieldSubmitted: (v) {
                                  onFieldSubmitted();
                                },
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        _form.currentState!.save();
                        if (_form.currentState!.validate()) {
                          if (initData['role'] == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please select your role client/service provider')));
                          }
                          if (initData['currencyCode'] == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Text('Please select your currency')));
                          } else {
                            provider.addUser(initData);
                          }
                        }
                      },
                      child: Text(appLocalizations.confirm))
                ],
              ),
            ),
          );
        }

        print(provider.userModel?.role);
        initAllData(context);
        switch (provider.userModel!.role) {
          case client:
            return const ClientDashBoard();
          case serviceProvider:
            return const ProviderDashBoard();

          default:
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
      );
  }

  Padding textInput({required String key, required String hint}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: initData[key],
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        validator: (v) {
          if (v!.isEmpty) {
            return hint;
          }
          return null;
        },
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

  @override
  void initState() {
    super.initState();
   }
}
class CodeGenerator {
  static Random random = Random();

  static String generateCode(String prefix) {
    var id = random.nextInt(92143543) + 09451234356;
    return '$prefix-${id.toString().substring(0, 8)}';
  }
}