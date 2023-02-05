
import 'package:WeServeU/model/map_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../data/constants.dart';

class RunningStatusProvider extends ChangeNotifier{

  DatabaseReference get runningRef {
    return firebaseDatabase
        .ref(locationReference)
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('running');
  }

  init(){
    runningRef.onValue.listen((event) {
      if(event.snapshot.value!=null){
        _mapModel=MapModel.fromMap(event.snapshot.value as Map<dynamic,dynamic>);
      }
    });
  }

  MapModel _mapModel=const MapModel();

  MapModel get mapModel => _mapModel;

  set mapModel(MapModel value) {
    _mapModel = value;
    runningRef.update(_mapModel.toJson());
  }




}