import 'dart:async';

import 'package:findme/page/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import '../map.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:location/location.dart' as loc;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final loc.Location location = loc.Location();
  bool isOn = false;
  List<String> docFriendsID=[];

  StreamSubscription<loc.LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  _GetFriends() async{
    FirebaseFirestore _firepath = FirebaseFirestore.instance;
    _firepath.collection('friends')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('myfriends')
    .get().then((friendsID) => 
    friendsID.docs.forEach((friendID) {
      docFriendsID.add(friendID.reference.id);
      
    }));
  }

  _getLocation() async {
    try{
      final loc.LocationData _locationresult = await location.getLocation();
      await FirebaseFirestore.instance.collection('userslocation').doc(FirebaseAuth.instance.currentUser?.uid).set({
        'latitude':_locationresult.latitude,
        'longitude':_locationresult.longitude,
        'name': FirebaseAuth.instance.currentUser?.displayName.toString(),
        'showPosition': true,
      },SetOptions(merge: true));
    }catch(e){
      print(e);
    }
  }

  Future<void> _listenLocation() async{
    _locationSubscription = location.onLocationChanged.handleError((onError){
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async{
      await FirebaseFirestore.instance.collection('userslocation').doc(FirebaseAuth.instance.currentUser?.uid).set({
        'latitude':currentlocation.latitude,
        'longitude':currentlocation.longitude,
        'name': FirebaseAuth.instance.currentUser?.displayName.toString(),
        'showPosition': true,
      },SetOptions(merge: true));
     });
  }

  _stopListening() async {
   /* await FirebaseFirestore.instance.collection('userslocation').doc(FirebaseAuth.instance.currentUser?.uid).set({
      'showPosition': false,
    },SetOptions(merge: true));*/
    _locationSubscription?.cancel();
    FirebaseFirestore.instance.collection('userslocation').doc(FirebaseAuth.instance.currentUser?.uid).delete();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async{
    var status = await Permission.location.request();
    
    
    if(status.isGranted){
      print('Done');
      location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
      location.enableBackgroundMode(enable: true);
    }else if(status.isDenied){
      await  _requestPermission();
    }else if(status.isPermanentlyDenied){
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('FindMe'),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(53, 112, 166, 1),
      ),
      body: Column(
        children: [
          TextButton(onPressed: () {
           FirebaseFirestore.instance.collection('userslocation').doc(FirebaseAuth.instance.currentUser?.uid).delete();
           Navigator.push(context, PageTransition(child: WelcomePage(), type: PageTransitionType.leftToRight));
           FirebaseAuth.instance.signOut();
           
          }, child: const Text('LogOut')),
          TextButton(onPressed: () {
            _getLocation();
          }, child: const Text('add my location')),
          Switch(
            value: isOn , 
            activeColor: Colors.blue,
            onChanged: (bool value){
            if(value){
              _listenLocation();
            }else{
              _stopListening();
            }
            setState(() {
              isOn = value;
            });
          }
          ),
          TextButton(onPressed: (){ 
          } ,child: const Text('Friends')),
          TextButton(onPressed: (){
          } ,child: const Text('FriendsRequests')),
          Expanded(child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('userslocation').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: 
                      Text(snapshot.data!.docs[index]['name'].toString()),
                      subtitle: Row(
                        children: [
                          Text(snapshot.data!.docs[index]['latitude']
                          .toString()),
                          SizedBox(
                            width: 20,),
                          Text(snapshot.data!.docs[index]['longitude']
                          .toString()),
                        ],
                      ),
                      trailing: IconButton(icon: Icon(Icons.directions),
                      onPressed: (){Navigator.of(context).push(
                        MaterialPageRoute(builder: ((context) => Map())));
                        },),
                  );
                });
            }
          ))
        ],
      ),
    );
  }
}
