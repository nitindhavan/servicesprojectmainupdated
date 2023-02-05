import 'dart:async';
import 'dart:io';

import 'package:WeServeU/data/constants.dart';
import 'package:WeServeU/model/map_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import '../model/product_model.dart';

class ProductProvider extends ChangeNotifier {
  ProductModel? productModel;

  final List<ProductModel> _myList = [];
  final List<ProductModel> _allList = [];

  List<ProductModel> get allList => [..._allList];

  bool _driving = false;

  bool get driving => _driving;

  set driving(bool value) {
    _driving = value;
    notifyListeners();
    setRunningLocation();
  }

  List<ProductModel> get myList => [..._myList];
  List<bool> uploading = [false,false,false,false,false];
  List<bool> uploadingVideo=[false,false];

  setPhoto(String path,int index) async {
    uploading[index] = true;
    notifyListeners();
    try {
      final ref = currentProductRef;
      final url =
          await FirebaseStorage.instance.ref('${ref.path}$index').putFile(File(path));

      if(productModel!.photoUrl==null) productModel!.photoUrl=[];
      var list=productModel!.photoUrl!.toList();
      list.add(await url.ref.getDownloadURL());
      productModel!.photoUrl=list;
      ref.update(productModel!.toMap());
      uploading[index] = false;

      return productModel!.photoUrl![index];
    }
    catch (e) {
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
    }
    uploading[index] = false;
    return null;
  }
  setVideo(String path,int index) async {
    uploadingVideo[index] = true;
    notifyListeners();
    try {
      final ref = currentProductRef;
      final url =
          await FirebaseStorage.instance.ref('${ref.path}video$index.mp4').putFile(File(path));
      if(productModel!.videoUrl==null) productModel!.videoUrl=[];
      var list=productModel!.videoUrl!.toList();
      list.add(await url.ref.getDownloadURL());
      productModel!.videoUrl=list;
      print(productModel!.videoUrl.toString());
      ref.update(productModel!.toMap());
      uploadingVideo[index] = false;

      return list[index];
    }
    catch (e) {
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
    }
    uploadingVideo[index] = false;
    return null;
  }

  bool created = false;
  bool loading = false;

  create() {
    try {
      final ref = firebaseDatabase.ref(productsReferenceWithCurrency).child(currency).push();
      productModel = ProductModel(
          sellerUID: FirebaseAuth.instance.currentUser!.uid, key: ref.key, currency: currency);
      ref.set(productModel!.toMap());

      /// [productModel.latitude]
      /// [productModel.longitude]
      /// [productModel.currency]

      created = true;
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<String?> update(Map<String, dynamic> initData) async {
    String? error;
    loading = true;
    notifyListeners();
    try {
      final map = productModel!.toMap();
      map.addAll(initData);

      await currentProductRef.update(map);
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
    return error;
  }

  DatabaseReference get currentProductRef =>
      firebaseDatabase.ref(productsReferenceWithCurrency).child(currency).child(productModel!.key!);


  getMyData() async {
    loading = true;
    driving = (await drivingRef.get()).value as bool? ?? false;
    var ref = firebaseDatabase.ref(productsReferenceWithCurrency).child(currency)
        .orderByChild('sellerUID')
        .equalTo(FirebaseAuth.instance.currentUser!.uid);
    final data = (await ref.once()).snapshot;
    _myList.clear();
    _myList.addAll(data.children
        .map((e) => ProductModel.fromMap(e.value as Map<dynamic, dynamic>)));

    ref.onChildAdded.listen((event) {
      final model =
          ProductModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      int index = _myList.indexWhere((element) => element.key == model.key);
      if (index < 0) {
        _myList.add(model);
        notifyListeners();
      }
    });
    ref.onChildChanged.listen((event) {
      final model =
          ProductModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      int index = _myList.indexWhere((element) => element.key == model.key);
      if (index >= 0) {
        _myList.removeAt(index);
        _myList.insert(index, model);
        notifyListeners();
      }
    });
    ref.onChildRemoved.listen((event) {
      final model =
          ProductModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      int index = _myList.indexWhere((element) => element.key == model.key);
      if (index >= 0) {
        _myList.removeAt(index);
        notifyListeners();
      }
    });
    loading = false;
    notifyListeners();
  }

  getAllData() async {
    loading = true;

    var ref = firebaseDatabase.ref(productsReferenceWithCurrency).child(currency)
        .orderByChild('live')
        .equalTo(true);


    final data = (await ref.once()).snapshot;
    _allList.clear();
    _allList.addAll(data.children
        .map((e) => ProductModel.fromMap(e.value as Map<dynamic, dynamic>)));

    ref.onChildAdded.listen((event) {
      final model =
          ProductModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      int index = _allList.indexWhere((element) => element.key == model.key);
      if (index < 0 &&(model.live??false)&&model.currency==currency) {
        _allList.add(model);
        notifyListeners();
      }
    });
    ref.onChildChanged.listen((event) {
      final model =
          ProductModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      int index = _allList.indexWhere((element) => element.key == model.key);
      if (index >= 0) {
        _allList.removeAt(index);
        _allList.insert(index, model);
        notifyListeners();
      }
    });
    ref.onChildRemoved.listen((event) {
      final model =
          ProductModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      int index = _allList.indexWhere((element) => element.key == model.key);
      if (index >= 0) {
        _allList.removeAt(index);
        notifyListeners();
      }
    });
    loading = false;
    notifyListeners();
  }

  delete() async{
    currentProductRef.remove();
  }

  Timer? timer;
  MapModel? position;

  setRunningLocation() async {
    drivingRef.set(driving);
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (driving) {
        updateLocation();
      } else {
        timer.cancel();
      }
    });
  }

  DatabaseReference get runningRef {
    return firebaseDatabase
        .ref(locationReference)
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('running');
  }

  DatabaseReference get drivingRef {
    return firebaseDatabase
        .ref(locationReference)
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('driving');
  }

  updateLocation() async {
    final newPos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // print(newPos.toJson().toString());
    if (position == null) {
      final map = (await runningRef.get()).value;
      if(map==null){
        position=MapModel.fromMap(newPos.toJson());
        runningRef.update(newPos.toJson());
      }else{
        position=MapModel.fromMap(map as Map<dynamic,dynamic>);
      }
     }

    if (!(position!.longitude == newPos.longitude &&
        position!.latitude == newPos.latitude)) {
       runningRef.update(newPos.toJson());
    }

  }

  void logout() {
    productModel=null;
    _allList.clear();
    _myList.clear();
    notifyListeners();
  }
  Future<DataSnapshot> getProductName(String productKey) {
    return firebaseDatabase
        .ref(productsReferenceWithCurrency)
        .child(currency)
        .child(productKey).child('name')
        .get();
  }
  Future<DataSnapshot> getProductType(String productKey) {
    return firebaseDatabase
        .ref(productsReferenceWithCurrency)
        .child(currency)
        .child(productKey).child('type')
        .get();
  }
}
