import 'package:WeServeU/data/constants.dart';
import 'package:WeServeU/model/address_model.dart';
import 'package:WeServeU/model/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import '../model/order_model.dart';

class ClientOrdersProvider extends ChangeNotifier {
  OrderModel? orderModel;

  final List<OrderModel> _ordersList = [];

  List<OrderModel> get ordersList => [..._ordersList];
  bool uploading = false;

  bool loading = false;

  getMyData() async {
    loading = true;

    var ref = ordersRef()
        .orderByChild('buyerUID')
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
        required AddressModel addressModel}) async {
    loading = true;
    notifyListeners();
    for (var element in cartsList) {
      element.date = DateTime.now();

      OrderModel orderModel = OrderModel.fromMap(element.toMap());
      orderModel.paymentMethod = paymentMethod;
      orderModel.paymentStatus = paymentStatus;
      orderModel.orderId = orderId;
      orderModel.paymentId = paymentId;
      orderModel.rating=0;
      orderModel.addressModel = addressModel;
      orderModel.price = (orderModel.quantity! * orderModel.price!) +
          (orderModel.deliveryCharge ?? 0);
      orderModel.buyerUID = FirebaseAuth.instance.currentUser!.uid;
      orderModel.signature = signature;
      orderModel.date = DateTime.now();
      orderModel.shippingStatus='Pending';
      if (paymentStatus == 'Paid') {}
      await ordersRef().child(element.key!).set(orderModel.toMap());
      wallet(orderModel.sellerUID!).runTransaction((value) => Transaction.success(((value as num?)??0)+(orderModel.price??0)));
      await cartsRef().child(element.key!).remove();
    }

    loading=false;
    notifyListeners();
  }

  void logout() {
    orderModel = null;
    _ordersList.clear();
    notifyListeners();
  }

  updateShippingStatus(
      {required String orderKey, required String status}) async {
    await ordersRef()
        .child(orderKey)
        .update({'shippingStatus': status});
  }

  DatabaseReference wallet(String uid) =>
      firebaseDatabase.ref(userWalletReference).child(uid).child('amount');
}

DatabaseReference ordersRef() => firebaseDatabase.ref(orderReference);

DatabaseReference cartsRef() => firebaseDatabase.ref(cartReference);
