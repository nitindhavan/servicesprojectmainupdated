import 'dart:convert';

import 'package:WeServeU/providers/user_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/ImageModel.dart';
import '../model/user_model.dart';
import '../providers/wallet_provider.dart';
import '../widget/widgets.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? coverImage;
  late Razorpay _razorpay;
  bool paymentStarted = false;
  int amount = 0;
  String adress = '';
  String key='this';

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
      provider.credit(amount);
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
    UserModel user = Provider.of<UserProvider>(context,listen: false).userModel!;
    if(user.currencyCode==null){
      Provider.of<UserProvider>(context,listen: false).updateCurrency("AED");
    }
    var local=AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff5e7af3),
        automaticallyImplyLeading: false,
        title: Text(local.profile),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Consumer<UserProvider>(builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: ListView(
              children: [
                Label(
                    text: user.role == client
                        ? local.personalDetail
                        : local.shopDetails),
                profilePicture(),
                ListTile(
                  title: Text(user.role == client ? local.name : local.shopName),
                  subtitle: Text('${provider.userModel?.name}'),
                  trailing: IconButton(
                      onPressed: () {
                        open(
                            label: local.updateName,
                            onClick: (x) {
                              provider.updateName(x);
                            });
                      },
                      icon: Image.asset('assets/edit.png')),
                ),
                ListTile(
                  title: Text(local.email),
                  subtitle: Text('${provider.userModel?.email}'),
                  trailing: IconButton(
                      onPressed: () {
                        open(
                            label: local.updateEmail,
                            onClick: (x) {
                              provider.updateEmail(x);
                            });
                      },
                      icon: Image.asset('assets/edit.png')),
                ),
                ListTile(
                  title: Text(local.role),
                  subtitle: Text('${provider.userModel?.role}'),
                  onTap: () {
                    role(
                        label: local.updateRole,
                        onClick: (text) {
                          if (text != null && text.isNotEmpty) {
                            provider.updateRole(text);
                          }
                        });
                  },
                  trailing: Image.asset('assets/edit.png'),
                ),

                ListTile(
                  title: Text(local.mobileNumber),
                  subtitle: Text('${provider.userModel?.mobile}'),
                ),
                ListTile(
                  title: Text(local.currency),
                  subtitle: Text('${provider.userModel?.currencyCode}'),
                ),
                ListTile(
                  title: Text(local.city),
                  subtitle: Text('${provider.userModel?.city}'),
                ),
                ListTile(
                  title: Text(local.country),
                  subtitle: Text('${provider.userModel?.country}'),
                ),
                // Label(text: 'Wallet'),
                // ListTile(
                //   title: const Text('Balance'),
                //   subtitle: Text('${provider.userModel?.balance}'),
                //   trailing: IconButton(
                //       onPressed: () {
                //         addMoney(label: 'Enter the amount', onClick: (text) async {
                //           amount=int.parse(text)*100;
                //           Navigator.of(context).pop();
                //           final userModel =
                //               Provider.of<UserProvider>(
                //                   context,
                //                   listen: false)
                //                   .userModel;
                //         });
                //       },
                //       icon: Icon(Icons.add)),
                // ),
                // Label(text: 'Support Us'),
                // ListTile(
                //   title: const Text('Instagram'),
                //   trailing: IconButton(
                //       onPressed: () {
                //
                //       },
                //       icon: Icon(Icons.arrow_forward_ios)),
                // ),
                // ListTile(
                //   title: const Text('Facebook'),
                //   trailing: IconButton(
                //       onPressed: () {
                //
                //       },
                //       icon: Icon(Icons.arrow_forward_ios)),
                // ),
                // ListTile(
                //   title: const Text('Youtube'),
                //   trailing: IconButton(
                //       onPressed: () {
                //
                //       },
                //       icon: Icon(Icons.arrow_forward_ios)),
                // ),
                // Label(text: 'Invite Freinds'),
                // ListTile(
                //   title: const Text('Invite'),
                //   trailing: IconButton(
                //       onPressed: () {
                //
                //       },
                //       icon: Icon(Icons.arrow_forward_ios)),
                // ),
                // Label(text: 'Contact us'),
                // ListTile(
                //   title: const Text('support@weserveyou.com'),
                //   trailing: IconButton(
                //       onPressed: () {
                //
                //       },
                //       icon: Icon(Icons.arrow_forward_ios)),
                // ),
                if (user.role == 'serviceProvider')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Label(text: local.shopImages),
                      GestureDetector(
                          onTap: () async {
                            final provider = Provider.of<UserProvider>(context,
                                listen: false);
                            final sm = ScaffoldMessenger.of(context);
                            final result = await FilePicker.platform.pickFiles(
                                dialogTitle: "Shop Image",
                                type: FileType.image,
                                allowCompression: true,
                                allowMultiple: false);
                            if (result != null && result.files.isNotEmpty) {
                              setState(() {
                                coverImage = result.paths.first;
                              });
                              final res = await provider
                                  .addImage(result.paths.first);
                              setState(() {
                                key;
                              });
                              coverImage = null;
                              if (res.isNotEmpty) {
                                sm.showSnackBar(SnackBar(content: Text(res)));
                              }
                            }
                          },
                          child: Label(text: local.addImage)),
                    ],
                  ),
                if(user.role=='serviceProvider')Container(
                  height: 300,
                  child: FutureBuilder(
                    key: Key(key),
                    builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (snapshot.hasData) {
                        List<ImageModel> imageModels = [];
                        for (DataSnapshot snap
                            in (snapshot.data?.snapshot.children)!) {
                          ImageModel imageModel =
                              ImageModel.fromMap(snap.value as Map);
                          imageModels.add(imageModel);
                        }
                        if(imageModels.isEmpty){
                          return Center(child: Text(local.shopHasnoImagetodisplay),);
                        }
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Color(0xffd4e8ff),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Image.network(
                                          imageModels[index].imageUrl!),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    FirebaseDatabase.instance
                                        .ref()
                                        .child('images').child(imageModels[index].key!).remove().then((value){
                                          setState(() {
                                            key;
                                          });
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete,color: Colors.red,),
                                      Text(local.remove,style: TextStyle(color: Colors.red),),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                          itemCount: imageModels.length,
                          scrollDirection: Axis.horizontal,
                        );
                      } else {
                        return Center(child: Text(local.shopHasnoImagetodisplay),);
                      }
                    },
                    future: FirebaseDatabase.instance
                        .ref()
                        .child('images')
                        .orderByChild('shopUid')
                        .equalTo(user.uid)
                        .once(),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  profilePicture() {
    return Center(
      child: Stack(
        children: [
          Consumer<UserProvider>(builder: (context, profile, _) {
            return SizedBox(
              height: 144.0,
              width: 144.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: profile.userModel?.photoUrl == null
                    ? MyCustomCard(
                        radius: 0.0,
                        padding: 8,
                        elevation: 1.0,
                        margin: 0.0,
                        child: FittedBox(
                            child: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                        )))
                    : LoadImage(
                        path: profile.userModel?.photoUrl,
                      ),
              ),
            );
          }),
          Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                  onTap: fileFunction,
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.green,
                    ),
                  )))
        ],
      ),
    );
  }

  open({required String label, required Function(String) onClick}) async {
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
                controller: controller,
                decoration: InputDecoration(
                    labelText: label, border: const OutlineInputBorder()),
              )),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:  Text(AppLocalizations.of(context).cancel)),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onClick(controller.text);
                },
                child: Text(AppLocalizations.of(context).update))
          ],
        );
      },
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
                  Navigator.pop(context);
                  onClick(controller.text);
                },
                child: Text(AppLocalizations.of(context).addMoney))
          ],
        );
      },
    );
  }

  // currency({required String label, required Function(String?) onClick}) async {
  //   String? code;
  //   await showDialog<void>(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(label),
  //         content: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Autocomplete<CurrencyModel>(
  //               displayStringForOption: (m) {
  //                 return m.code;
  //               },
  //               optionsBuilder: (TextEditingValue textEditingValue) {
  //                 return (currencies.where((element) =>
  //                     element.name
  //                         .toLowerCase()
  //                         .contains(textEditingValue.text.toLowerCase()) ||
  //                     element.code
  //                         .toLowerCase()
  //                         .contains(textEditingValue.text.toLowerCase())));
  //               },
  //               onSelected: (m) {
  //                 code = m.code;
  //               },
  //             )),
  //         actions: [
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: const Text('Cancel')),
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 onClick(code);
  //               },
  //               child: const Text('Update'))
  //         ],
  //       );
  //     },
  //   );
  //
  //   return code;
  // }

  role({required String label, required Function(String?) onClick}) async {
    TextEditingController controller = TextEditingController();
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onClick(serviceProvider);
                    },
                    child: Text(AppLocalizations.of(context).serviceProvider)),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onClick(client);
                    },
                    child: Text(AppLocalizations.of(context).customer)),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context).cancel)),
              ),
            ],
          ),
        );
      },
    );

    return controller.text;
  }

  type({required String label, required Function(String?) onClick}) async {
    TextEditingController controller = TextEditingController();
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onClick(gas);
                    },
                    child: Text(AppLocalizations.of(context).gas)),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onClick(water);
                    },
                    child: Text(AppLocalizations.of(context).water)),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
              ),
            ],
          ),
        );
      },
    );

    return controller.text;
  }

  fileFunction() async {
    await showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            final provider = Provider.of<UserProvider>(context,
                                listen: false);
                            final sm = ScaffoldMessenger.of(context);
                            final result = await FilePicker.platform.pickFiles(
                                dialogTitle: "Profile picture",
                                type: FileType.image,
                                allowCompression: true,
                                allowMultiple: false);
                            if (result != null && result.files.isNotEmpty) {
                              setState(() {
                                coverImage = result.paths.first;
                              });
                              final res = await provider
                                  .updateProfilePicture(result.paths.first);
                              coverImage = null;
                              if (res.isNotEmpty) {
                                sm.showSnackBar(SnackBar(content: Text(res)));
                              }
                            }
                          },
                          child: Text(AppLocalizations.of(context).update)),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            final provider = Provider.of<UserProvider>(context,
                                listen: false);
                            provider.deletePath();
                          },
                          child: Text(AppLocalizations.of(context).remove))
                    ],
                  ),
                );
              });
        });
  }

  // Future<void> getAdress() async {
  //   // double latitude = (Provider.of<UserProvider>(context).userModel?.latitude)!;
  //   // double longitude =
  //   //     (Provider.of<UserProvider>(context).userModel?.longitude)!;
  // }
}
