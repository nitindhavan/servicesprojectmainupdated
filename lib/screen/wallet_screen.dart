import 'dart:convert';
import 'package:WeServeU/model/withdrawl_model.dart';
import 'package:WeServeU/providers/user_provider.dart';
import 'package:WeServeU/providers/wallet_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../data/constants.dart';
import '../model/bank_card_model.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);
  static const routeName = '/wallet-screen';

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String? coverImage;
  late Razorpay _razorpay;
  bool paymentStarted = false;
  int amount = 0;
  bool addCard = false;
  var cardController = TextEditingController();
  var cvvController = TextEditingController();
  var expiaryController = TextEditingController();
  BankCardModel? cardModel;
  @override
  void initState() {
    _razorpay = Razorpay();
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse v) {
      if (paymentStarted) {
        setState(() {
          paymentStarted = false;
        });
      }

      final provider = Provider.of<WalletProvider>(context, listen: false);
      int? current = (provider.walletModel.amount == null
          ? 0
          : provider.walletModel.amount.toInt());
      provider.credit(current + amount);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Payment is successful')));
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse v) {
      final e = jsonDecode(v.message!);
      e as Map<dynamic, dynamic>;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${e['error']?['description']}')));

      if (paymentStarted) {
        setState(() {
          paymentStarted = false;
        });
      }
    });
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse v) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${v.walletName}')));
      if (paymentStarted) {
        setState(() {
          paymentStarted = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff5e7af3),
        title: Text(local.wallet),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(builder: (context, provider, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffb3d6ff),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            local.yourBalance,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Consumer<WalletProvider>(
                          builder: (context, wprovider, child) {
                            if (wprovider.walletModel.amount == null)
                              wprovider.credit(0);
                            return Text(
                              '${wprovider.walletModel.amount.toStringAsFixed(2)} ${(currency)}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(8),
                                child: TextButton(
                                  onPressed: () {
                                    addMoney(
                                        label: local.entertheamount,
                                        onClick: (text) {
                                          setState(() {
                                            paymentStarted = true;
                                          });
                                          double amount=double.parse(text);
                                          print(amount.toStringAsFixed(2));
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  UsePaypal(
                                                      sandboxMode: true,
                                                      clientId:
                                                      clientId,
                                                      secretKey:
                                                      secretKeyPayPal,
                                                      returnURL: "https://samplesite.com/return",
                                                      cancelURL: "https://samplesite.com/cancel",
                                                      transactions: [
                                                        {
                                                          "amount": {
                                                            "total": '${amount.toStringAsFixed(2)}',
                                                            "currency": "USD",
                                                            "details": {
                                                              "subtotal": '${amount.toStringAsFixed(2)}',
                                                              "shipping": '0',
                                                              "shipping_discount": 0
                                                            }
                                                          },
                                                          "description":
                                                          "The payment transaction description.",
                                                          "item_list": {
                                                            "items": [
                                                              {
                                                                "name": "Total Bill",
                                                                "quantity": 1,
                                                                "price": '${amount.toStringAsFixed(2)}',
                                                                "currency": "USD"
                                                              }
                                                            ],
                                                          }
                                                        }
                                                      ],
                                                      note: "Contact us for any questions on your order.",
                                                      onSuccess: (
                                                          Map params) async {
                                                        if (paymentStarted) {
                                                          setState(() {
                                                            paymentStarted = false;
                                                          });
                                                        }

                                                        final provider = Provider.of<WalletProvider>(context, listen: false);
                                                        int? current = (provider.walletModel.amount == null
                                                            ? 0
                                                            : provider.walletModel.amount.toInt());
                                                        provider.credit(current + amount);

                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(const SnackBar(content: Text('Payment is successful')));
                                                      },
                                                      onError: (error) {
                                                        print(
                                                            "onError: $error");
                                                      },
                                                      onCancel: (params) {
                                                        print(
                                                            'cancelled: $params');
                                                      }),
                                            ),
                                          );
                                        },
                                    );
                                  },
                                  child: Text(
                                    local.depositMoney,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color(0xff5a74ec)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ))),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: TextButton(
                                  //TODO add account number here
                                  onPressed: () {
                                    if(cardModel?.cardNumber==null){
                                      ScaffoldMessenger.of(
                                          context)
                                          .showSnackBar(SnackBar(
                                          content: Text(
                                              'Please add a valid card')));
                                    }
                                    withdrewMoney(
                                        label: local.withdrewMoney,
                                        onClick: (value) async {
                                          var walletProvider =
                                              Provider.of<WalletProvider>(
                                                  context,
                                                  listen: false);
                                          if (double.parse(value) < 10) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        '${local.minimumIs} 10')));
                                          } else if (double.parse(value) <=
                                              walletProvider
                                                  .walletModel.amount) {
                                            walletProvider.credit(walletProvider
                                                    .walletModel.amount -
                                                double.parse(value));
                                            var ref = FirebaseDatabase.instance
                                                .ref('withdrawals');
                                            String key = await ref.push().key!;
                                            WithdrawlModel model =
                                                WithdrawlModel(
                                                    key: key,
                                                    amount: double.parse(value),
                                                    status: 'pending',uid: FirebaseAuth.instance.currentUser!.uid);
                                            ref.child(key).set(model.toMap());
                                            Navigator.pop(context);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(local
                                                        .notEnoughBalance)));
                                            Navigator.pop(context);
                                          }
                                        },
                                    accountNumber: '39932690621',
                                    cardNumber: cardModel?.cardNumber ?? '',
                                    name: provider.userModel?.name ?? 'UserName',
                                    email: provider.userModel?.email ?? 'email@gmail.com',
                                    phone: FirebaseAuth.instance.currentUser?.phoneNumber ?? 'Phone');
                                  },
                                  child: Text(local.withdrewMoney,
                                      style: TextStyle(color: Colors.white)),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xff5a74ec)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapShot) {
                    if (snapShot.hasData &&
                        snapShot.data?.snapshot.value != null) {
                      return SizedBox();
                    } else {
                      return (TextButton(
                        onPressed: () {
                          setState(() {
                            addCard = true;
                          });
                        },
                        child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                                child: Text(
                              local.addCard,
                              style: TextStyle(color: Colors.white),
                            ))),
                      ));
                    }
                  },
                  future: FirebaseDatabase.instance
                      .ref('bankcard')
                      .child((provider.userModel?.uid)!)
                      .once(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (addCard)
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      local.addCard,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )),
              if (addCard)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 275,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFB3D6FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 32,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CardNumberFormatter(),
                            ],
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            controller: cardController,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/800px-Mastercard-logo.svg.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                              border: OutlineInputBorder(),
                              labelText: local.cardNumber,
                            ),
                            maxLength: 19,
                            onChanged: (value) {},
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: cvvController,
                                  decoration: InputDecoration(
                                    hintText: local.securityCode,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: expiaryController,
                                  decoration: InputDecoration(
                                    hintText: local.expiaryDate,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          height: 60,
                          padding: EdgeInsets.all(8),
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () async {
                              BankCardModel cardModel = BankCardModel(
                                  uid: (provider.userModel?.uid)!,
                                  cardNumber: cardController.text,
                                  cvv: cvvController.text,
                                  expiary: expiaryController.text);
                              await FirebaseDatabase.instance
                                  .ref()
                                  .child('bankcard')
                                  .child((provider.userModel?.uid)!)
                                  .set(cardModel.toMap())
                                  .then((value) {
                                setState(() {
                                  addCard = false;
                                });
                              });
                            },
                            child: Text(
                              local.save,
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff5a74ec)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  child: Text(
                    local.withdrawalHistory,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  )),
              StreamBuilder(
                builder:
                    (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.hasData) {
                    List<Widget> list = [];
                    for(DataSnapshot snap in snapshot.data!.snapshot.children) {
                      WithdrawlModel model =
                      WithdrawlModel.formMap(snap.value as Map);
                      list.add(Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 70,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 16,),
                                Expanded(child: Text('${local.amount} : ${model.amount}')),
                                Icon(model.status=='pending' ? Icons.incomplete_circle : Icons.check,color:model.status=='pending' ? Colors.black : Colors.green ,),
                                SizedBox(width: 16,),
                              ],
                            )),
                      ));
                    }
                    return Column(
                      children: list,
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
                stream: FirebaseDatabase.instance.ref('withdrawals').orderByChild('uid').equalTo(FirebaseAuth.instance.currentUser!.uid).onValue,
              )
            ],
          );
        }),
      ),
    );
  }

  addMoney({required String label, required Function(String) onClick}) async {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(label),
          content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: controller,
                decoration: InputDecoration(
                    labelText: label, border: const OutlineInputBorder()),
              )),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context).cancel)),
            ElevatedButton(
                onPressed: () {
                  onClick(controller.text);
                },
                child: Text(AppLocalizations.of(context).addMoney))
          ],
        );
      },
    );
  }

  withdrewMoney(
      {required String label, required Function(String) onClick,required String accountNumber,required String cardNumber,required String name,required String email,required String phone}) async {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(label),
          content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: controller,
                decoration: InputDecoration(
                    labelText: label, border: const OutlineInputBorder()),
              )),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context).cancel)),
            ElevatedButton(
                onPressed: () {
                  tryPayout(accountNumber, amount, cardNumber, name, email, phone, context).then((value){
                    //TODO implement your changes here
                    if(value=='Hell No'){
                      onClick(controller.text);
                    }else{

                    }
                  });
                },
                child: Text(AppLocalizations.of(context).withdrewMoney))
          ],
        );
      },
    );
  }
  Future<String> tryPayout(String accountNumber,int amount,String cardNumber,String name,String email,String phone,BuildContext context) async {
    //TODO implement status here
    try {
      // String bauth =
      //     "Basic ${base64Encode(utf8.encode('$razorPayKey:$razorPaySecrete'))}";
      // final response = await http.post(
      //     Uri.parse(
      //         'https://api.razorpay.com/v1/payouts'),
      //     body: jsonEncode({
      //       "account_number": "$accountNumber",
      //       "amount": amount,
      //       "currency": "JOD",
      //       "mode": "NEFT",
      //       "purpose": "refund",
      //       "fund_account": {
      //         "account_type": "card",
      //         "card": {
      //           "number": "$cardNumber",
      //           "name": "$name"
      //         },
      //         "contact": {
      //           "name": "$name",
      //           "email": "$email",
      //           "contact": "$phone",
      //           "type": "employee",
      //           "reference_id": DateTime.now().toIso8601String(),
      //         }
      //       },
      //       "queue_if_low_balance": true,
      //       "reference_id": DateTime.now().toIso8601String(),
      //       "narration": "Withdrawl",
      //     }),
      //     headers: {
      //       'Content-type':
      //       'application/json',
      //       'Accept':
      //       'application/json',
      //       'Authorization': bauth
      //     }).then((value) {
      //   print(value.body);
      // });
    } catch (e) {
      print(e);
      if (e.runtimeType ==
          ({}).runtimeType) {
        e as Map<dynamic, dynamic>;
        ScaffoldMessenger.of(
            context)
            .showSnackBar(SnackBar(
            content: Text(
                '${e['error']?['description']}')));
      }
    }
    return 'Hell No';
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue previousValue,
    TextEditingValue nextValue,
  ) {
    var inputText = nextValue.text;

    if (nextValue.selection.baseOffset == 0) {
      return nextValue;
    }

    var bufferString = new StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var string = bufferString.toString();
    return nextValue.copyWith(
      text: string,
      selection: new TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}
