
import 'dart:async';

import 'package:WeServeU/providers/running_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
class GoogleMapView extends StatefulWidget{


  const GoogleMapView({Key? key }) : super(key: key);

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    return   Consumer<RunningStatusProvider>(
      builder: (context,value,_) {
        return Scaffold(
          body: GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
               target: LatLng(value.mapModel.latitude, value.mapModel.longitude),
              zoom: 10

            ),

            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

        );
      }
    );
  }
}