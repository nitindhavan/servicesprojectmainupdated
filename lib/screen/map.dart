import 'package:WeServeU/global.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MyMap extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MyMap> {

  late GoogleMapController mapController;
  //static LatLng _center = LatLng(-15.4630239974464, 28.363397732282127);
  static LatLng _initialPosition=LatLng(0, 0);
  final Set<Marker> _markers = {};
  static  LatLng _lastMapPosition = _initialPosition;
  String mapKey='';

  bool once=false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }
  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _initialPosition = LatLng(position.latitude, position.longitude);
      setState(() {
        _markers.add(
            Marker(
                markerId: MarkerId(_lastMapPosition.toString()),
                position: _lastMapPosition,
                draggable: true,
                infoWindow: InfoWindow(
                    title: "Your Location",
                    snippet: "This is a snippet",
                    onTap: (){
                    }
                ),
                onDragEnd: (latlng){
                  setState(() {
                    _lastMapPosition=LatLng(latlng.latitude, latlng.longitude);
                  });
                },

                icon: BitmapDescriptor.defaultMarker));
      });
  }


  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController=controller;
    });
  }

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
  void _onGetLocation() async {
    Position position=await moveToCurrent();
    _lastMapPosition = LatLng(position.latitude, position.longitude);
    _markers.clear();
    setState(() {
      latitude=_lastMapPosition.latitude;
      longitude=_lastMapPosition.longitude;
      _markers.add(
          Marker(
            markerId: MarkerId(_lastMapPosition.toString()),
            position: _lastMapPosition,
            infoWindow: InfoWindow(
                title: "Your Location",
                snippet: "This is your location",
                onTap: (){
                }
            ),
            onTap: (){
            },

            icon: BitmapDescriptor.defaultMarker,));
    });
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    _markers.remove(_markers.first);
    setState(() {
      latitude=_lastMapPosition.latitude;
      longitude=_lastMapPosition.longitude;
      _markers.add(
          Marker(
              markerId: MarkerId(_lastMapPosition.toString()),
              position: _lastMapPosition,
              infoWindow: InfoWindow(
                  title: "Your Location",
                  snippet: "This is your location",
                  onTap: (){
                  }
              ),
              onTap: (){
              },

              icon: BitmapDescriptor.defaultMarker,));
    });
  }

  Widget mapButton(Function() function, Icon icon , Color color) {
    return RawMaterialButton(
      onPressed: function,
      child: icon,
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: const EdgeInsets.all(7.0),
    );
  }
  @override
  Widget build(BuildContext context) {
    _getUserLocation();
    return Scaffold(
      key: Key(mapKey),
      body: _initialPosition.latitude==0 && _initialPosition.longitude==0  ? Container(child: Center(child:Text('loading map..', style: TextStyle(fontFamily: 'Avenir-Medium', color: Colors.grey[400]),),),) : Container(
        child: Stack(children: <Widget>[
          GoogleMap(
            markers: _markers,
            mapType: _currentMapType,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 15.4746,
            ),
            onMapCreated: _onMapCreated,
            zoomGesturesEnabled: true,
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
            compassEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
                margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    mapButton(
                        _onMapTypeButtonPressed,
                        Icon(
                          Icons.view_array,
                        ),
                        Colors.green),
                    mapButton(
                      _onGetLocation, Icon(Icons.gps_fixed), Colors.red),
                  ],
                )),
          )
        ]),
      ),
    );
  }



  Future<Position> moveToCurrent() async{
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }
}