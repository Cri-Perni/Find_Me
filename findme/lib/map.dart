import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findme/color/color.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

 class Map extends StatefulWidget {
  Map();
  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: StreamBuilder(
            stream: 
            FirebaseFirestore.instance.collection('userslocation').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator(color: AppColors.container.background,));
              }
              return GoogleMap(
                mapType: MapType.normal,
                markers:getMarkers(snapshot.data!.docs),
                initialCameraPosition: const CameraPosition(target: LatLng(0,0)),
                onMapCreated: (GoogleMapController controller ) async {
                  setState(() {
                    _controller = controller;
                  });
                },
              );
            }
          ));
  }


  Set<Marker> getMarkers(List<QueryDocumentSnapshot<Object?>> snapshot) {
    List<Marker> markers = [];

    for(int i = 0; i< snapshot.length; i++){
      markers.add(
        Marker(
        markerId: MarkerId(snapshot[i].id.toString()),
        position: LatLng(snapshot[i]['latitude'],snapshot[i]['longitude']),
        infoWindow: InfoWindow(title: snapshot[i]['name'])));
    }
    return Set<Marker>.from(markers);
  }

}