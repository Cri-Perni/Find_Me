import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findme/service/get_user_name.dart';
import 'package:findme/service/request_service.dart';
import 'package:findme/service/user.dart';
import 'package:flutter/material.dart';

import 'package:quickalert/quickalert.dart';
import '../../color/color.dart';

class FriendsList extends StatefulWidget {
  FriendsList({super.key, required this.myuser});
  MyUser myuser;

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  dialog(Widget namemail, friendsId) async {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: namemail,
            content: const Text('do you really want to remove this friend?'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    RequestService().removeFriend(friendsId, widget.myuser.id!);
                    setState(() {
                      widget.myuser.friends!.remove(friendsId);
                    });
                    Navigator.pop(context);
                    QuickAlert.show(
                        context: context,
                        confirmBtnColor: AppColors.container.background,
                        type: QuickAlertType.success,
                        text: 'Friend Removed');
                  },
                  child: const Text("Remove"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.container.background)),
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
        }));
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
          color: Colors.white,
        ),
        elevation: 0,
        title: const Text(
          'Friends List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.container.background,
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('friends')
                .doc(widget.myuser.id)
                .collection('myfriends')
                .snapshots(),
            builder: ((context, snapshot) {
              if (snapshot.data?.docs.isNotEmpty == true ){
                // ignore: avoid_print
                print(snapshot.data?.docs);
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: ((context, index) {
                    // ignore: prefer_const_constructors
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.white,
                      // ignore: prefer_const_constructors
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage("assets/utente.jfif"),
                            backgroundColor: AppColors.container.background,
                            radius: 25,
                          ),
                          title: GetUserName(
                              documentId: snapshot.data!.docs[index]['friend']),
                          tileColor: Colors.white,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Text(
                                'Click For Manage',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 114, 114, 114)),
                              )
                            ],
                          ),
                          onTap: () {
                            dialog(
                                GetUserName(
                                    documentId: snapshot.data!.docs[index]
                                        ['friend']),
                                snapshot.data!.docs[index]['friend']);
                          },
                        ),
                      ),
                    );
                  }),
                );
              } else {
                return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'There are no Friends',
                    style: TextStyle(
                        color: AppColors.container.background, fontSize: 20),
                  )
                ]);
              }
            }),
          )),
        ],
      ),
    );
  }
}
