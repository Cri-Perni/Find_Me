
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findme/color/color.dart';
import 'package:findme/service/request_service.dart';
import 'package:findme/service/user.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';


// ignore: must_be_immutable
class FriendsMap extends StatefulWidget {
  FriendsMap( {super.key, required this.myuser});

  MyUser myuser;

  @override
  State<FriendsMap> createState() => _FriendsMapState();
}

class _FriendsMapState extends State<FriendsMap> {

  final LatLng currentPosition = const LatLng(0, 0);
  final loc.Location location = loc.Location();
  List<String> docFriendsID = [];
  

  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _animateToUser();
    /*Future.delayed(const Duration(seconds: 10), () {
    Timer.periodic(Duration(seconds: 1), (Timer t) => _animateToUser());});*/
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('userslocation').snapshots(),
      builder: ((context, snapshot) {
        if(snapshot.hasData){
        return Stack(children: [
          GoogleMap(
          initialCameraPosition: const CameraPosition(target: LatLng(0,0)),
          zoomControlsEnabled: false,
          markers: getMarkers(snapshot.data!.docs),
          myLocationEnabled: true,
        onMapCreated: _onMapCreated,
    ),
    ]); }else{
      return CircularProgressIndicator(color: AppColors.container.background,);
    }
  }));

  }

   _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  _animateToUser() async {  
    LocationData pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(pos.latitude!, pos.longitude!), zoom: 15)));
  }

  Set<Marker> getMarkers(List<QueryDocumentSnapshot<Object?>> snapshot) {

    List<Marker> markers = [];
    for(int i = 0; i< snapshot.length; i++){
      if(snapshot[i].id != widget.myuser.id){
        if(widget.myuser.friends!.contains(snapshot[i].id)) {
          markers.add(
         Marker(
           markerId: MarkerId(snapshot[i].id.toString()),
           position: LatLng(snapshot[i]['latitude'],snapshot[i]['longitude']),
           infoWindow: InfoWindow(title: snapshot[i]['name'])));
        }
      }}
    return Set<Marker>.from(markers);
  }
  
}