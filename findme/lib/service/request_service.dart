
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestService {

Future<List<String>> getFriends() async {
    FirebaseFirestore firepath = FirebaseFirestore.instance;
    List<String> docFriendsID=[];
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
    return docFriendsID;
  }

  fireGetFriends(String uid) {
    return FirebaseFirestore.instance.collection('friends').doc(uid).get();
  }



}