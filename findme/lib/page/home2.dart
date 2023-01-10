import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findme/page/Friend/friends.dart';
import 'package:findme/page/drawer.dart';
import 'package:findme/page/friends_map.dart';
import 'package:findme/service/auth.dart';
import 'package:findme/service/user.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:findme/color/color.dart';

class Home2 extends StatefulWidget {
  Home2({super.key, required this.myuser});

  MyUser myuser;

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  bool isOn = false;
  final loc.Location location = loc.Location();

  StreamSubscription<loc.LocationData>? _locationSubscription;

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _requestPermission();
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        backgroundColor: AppColors.scaffold.background,
        body: Stack(children: [
          Container(
            height: size.height * .30,
            decoration: BoxDecoration(
                color: AppColors.container.background,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                // ignore: prefer_const_literals_to_create_immutables
                boxShadow: [
                  const BoxShadow(
                      color: Colors.grey,
                      blurRadius: 6.0,
                      offset: Offset(0.0, 1.0))
                ]),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(size.width*.03),
              child: Column(
                children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                    onTap: () {
                      _stopListening();
                              Auth().signOut();
                              // ignore: avoid_print
                              print('LogOut.........');
                    },child:
                     const Icon(Icons.logout,color: Colors.white,),
                     )
                      ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.075,
                    ),
                    CircleAvatar(
                        backgroundColor: Colors.white30,
                        radius: size.height * .065,
                        backgroundImage: AssetImage('assets/splash.png')),
                    SizedBox(
                      height: size.height * 0.035,
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
                                Text(widget.myuser.username.toString(),
                                    style: const TextStyle(fontSize: 24))
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(widget.myuser.email.toString(),
                                    style: const TextStyle(fontSize: 16))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              // ignore: sized_box_for_whitespace
                              child: Container(
                                height: size.height * .12,
                                width: size.width * .24,
                                child: Column(children: [
                                  Container(
                                      height: size.height * .035,
                                      width: size.width * .24,
                                      decoration: BoxDecoration(
                                        color: AppColors.container.background,
                                      ),
                                      // ignore: prefer_const_constructors
                                      child: Center(
                                          // ignore: prefer_const_constructors
                                          child: Text(
                                        'Enable Location',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ))),
                                  Container(
                                    height: size.height * .073,
                                    child: Switch(
                                        value: isOn,
                                        activeColor:
                                            AppColors.container.background,
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
                                  )
                                ]),
                              ),
                            )),
                        SizedBox(
                          width: size.width * .2,
                        ),
                        Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              // ignore: sized_box_for_whitespace
                              child: Container(
                                height: size.height * .12,
                                width: size.width * .24,
                                child: Column(children: [
                                  Container(
                                      height: size.height * .035,
                                      width: size.width * .24,
                                      decoration: BoxDecoration(
                                        color: AppColors.container.background,
                                      ),
                                      // ignore: prefer_const_constructors
                                      child: Center(
                                          // ignore: prefer_const_constructors
                                          child: Text(
                                        'Friends',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ))),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  Container(
                                      height: size.height * .060,
                                      width: size.width * .24,
                                      child: Column(
                                        children: [
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
                                                    snapshot.data!.docs.length
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  );
                                                }
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: AppColors
                                                        .container.background,
                                                  ),
                                                );
                                              })),
                                        ],
                                      ))
                                ]),
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    //TextButton(onPressed:_LogOut , child: Text('Logout')),
                    Card(
                        margin: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 4,
                        color: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: size.height * .28,
                            width: size.width * 0.8,
                            child: Center(
                              child: FriendsMap(
                                myuser: widget.myuser,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              )
            ],
          )
        ]));
  }
}
