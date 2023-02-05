import 'dart:io';

import 'package:WeServeU/data/constants.dart';
import 'package:WeServeU/model/payment_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentProvider extends ChangeNotifier {
  PaymentModel? paymentModel;

  bool inited = false;

  init() async {
    final snapShot = await payment.get();
    if (snapShot.exists && snapShot.value != null) {
      paymentModel =
          PaymentModel.formMap(snapShot.value as Map<dynamic, dynamic>);
    }
    payment.onValue.listen((event) {
      if (event.snapshot.value != null) {
        paymentModel =
            PaymentModel.formMap(event.snapshot.value as Map<dynamic, dynamic>);
          notifyListeners();
      }
    });
    inited = true;
    notifyListeners();
  }

  DatabaseReference get payment => firebaseDatabase
      .ref(paymentReference)
      .child(FirebaseAuth.instance.currentUser!.uid);

    Future<String?> update(Map<String, dynamic> initData) async{
      try
      {
        await payment.update(initData);

        return null;
      }catch(e){
        return e.toString();
      }
    }







}
