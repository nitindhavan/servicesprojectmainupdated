import 'dart:convert';

import 'package:WeServeU/data/constants.dart';
import 'package:WeServeU/model/address_model.dart';
import 'package:WeServeU/model/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import '../model/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class OrdersProvider extends ChangeNotifier {

  OrderModel? orderModel;

  final List<OrderModel> _ordersList = [];

  List<OrderModel> get ordersList => [..._ordersList];
  bool uploading = false;

  bool loading = false;

  getMyData() async {
    loading = true;
    var ref = ordersRef()
        .orderByChild('sellerUID')
        .equalTo(FirebaseAuth.instance.currentUser!.uid);

    final data = (await ref.once()).snapshot;
    _ordersList.clear();
    _ordersList.addAll(data.children
        .map((e) => OrderModel.fromMap(e.value as Map<dynamic, dynamic>)));

    ref.onChildAdded.listen((event) {
      final model =
          OrderModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      int index = _ordersList.indexWhere((element) => element.key == model.key);
      if (index < 0) {
        _ordersList.add(model);
        notifyListeners();
      }
    });
    ref.onChildChanged.listen((event) {
      final model =
          OrderModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      int index = _ordersList.indexWhere((element) => element.key == model.key);
      if (index >= 0) {
        _ordersList.removeAt(index);
        _ordersList.insert(index, model);
        notifyListeners();
      }
    });
    ref.onChildRemoved.listen((event) {
      final model =
          OrderModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      int index = _ordersList.indexWhere((element) => element.key == model.key);
      if (index >= 0) {
        _ordersList.removeAt(index);
        notifyListeners();
      }
    });
    loading = false;
    notifyListeners();
  }

  Future<void> delete(String key) async {
    await ordersRef().child(key).remove();
    return;
  }

  Future<void> update(OrderModel orderModel) async {
    await ordersRef().child(orderModel.key!).update(orderModel.toMap());
    return;
  }

  order(List<CartModel> cartsList,
      {String? paymentMethod,
      String? paymentStatus,
      String? paymentId,
      String? orderId,
      String? signature,
        required double deliveryCharge,
      required AddressModel addressModel, required double amount,required String sellerUID,required String note}) async {
    loading = true;
    notifyListeners();
    DateTime date=DateTime.now();
    for (var element in cartsList) {
      element.date = date;
      OrderModel orderModel = OrderModel.fromMap(element.toMap());
      orderModel.paymentMethod = paymentMethod;
      orderModel.paymentStatus = paymentStatus;
      orderModel.orderId = orderId;
      orderModel.paymentId = paymentId;
      orderModel.rating=0;
      orderModel.deliveryCharge=deliveryCharge;
      orderModel.addressModel = addressModel;
      orderModel.buyerUID = FirebaseAuth.instance.currentUser!.uid;
      orderModel.signature = signature;
      orderModel.date = date;
      orderModel.shippingStatus='Pending';
      orderModel.appEarning=amount;
      orderModel.note=note;
      if (paymentStatus == 'Paid') {}
      await ordersRef().child(element.key!).set(orderModel.toMap());
      wallet(orderModel.sellerUID!).runTransaction((value) => Transaction.success(((value as num?)??0)+(orderModel.price??0)));
      await cartsRef().child(element.key!).remove();
      await FirebaseDatabase.instance.ref().child('notifications').child(element.key!).set(orderModel.toMap()).then((value){

      });
    }
    loading=false;
    FirebaseDatabase.instance.ref('users').child(sellerUID).child('token').once().then((value) async{
      String? _token=value.snapshot.value as String;
      print(_token);
      // FirebaseMessaging.instance.requestPermission();
      // sendPushMessage(_token);
      callOnFcmApiSendPushNotifications([_token]);
    }).then((value){
      FirebaseDatabase.instance.ref('users').child(FirebaseAuth.instance.currentUser!.uid).child('token').once().then((value) async{
        String? _token=await value.snapshot.value as String;
        // print(_token);
        // FirebaseMessaging.instance.requestPermission();
        // sendPushMessage(_token);
        callOnFcmApiSendPushNotifications([_token]);
      });
    });
    notifyListeners();
  }

  void logout() {
    orderModel = null;
    _ordersList.clear();
    notifyListeners();
  }

  updateShippingStatus(
      {required String orderKey, required String status,required OrderModel model}) async {
    await ordersRef()
        .child(orderKey)
        .update({'shippingStatus': status});
    if(status=='Delivered')await ordersRef()
        .child(orderKey)
        .update({'driverUID': FirebaseAuth.instance.currentUser!.uid});
    String key=await FirebaseDatabase.instance.ref().child('notifications').push().key!;
    model.shippingStatus=status;
    await FirebaseDatabase.instance.ref().child('notifications').child(key).set(model.toMap());
  }
  updatePaymentStatus(
      {required String orderKey, required String status,required OrderModel model}) async {
    await ordersRef()
        .child(orderKey)
        .update({'paymentStatus': status});
  }

  DatabaseReference wallet(String uid) =>
      firebaseDatabase.ref(userWalletReference).child(uid).child('amount');
}

Future<bool> callOnFcmApiSendPushNotifications(List <String> userToken) async {

  final postUrl = 'https://fcm.googleapis.com/fcm/send';
  
  final data = {
    "registration_ids" : userToken,
    "collapse_key" : "type_a",
    "notification" : {
      "title": 'Order placed!',
      "body" : 'New order is placed',
    }
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization': 'key=AAAAPrlEjcw:APA91bEGV--lCW4RuO2lM_OCRneq0uIEsMbeVV2BS2PMj6E83P2f2HnqviLAREWsl1j8t6E9ETuvwW-xSJwOYfSpseJ2FekzvxKeE3dWIxlK3sDipU4mRk_pks2cXB6y_ARNDDvi-uQ_' // 'key=YOUR_SERVER_KEY'
  };

  final response = await http.post(Uri.parse(postUrl),
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers);

  if (response.statusCode == 200) {
    // on success do sth
    print('test ok push CFM');
    return true;
  } else {
    print(' CFM error');
    // on failure do sth
    return false;
  }
}


DatabaseReference ordersRef() => firebaseDatabase.ref(orderReference);

DatabaseReference cartsRef() => firebaseDatabase.ref(cartReference);
