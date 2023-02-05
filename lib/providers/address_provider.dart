import 'package:WeServeU/data/constants.dart';
import 'package:WeServeU/model/address_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class AddressProvider extends ChangeNotifier {
  AddressModel? addressModel;

  final List<AddressModel> _addressList = [];

  List<AddressModel> get addressList => [..._addressList];
  bool uploading = false;

  bool loading = false;

  init() async {
    loading = true;

    var ref = addressRef()
        .orderByChild('uid')
        .equalTo(FirebaseAuth.instance.currentUser!.uid);

    final data = (await ref.once()).snapshot;
    _addressList.clear();
    _addressList.addAll(data.children
        .map((e) => AddressModel.fromMap(e.value as Map<dynamic, dynamic>)));

    ref.onChildAdded.listen((event) {
      final model =
          AddressModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      int index =
          _addressList.indexWhere((element) => element.key == model.key);
      if (index < 0) {
        _addressList.add(model);
        notifyListeners();
      }
    });
    ref.onChildChanged.listen((event) {
      final model =
          AddressModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      int index =
          _addressList.indexWhere((element) => element.key == model.key);
      if (index >= 0) {
        _addressList.removeAt(index);
        _addressList.insert(index, model);
        notifyListeners();
      }
    });
    ref.onChildRemoved.listen((event) {
      final model =
          AddressModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      int index =
          _addressList.indexWhere((element) => element.key == model.key);
      if (index >= 0) {
        _addressList.removeAt(index);
        notifyListeners();
      }
    });
    loading = false;
    notifyListeners();
  }

  DatabaseReference addressRef() => firebaseDatabase.ref(addressReference);

  Future<void> delete(String key) async {
    await addressRef().child(key).remove();
    return;
  }

  Future<String?> update(AddressModel addressModel) async {


    try{
      if(addressModel.key==null){
        final key=addressRef().push().key;
        addressModel.key=key;
        addressModel.uid=FirebaseAuth.instance.currentUser!.uid;
      }

      await addressRef().child(addressModel.key!).update(addressModel.toMap());

    }catch(e){
      return e.toString();
    }
    return null;
  }

  void logout() {
    addressModel = null;
    _addressList.clear();
    notifyListeners();
  }

  void setAddressModel(AddressModel e) {
    addressModel=e;
    notifyListeners();
  }
}
