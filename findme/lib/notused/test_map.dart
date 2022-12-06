import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TestMap extends StatefulWidget {
  const TestMap({super.key});

  @override
  State<TestMap> createState() => _TestMapState();
}


 late GoogleMapController _controller;

class _TestMapState extends State<TestMap> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }





  @override
  Widget build(BuildContext context) {

    return Container(child:StreamBuilder(
            stream: FirebaseFirestore.instance.collection('userslocation').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator());
              }
              return GoogleMap(
                mapType: MapType.normal,
                markers:getMarkers(snapshot.data!.docs),
                initialCameraPosition: CameraPosition(target: LatLng(snapshot.data!.docs.singleWhere(
                           (element) => element.id == FirebaseAuth.instance.currentUser!.uid)['latitude'],
                            snapshot.data!.docs.singleWhere((element) => 
                            element.id == FirebaseAuth.instance.currentUser!.uid)['longitude'],),zoom: 14.47),
                myLocationEnabled: true,
                onMapCreated: (GoogleMapController controller ) async {
                  setState(() {
                    _controller = controller;
                  });
                },
              );
            }
          )
    );
  }

  

  Set<Marker> getMarkers(List<QueryDocumentSnapshot<Object?>> snapshot) {
    List<Marker> markers = [];

    for(int i = 0; i< snapshot.length; i++){
      if(snapshot[i].id != FirebaseAuth.instance.currentUser!.uid){
      markers.add(
        Marker(
        markerId: MarkerId(snapshot[i].id.toString()),
        position: LatLng(snapshot[i]['latitude'],snapshot[i]['longitude']),
        infoWindow: InfoWindow(title: snapshot[i]['name'])));
    }}
    return Set<Marker>.from(markers);
  }

}