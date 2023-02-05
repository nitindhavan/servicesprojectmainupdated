import 'package:WeServeU/data/constants.dart';
import 'package:WeServeU/model/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsProvider extends ChangeNotifier {
  int notifications = 0;
  List<OrderModel> providerNotifications = [];

  init() async {
    final notificationRef = firebaseDatabase
        .ref('notifications')
        .orderByChild('sellerUID')
        .equalTo(FirebaseAuth.instance.currentUser!.uid);
    notificationRef.onChildAdded.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
        int index = providerNotifications
            .indexWhere((element) => element.key == data['key']);
        if (index < 0) {
          providerNotifications.add(OrderModel.fromMap(data));
          notifyListeners();
        }
    });

    notificationRef.onChildChanged.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      if (data['sellerUID'] == FirebaseAuth.instance.currentUser!.uid) {
        int index = providerNotifications
            .indexWhere((element) => element.key == data['key']);
        if (index >= 0) {
          providerNotifications.removeAt(index);
          providerNotifications.insert(index, OrderModel.fromMap(data));
          notifyListeners();
        }
      }
    });

    notificationRef.onChildRemoved.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      if (data['sellerUID'] == FirebaseAuth.instance.currentUser!.uid) {
        int index = providerNotifications
            .indexWhere((element) => element.key == data['key']);
        if (index >= 0) {
          providerNotifications.removeAt(index);
          notifyListeners();
        }
      }
    });
  }
}
