// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findme/page/friends_map.dart';
import 'package:findme/service/user.dart';
import 'package:findme/service/request_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:findme/color/color.dart';

import '../service/user.dart';

class Home extends StatefulWidget {
  Home({super.key,required this.myuser});

  MyUser myuser;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>  with AutomaticKeepAliveClientMixin<Home>{
  //List<String> docFriendsID = [];
  bool isOn = false;
  late GoogleMapController mapController;
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  
  @override
  void initState() {
    super.initState();
    //_getFriends();

    //_animateToUser();
  }

  @override
  bool get wantKeepAlive => true;

  /*void _getFriends() async {
    FirebaseFirestore firepath = FirebaseFirestore.instance;
    firepath
        .collection('friends')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('myfriends')
        .get()
        .then((friendsID) => friendsID.docs.forEach(
              (friendID) {
                docFriendsID.add(friendID.reference.id);
                print(friendID.reference.id);
              },
            ));
    // ignore: avoid_print
    print(docFriendsID.length);
  }*/

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance
          .collection('userslocation')
          .doc(widget.myuser.id)
          .set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': widget.myuser.username,
        'showPosition': true,
      }, SetOptions(merge: true));
    });
  }

  _stopListening() async {
    /* await FirebaseFirestore.instance.collection('userslocation').doc(FirebaseAuth.instance.currentUser?.uid).set({
      'showPosition': false,
    },SetOptions(merge: true));*/
    _locationSubscription?.cancel();
    FirebaseFirestore.instance
        .collection('userslocation')
        .doc(widget.myuser.id)
        .delete();
    setState(() {
      _locationSubscription = null;
    });
  }

 Future _requestPermission() async {
    try {
      if (location.hasPermission() == PermissionStatus.granted) {
        location.changeSettings(
            interval: 300, accuracy: loc.LocationAccuracy.high);
        location.enableBackgroundMode(enable: true);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  /*_onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }*/

  void logOut() async{
    FirebaseAuth.instance.signOut();
  }

  /*void _animateToUser() async {
    LocationData pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(pos.latitude!, pos.longitude!), zoom: 15)));
  }*/

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    _requestPermission();
    //_animateToUser();

    return Scaffold(
      backgroundColor: AppColors.scaffold.background,
      body: Stack(
        children: [
          Container(
            height: size.height * .32,
            decoration: BoxDecoration(
                color: AppColors.container.background,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                // ignore: prefer_const_literals_to_create_immutables, prefer_const_constructors
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 6.0,
                      offset: Offset(0.0, 1.0))
                ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  CircleAvatar(
                      backgroundColor: Colors.white30,
                      radius: size.height * .07,
                      backgroundImage: AssetImage('assets/splash.png')),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Container(
                    width: size.width * 0.70,
                    height: size.height * 0.15,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 6.0,
                              offset: Offset(0.0, 1.0))
                        ]),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  widget.myuser.username
                                      .toString(),
                                  style: TextStyle(fontSize: 24))
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.myuser.email.toString(),
                                  style: TextStyle(fontSize: 16))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.white,
                        child: SizedBox(
                          height: size.height * 0.12,
                          width: size.width * 0.24,
                          child: Column(children: [
                            SizedBox(
                              height: size.height * 0.018,
                            ),
                            const Text(
                              'Enable location',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.001,
                            ),
                            Switch(
                                value: isOn,
                                activeColor:AppColors.container.background,
                                onChanged: (bool value) {
                                  if (value) {
                                    _listenLocation();
                                  } else {
                                    _stopListening();
                                  }
                                  setState(() {
                                    isOn = value;
                                  });
                                }),
                          ]),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.2,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 4,
                        color: Colors.white,
                        child: SizedBox(
                          height: size.height * 0.12,
                          width: size.width * 0.24,
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.018,
                              ),
                              Text('Friends'),
                              SizedBox(
                                height: size.height * 0.015,
                              ),
                              
                              FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('friends')
                                      .doc(widget.myuser.id)
                                      .collection('myfriends')
                                      .get(),
                                  builder: ((context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Text(
                                        snapshot.data!.docs.length.toString(),
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }
                                    return SizedBox(
                                      height: 20 ,
                                      width: 20,
                                      child:CircularProgressIndicator(
                                      color: AppColors.container.background,
                                    ));
                                  }))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  //TextButton(onPressed:_LogOut , child: Text('Logout')),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 4,
                    color: Colors.white,
                    child: SizedBox(
                      width: size.width * 0.8,
                      height: size.height * 0.26,
                      child: Center(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FriendsMap(myuser: widget.myuser,)),
                      ),
                    ),
                  ),
                ],
              )
           )
          ],
          )
        ],
      ),
    );
  }
}
