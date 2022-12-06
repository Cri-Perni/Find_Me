import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findme/service/get_user_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class fp extends StatefulWidget {
  const fp({super.key});

  @override
  State<fp> createState() => _fp();
}

class _fp extends State<fp> {
  List<String> docIds = [];
  List<String> docInfo = [];
  String pass = '';

@override
  void initState() {
    getDocIds();
    // TODO: implement initState
    super.initState();
  }

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

  aceptRequest(String senterid) async{
    String? currentUId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore firepath = FirebaseFirestore.instance;
    //acept request
    await firepath.collection('friendsrequests').doc(senterid).collection('sentrequests').doc(currentUId).delete();
    await firepath.collection('friendsrequests').doc(currentUId).collection('receivedrequests').doc(senterid).delete();
     setState(() {
      docIds.remove(senterid);
    });

    await firepath.collection('friends').doc(currentUId).collection('myfriends').doc(senterid).set({
      'friend': true,
    });
    await firepath.collection('friends').doc(senterid).collection('myfriends').doc(currentUId).set({
      'friend': true,
    });
  }

  cancelRequest(String senterid) async {
    String? currentUId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore firepath = FirebaseFirestore.instance;
    //delete request
    await firepath.collection('friendsrequests').doc(senterid).collection('sentrequests').doc(currentUId).delete();
    await firepath.collection('friendsrequests').doc(currentUId).collection('receivedrequests').doc(senterid).delete();
    setState(() {
      docIds.remove(senterid);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
         leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 20,
          color: const Color.fromRGBO(53, 112, 166, 1) ,
      ),
      elevation: 0,
        title: const Text('Friends Request',style: TextStyle(color: Color.fromRGBO(53, 112, 166, 1)),),
        backgroundColor: Colors.white10,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('friendsrequests').doc(FirebaseAuth.instance.currentUser!.uid).collection('receivedrequests').snapshots(),
              builder: ((context, snapshot) {
              return snapshot.hasData? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: ((context, index) {
                  return ListTile(
                    title: GetUserName(documentId:snapshot.data!.docs[index]['senter'].toString()),
                    tileColor: Colors.white12,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(onPressed: (){
                          aceptRequest(snapshot.data!.docs[index]['senter'].toString());
                        },child: Text('accept')),
                        SizedBox(width: 20,),
                        ElevatedButton(onPressed: (){
                          cancelRequest(snapshot.data!.docs[index]['senter'].toString());
                        }, child: Text('cancel'))
                      ],
                    ),
                    onTap: (){

                    },
                  );
                }),
              ): Container();
            })
            ,))
        ],
      ),
    );
  }
}