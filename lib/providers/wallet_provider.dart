import 'dart:async';
import 'dart:io';

import 'package:WeServeU/data/constants.dart';
import 'package:WeServeU/model/wallet_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WalletProvider extends ChangeNotifier {
  WalletModel walletModel = WalletModel(amount: 0.0);
  ///testing
  bool inited = false;

  init() async {
    // await wallet.remove();
    final snapShot = await wallet.get();
    if (snapShot.exists && snapShot.value != null) {
      walletModel =
          WalletModel.formMap(snapShot.value as Map<dynamic, dynamic>);
    }
    wallet.onValue.listen((event) {
      if (event.snapshot.value != null) {
        walletModel =
            WalletModel.formMap(event.snapshot.value as Map<dynamic, dynamic>);
         notifyListeners();
      }
    });
    inited = true;
    notifyListeners();
  }

  credit(dynamic amount) async {
    walletModel = WalletModel(currencyCode: currency, amount: amount,);
    walletModel.uid = FirebaseAuth.instance.currentUser!.uid;
    walletModel.mobile = FirebaseAuth.instance.currentUser!.phoneNumber;
    await wallet.set(walletModel.toMap());
    notifyListeners();
  }

  DatabaseReference get wallet => firebaseDatabase
      .ref('wallets')
      .child(FirebaseAuth.instance.currentUser!.uid);

  void logout() {
    inited = false;
    notifyListeners();
  }
}
