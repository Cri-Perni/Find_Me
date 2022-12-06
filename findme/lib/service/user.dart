//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String? id;
  final String? username;
  final String? email;
  List<String>? friends;

  MyUser( 
    this.id,
    this.username,
    this.email,
    this.friends
  );

    /*factory MyUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return MyUser(
      id: data?['id'],
      username: data?['username'],
      email: data?['email'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "name": id,
      if (username != null) "state": username,
      if (email != null) "email": email,
    };
  }*/
}