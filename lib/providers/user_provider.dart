import 'dart:io';

import 'package:WeServeU/data/constants.dart';
import 'package:WeServeU/global.dart';
import 'package:WeServeU/model/order_model.dart';
import 'package:WeServeU/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';

import '../DeepLinkService.dart';
import '../model/ImageModel.dart';
import '../screen/user_data_screen.dart';
import 'offer_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;

  bool inited = false;

  init() async {
    final snapShot = await user.get();
    if (snapShot.exists && snapShot.value != null) {
      userModel = UserModel.formMap(snapShot.value as Map<dynamic, dynamic>);
      await FirebaseDatabase.instance.ref('data').child('commission').get().then((value){
        try {
          commission = value.value as double;
        }catch(e){
          try{
            commission = (value.value as int).toDouble();
          }catch(r){

          }
        }
        print(commission);
      });
    }
    user.onValue.listen((event) {
      if (event.snapshot.value != null) {
        userModel =
            UserModel.formMap(event.snapshot.value as Map<dynamic, dynamic>);
        currency=userModel?.currencyCode??'JOD';
        notifyListeners();
      }
    });
    inited = true;
    notifyListeners();
  }

  addUser(Map<String, dynamic> initData) async {
    userModel = UserModel.formMap(initData);
    userModel!.uid = FirebaseAuth.instance.currentUser!.uid;
    userModel!.mobile = FirebaseAuth.instance.currentUser!.phoneNumber;
    userModel!.token=await FirebaseMessaging.instance.getToken();
    final referCode = CodeGenerator.generateCode('refer');
    final referLink = await DeepLinkService.instance?.createReferLink(referCode);
    userModel!.referal_code=referCode;
    userModel!.referal_link=referLink;
    userModel!.rewardBalance=0;
    await user.set(userModel!.toMap());
    notifyListeners();
  }

  DatabaseReference get user => firebaseDatabase
      .ref(userReference)
      .child(FirebaseAuth.instance.currentUser!.uid);

  void logout() {
    userModel = null;
    inited = false;
    notifyListeners();
  }

  updateName(String text) async {
    await user.update({'name': text});
  }

  updateShopType(String type) async{
    await user.update({'shopType': type});
  }
  updateShopStatus(String status) async{
    await user.update({'shopStatus': status});
  }
  updateCharge(double value) async{
    await user.update({'charge': value});
  }

  addOffer(String? path) async {
    if (path == null) {
      Fluttertoast.showToast(msg: 'Unknown error');
      return;
    }
    String? key= await FirebaseDatabase.instance.ref().child('offers').push().key;
    final res = await FirebaseStorage.instance
        .ref(user.path)
        .child(key!)
        .putFile(File(path));
    OfferModel model=OfferModel(shopUID: userModel!.uid,imageUrl:await res.ref.getDownloadURL() ,key: key);
    await FirebaseDatabase.instance.ref().child('offers').child(key).set(model.toMap());
  }

  updateLocation(double latitude,double longitude) async{
    await user.update({'latitude': latitude,'longitude': longitude});
  }
  setDateTime() async {
    await user.update({'dateTime': DateTime.now().toIso8601String()});
  }

  updateCity(String city,String country) async {
    await user.update({'city': city,'country': country});
  }

  updateToken() async {
    String? token=await FirebaseMessaging.instance.getToken();
    await user.update({'token': token});
  }
  Future<DataSnapshot> getName(String uid) async => await firebaseDatabase
        .ref(userReference).child(uid).child('name').get();

  Future<String> getArea(String uid) async{
    double latitude=await firebaseDatabase.ref(userReference).child(uid).child('latitude').once().then((value) => value.snapshot.value as double);
    double longitude=await firebaseDatabase.ref(userReference).child(uid).child('longitude').once().then((value) => value.snapshot.value as double);
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    return placemarks.first.street??'';
  }

  Future<double> getRating(String uid) async{
    await firebaseDatabase.ref(userReference).child('orders').orderByChild('sellerUid').equalTo(uid).once().then((value){
      int count=0;
      int rating=0;
      for(DataSnapshot snap in value.snapshot.children){
        rating+=OrderModel.fromMap(snap.value as Map).rating ?? 0;
      }
      if(count==0){
        return 0;
      } else {
        return rating/count;
      }
    });
    return 0;
  }
  updateCurrency(String code) async {
    await user.update({'currencyCode': code});
  }

  updateEmail(String email) async{
    await user.update({'email' : email});
  }
  updateBalance(int newBalance) async{
    await user.update({'balance': newBalance});
  }

  updateProfilePicture(String? path) async {
    if (path == null) {
      Fluttertoast.showToast(msg: 'Unknown error');
      return;
    }
    final res = await FirebaseStorage.instance
        .ref(user.path)
        .child('logo.png')
        .putFile(File(path));

    user.update({'photoUrl': await res.ref.getDownloadURL()});
  }

  addImage(String? path) async {
    if (path == null) {
      Fluttertoast.showToast(msg: 'Unknown error');
      return;
    }
    String? key= await FirebaseDatabase.instance.ref().child('images').push().key;
    final res = await FirebaseStorage.instance
        .ref(user.path)
        .child(key!)
        .putFile(File(path));
    ImageModel model=ImageModel(shopUID: userModel!.uid,imageUrl:await res.ref.getDownloadURL() ,key: key);
    await FirebaseDatabase.instance.ref().child('images').child(key).set(model.toMap());
  }

  deletePath() async {
    var delete = FirebaseStorage.instance.ref(user.path).child('logo.png');
    try {
      await delete.delete();
      user.update({'photoUrl': null});
    } catch (e) {}
  }

    updateRole(String role) async{
      await user.update({'role': role});
    }
}
