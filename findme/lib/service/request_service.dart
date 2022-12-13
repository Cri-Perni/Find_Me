import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestService {
  Future<List<String>> getFriends() async {
    FirebaseFirestore firepath = FirebaseFirestore.instance;
    List<String> docFriendsID = [];
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

  Future sendRequest(String reciverUid, String currentUId, List docIds) async {
    FirebaseFirestore firepath = FirebaseFirestore.instance;
    //insert sent request in myuserid
    await firepath
        .collection('friendsrequests')
        .doc(currentUId)
        .collection('sentrequests')
        .doc(reciverUid)
        .set({'reciver': reciverUid}, SetOptions(merge: true));
    //insert resived request in resiveruserid
    await firepath
        .collection('friendsrequests')
        .doc(reciverUid)
        .collection('receivedrequests')
        .doc(currentUId)
        .set({'senter': currentUId}, SetOptions(merge: true));
    docIds.add(reciverUid);
  }

  Future deleteRequest(String reciverUid, String currentUId, List docIds) async {
    FirebaseFirestore firepath = FirebaseFirestore.instance;
    //delete request
    await firepath
        .collection('friendsrequests')
        .doc(currentUId)
        .collection('sentrequests')
        .doc(reciverUid)
        .delete();
    await firepath
        .collection('friendsrequests')
        .doc(reciverUid)
        .collection('receivedrequests')
        .doc(currentUId)
        .delete();
    docIds.remove(reciverUid);
  }

  bool isJustSent(List docIds, String reciverUid) {
    bool flag = false;
    // ignore: avoid_function_literals_in_foreach_calls
    docIds.forEach((element) {
      // ignore: avoid_print
      print(element + ' ' + reciverUid);
      if (element == reciverUid) {
        flag = true;
      }
    });
    return flag;
  }

  bool isJustfrineds(List docIds, String reciverUid) {
    bool flag = false;
    // ignore: avoid_function_literals_in_foreach_calls
    docIds.forEach((element) {
      // ignore: avoid_print
      print(element + ' ' + reciverUid);
      if (element == reciverUid) {
        flag = true;
      }
    });
    return flag;
  }

  bool isMe(String myId, String searchId) {
    return (myId == searchId);
  }
}
