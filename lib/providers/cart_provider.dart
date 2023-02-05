import 'package:WeServeU/data/constants.dart';
import 'package:WeServeU/global.dart';
import 'package:WeServeU/model/cart_model.dart';
import 'package:WeServeU/model/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier {
  CartModel? cartModel;

  final List<CartModel> _cartsList = [];

  List<CartModel> get cartsList => [..._cartsList];
  bool uploading = false;

  bool loading = false;

  static double deliveryCharge = 0;

  String subTotal='0.0';

  String total() {
    if(_cartsList.isEmpty) return '0.0';
    var v = 0.0;
    if(_cartsList.isEmpty) v=0.0;
    var sub=0.0;
    for (var element in _cartsList) {
      v = v + element.price!;
      sub+=element.price!;
    }
    v += deliveryCharge;
    v += v * commission / 100;
    subTotal=sub.toStringAsFixed(2);
    return v.toStringAsFixed(2);
  }

  Future<void> getDelivery(String sellerUid) async{
    double returnVal=0;
    await FirebaseDatabase.instance.ref("users").child(sellerUid).child('charge').once().then((value){
      try {
        deliveryCharge = value.snapshot.value as double;
      }catch(e){
        deliveryCharge=int.parse(value.snapshot.value.toString()).toDouble();
      }
    });
  }

  getMyData() async {
    loading = true;

    try{
      await getDelivery(_cartsList.first.sellerUID!);
    }catch(e){
      print(e);
    }
    var ref = cartsRef()
        .orderByChild('buyerUID')
        .equalTo(FirebaseAuth.instance.currentUser!.uid);

    final data = (await ref.once()).snapshot;
    _cartsList.clear();
    _cartsList.addAll(data.children
        .map((e) => CartModel.fromMap(e.value as Map<dynamic, dynamic>)));

    ref.onChildAdded.listen((event) {
      final model =
          CartModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      int index = _cartsList.indexWhere((element) => element.key == model.key);
      if (index < 0) {
        _cartsList.add(model);
        notifyListeners();
      }
    });
    ref.onChildChanged.listen((event) {
      final model =
          CartModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      int index = _cartsList.indexWhere((element) => element.key == model.key);
      if (index >= 0) {
        _cartsList.removeAt(index);
        _cartsList.insert(index, model);
        notifyListeners();
      }
    });
    ref.onChildRemoved.listen((event) {
      final model =
          CartModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      int index = _cartsList.indexWhere((element) => element.key == model.key);
      if (index >= 0) {
        _cartsList.removeAt(index);
        notifyListeners();
      }
    });

    loading = false;
    notifyListeners();
  }

  DatabaseReference cartsRef() => firebaseDatabase.ref(cartReference);

  Future<String> addToCart(ProductModel productModel) async {
    var ref = await cartsRef()
        .orderByChild('buyerUID')
        .equalTo(FirebaseAuth.instance.currentUser!.uid)
        .once();
    CartModel cartModel = CartModel(
        buyerUID: FirebaseAuth.instance.currentUser!.uid,
        key: '',
        productKey: productModel.key,
        quantity: 0,
        date: DateTime.now(),
        price: 0,
        deliveryCharge: productModel.deliveryCharge,
        name: productModel.name,
        sellerUID: productModel.sellerUID);
    if (ref.snapshot.children.isNotEmpty) {
      var firstWhere = ref.snapshot.children.map((e) => e.value).firstWhere(
          (element) =>
              (element as Map<dynamic, dynamic>?)?['productKey'] ==
              cartModel.productKey,
          orElse: () => null) as Map<dynamic, dynamic>?;
      if (firstWhere != null) {
        cartModel = CartModel.fromMap(firstWhere);
      } else {
        final key = cartsRef().push().key;

        cartModel.key = key;
      }
      cartModel.quantity = cartModel.quantity! + 1;
      cartModel.price = cartModel.quantity! * productModel.offer!;
      cartsRef().child(cartModel.key!).update(cartModel.toMap());
    } else {
      final key = cartsRef().push().key;
      cartModel.key = key;
      cartModel.quantity = cartModel.quantity! + 1;
      cartModel.price = cartModel.quantity! * productModel.offer!;
      cartsRef().child(cartModel.key!).set(cartModel.toMap());
    }



    return cartModel.quantity == 1
        ? 'Item added to cart'
        : 'Item quantity is increased by 1';
  }

  Future<String> minusFromCart(ProductModel productModel) async {


    var ref = await cartsRef()
        .orderByChild('buyerUID')
        .equalTo(FirebaseAuth.instance.currentUser!.uid)
        .once();
    CartModel cartModel = CartModel(
        buyerUID: FirebaseAuth.instance.currentUser!.uid,
        key: '',
        productKey: productModel.key,
        quantity: 0,
        date: DateTime.now(),
        price: 0,
        deliveryCharge: productModel.deliveryCharge,
        name: productModel.name,
        sellerUID: productModel.sellerUID);
    if (ref.snapshot.children.isNotEmpty) {
      var firstWhere = ref.snapshot.children.map((e) => e.value).firstWhere(
              (element) =>
          (element as Map<dynamic, dynamic>?)?['productKey'] ==
              cartModel.productKey,
          orElse: () => null) as Map<dynamic, dynamic>?;
      if (firstWhere != null) {
        cartModel = CartModel.fromMap(firstWhere);
      } else {
        final key = cartsRef().push().key;

        cartModel.key = key;
      }
      cartModel.quantity = cartModel.quantity! - 1;
      if(cartModel.quantity! < 1) delete(cartModel.key!);
      cartModel.price = cartModel.quantity! * productModel.price!;
      cartsRef().child(cartModel.key!).update(cartModel.toMap());
    } else {
      final key = cartsRef().push().key;
      cartModel.key = key;
      cartModel.quantity = cartModel.quantity! - 1;
      cartModel.price = cartModel.quantity! * productModel.price!;
      cartsRef().child(cartModel.key!).set(cartModel.toMap());
      if(cartModel.quantity! < 1) delete(cartModel.key!);
    }


    return cartModel.quantity == 1
        ? 'Item added to cart'
        : 'Item quantity is decreased by 1';
  }


  Future<void> delete(String key) async {
    await cartsRef().child(key).remove();
    return;
  }

  Future<void> update(CartModel cartModel) async {
    await cartsRef().child(cartModel.key!).update(cartModel.toMap());
    return;
  }

  void logout() {
    cartModel = null;
    _cartsList.clear();
    notifyListeners();
  }
}
