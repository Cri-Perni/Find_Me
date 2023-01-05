import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter_platform_interface/src/types/marker_updates.dart';

class GetUserName extends StatelessWidget {
  GetUserName({super.key, required this.documentId});

  String documentId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // ignore: avoid_print
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
          return Text(data['username']+"\n"+data['name'],style: TextStyle(fontSize: 16),);
        }
        return 
          Column(
          children: [
          Container(height: 10, width: size.width*.15,color: Colors.grey[400] ),
        ],);
      }),
      );
  }
}