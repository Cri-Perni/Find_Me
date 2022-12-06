import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findme/color/color.dart';
import 'package:findme/service/get_user_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:quickalert/quickalert.dart';

class FriendRequestReceived extends StatefulWidget {
  const FriendRequestReceived({super.key});

  @override
  State<FriendRequestReceived> createState() => _FriendRequestReceivedState();
}

class _FriendRequestReceivedState extends State<FriendRequestReceived> {
  List<String> docIds = [];
  List<String> docInfo = [];

    Future getDocIds() async{
   String? currentUId = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
    .collection('friendsrequests')
    .doc(currentUId)
    .collection('receivedrequests')
    .get()
    .then((snapshot) => snapshot.docs.forEach(
      (document) {
        print(document.reference);
      docIds.add(document.reference.id);
    }));
  }

   Future getDocInfo() async{
    await FirebaseFirestore.instance
    .collection('users')
    .get()
    // ignore: avoid_function_literals_in_foreach_calls
    .then((snapshot) => snapshot.docs.forEach(
      (document) {
        docInfo.add(document.toString());
        // ignore: avoid_print
        print(docInfo[0]);

       }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold.background,
      appBar: AppBar(
        centerTitle: true,
         leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 20,
          color: Colors.white,
      ),
        elevation: 0,
        title: const Text('Friends Request',style: TextStyle(color: Colors.white),),
      ),
      body: Column(

        children: [
          Expanded(
            child: FutureBuilder(
            future:getDocIds(),
            builder: ((context, snapshot) {
              return ListView.builder(
                itemCount: docIds.length,
                itemBuilder: ((context, index) {
                  return ListTile(
                    shape: const RoundedRectangleBorder(
                       side: BorderSide(color: Color.fromRGBO(53, 112, 166, 1), width: 0.5),
                       ), 
                    leading: CircleAvatar(child:Text('nodata'),
                    backgroundColor:Color.fromARGB(255, 34, 95, 175),radius: 25,),
                    title: GetUserName(documentId:docIds[index].trim()),
                   tileColor: Color.fromARGB(255, 255, 255, 255),
                    trailing:  Row(
                      mainAxisSize: MainAxisSize.min,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                       const Text('Click For Manage',style: TextStyle(color: Color.fromARGB(255, 114, 114, 114)),)
                      ],
                    ),
                    onTap: (){
                      dialog(GetUserName(documentId: docIds[index].trim()),index);
                    },
                  );
                }),
              );
            })
            ,))
        ],
      ),
    );
  }

  aceptRequest(String senterid) async{
    String? currentUId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore firepath = FirebaseFirestore.instance;
    //acept request
    await firepath.collection('friendsrequests').doc(senterid).collection('sentrequests').doc(currentUId).delete();
    await firepath.collection('friendsrequests').doc(currentUId).collection('receivedrequests').doc(senterid).delete();

    await firepath.collection('friends').doc(currentUId).collection('myfriends').doc(senterid).set({
      'friend': senterid,
    });
    await firepath.collection('friends').doc(senterid).collection('myfriends').doc(currentUId).set({
      'friend': currentUId,
    });
  }
  cancelRequest(String senterid) async {
    String? currentUId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore firepath = FirebaseFirestore.instance;
    //delete request
    await firepath.collection('friendsrequests').doc(senterid).collection('sentrequests').doc(currentUId).delete();
    await firepath.collection('friendsrequests').doc(currentUId).collection('receivedrequests').doc(senterid).delete();
    
  }

  dialog(Widget namemail,int index) async{

    showDialog(
      context: context, 
      builder: ((context) {
      return AlertDialog(
        title: namemail,
        content: const Text('Do you want to accept the friend request?'),
        actions: [
          ElevatedButton(onPressed: (){
            aceptRequest(docIds[index]);
            setState(() {
              docIds.removeAt(index);
            });
            Navigator.pop(context);
            QuickAlert.show(context: context,confirmBtnColor: AppColors.container.background, type: QuickAlertType.success,text: 'Request Accepted');
          }, child: const Text("Yes"),
          style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(53, 112, 166, 1))
          ),
          ElevatedButton(onPressed: (){
            cancelRequest(docIds[index]);
            setState(() {
              docIds.removeAt(index);
            });
            Navigator.pop(context);
            QuickAlert.show(context: context,confirmBtnColor: AppColors.container.background, type: QuickAlertType.success,text: 'Request cancelled');
          }, child: const Text("No"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.container.background
          ),)
        ],
        
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
      );
    }));

  }



}