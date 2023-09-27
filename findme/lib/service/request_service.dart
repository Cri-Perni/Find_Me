
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestService {

  FirebaseFirestore firePath = FirebaseFirestore.instance;

  Future<List<String>> getFriends() async {
    List<String> docFriendsID = [];
    firePath
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

  fireGetFriendsSnap(String uid) {
    return FirebaseFirestore.instance.collection('friends').doc(uid).snapshots();
  }

  fireGetFriends(String uid) {
    return FirebaseFirestore.instance.collection('friends').doc(uid);
  }

  Future sendRequest(String receiverUid, String currentUId, List docIds) async {
    FirebaseFirestore firepath = FirebaseFirestore.instance;
    //insert sent request in myuserid
    await firepath
        .collection('friendsrequests')
        .doc(currentUId)
        .collection('sentrequests')
        .doc(receiverUid)
        .set({'reciver': receiverUid}, SetOptions(merge: true));
    //insert resived request in resiveruserid
    await firepath
        .collection('friendsrequests')
        .doc(receiverUid)
        .collection('receivedrequests')
        .doc(currentUId)
        .set({'senter': currentUId}, SetOptions(merge: true));
    docIds.add(receiverUid);
  }

  Future deleteRequest(String receiverUid, String currentUId, List docIds) async {
    FirebaseFirestore firepath = FirebaseFirestore.instance;
    //delete request
    await firepath
        .collection('friendsrequests')
        .doc(currentUId)
        .collection('sentrequests')
        .doc(receiverUid)
        .delete();
    await firepath
        .collection('friendsrequests')
        .doc(receiverUid)
        .collection('receivedrequests')
        .doc(currentUId)
        .delete();
    docIds.remove(receiverUid);
  }

  bool isJustSent(List docIds, String receiverUid) {
    bool flag = false;
    // ignore: avoid_function_literals_in_foreach_calls
    docIds.forEach((element) {
      // ignore: avoid_print
      print(element + ' ' + receiverUid);
      if (element == receiverUid) {
        flag = true;
      }
    });
    return flag;
  }

  bool isJustfrineds(List docIds, String receiverUid) {
    bool flag = false;
    // ignore: avoid_function_literals_in_foreach_calls
    docIds.forEach((element) {
      // ignore: avoid_print
      print(element + ' ' + receiverUid);
      if (element == receiverUid) {
        flag = true;
      }
    });
    return flag;
  }

  bool isMe(String myId, String searchId) {
    return (myId == searchId);
  }

  void removeFriend(String friendsId,String currentId) async {
    firePath
        .collection('friends')
        .doc(currentId)
        .collection('myfriends')
        .doc(friendsId)
        .delete();
    firePath
        .collection('friends')
        .doc(friendsId)
        .collection('myfriends')
        .doc(currentId)
        .delete();
  }
}
