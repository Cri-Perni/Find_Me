import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findme/service/request_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';


class OptionRequest extends StatefulWidget {
  OptionRequest({super.key, required this.username, required this.email, required this.uid, required this.docIds});

  List<String> docIds;
  String username,email,uid;

  @override
  State<OptionRequest> createState() => _OptionRequestState();
}

class _OptionRequestState extends State<OptionRequest> {
/*
  Future sendRequest(String reciverUid, List docIds) async {
    String? currentUId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore firepath = FirebaseFirestore.instance;
    //insert sent request in myuserid
    await firepath.collection('friendsrequests').doc(currentUId).collection('sentrequests').doc(reciverUid).set({
      'reciver':reciverUid
    },SetOptions(merge: true));
    //insert resived request in resiveruserid
    await firepath.collection('friendsrequests').doc(reciverUid).collection('receivedrequests').doc(currentUId).set({
      'senter': currentUId as String
    },SetOptions(merge: true));
    docIds.add(reciverUid);
  }

  Future deleteRequest(String reciverUid, List docIds) async {
    String? currentUId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore firepath = FirebaseFirestore.instance;
    //delete request
    await firepath.collection('friendsrequests').doc(currentUId).collection('sentrequests').doc(reciverUid).delete();
    await firepath.collection('friendsrequests').doc(reciverUid).collection('receivedrequests').doc(currentUId).delete();
    docIds.remove(reciverUid);

  }

  bool isJustSent(List docIds, String reciverUid){
    bool flag = false;
    // ignore: avoid_function_literals_in_foreach_calls
    docIds.forEach((element) {
      // ignore: avoid_print
      print(element+' '+reciverUid);
      if(element == reciverUid){
        flag = true;
      }
     });
    return flag;
  }

  bool isJustfrineds(List docIds, String reciverUid){
    bool flag = false;
    // ignore: avoid_function_literals_in_foreach_calls
    docIds.forEach((element) {
      // ignore: avoid_print
      print(element+' '+reciverUid);
      if(element == reciverUid){
        flag = true;
      }
     });
    return flag;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
      ),
      body: Column(
        children: [
          Text(widget.email),
          const SizedBox(width: 100),
          Text(widget.uid),
          RequestService().isJustSent(widget.docIds,widget.uid)?
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(178, 208, 206, 1)),
            onPressed: (){
            RequestService().deleteRequest(widget.uid,FirebaseAuth.instance.currentUser!.uid,widget.docIds);
            QuickAlert.show(context: context,
            confirmBtnColor: const Color.fromRGBO(53, 112, 166, 1), 
            type: QuickAlertType.success,
            text: 'Friend request successfully canceled to'+' '+widget.username);
            }, child: Text('Cancel Request'))
          :ElevatedButton(onPressed: (){
            RequestService().sendRequest(widget.uid,FirebaseAuth.instance.currentUser!.uid,widget.docIds);
            QuickAlert.show(context: context,
            confirmBtnColor: const Color.fromRGBO(53, 112, 166, 1), 
            type: QuickAlertType.success,
            text: 'Friend request sent successfully to'+' '+widget.username);
            }, child: Text('Sent Request'))
        ],
      ),
    );
  }
}