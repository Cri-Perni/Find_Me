import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findme/service/request_service.dart';
import 'package:findme/service/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../color/color.dart';
import '../../notused/get_user_image.dart';
import '../../service/get_user_name.dart';

class Pending extends StatefulWidget {
  Pending({super.key, required this.myuser});
  MyUser myuser;

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  @override
  final FirebaseFirestore _firePath = FirebaseFirestore.instance;
  List<String> docRequestsSentId = [];

  getDocPendingIds() async {
    await _firePath
        .collection('friendsrequests')
        .doc(widget.myuser.id)
        .collection('sentrequests')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              docRequestsSentId.add(document.reference.id);
              debugPrint(document.reference.toString());
            }));
  }

  dialog(Widget namemail, String friendsId) async {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: namemail,
            content:
                const Text('do you really want to delete this friend request?'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    RequestService().deleteRequest(
                        friendsId, widget.myuser.id!, docRequestsSentId);
                    setState(() {
                      docRequestsSentId.remove(friendsId);
                    });
                    Navigator.pop(context);
                    QuickAlert.show(
                        context: context,
                        confirmBtnColor: AppColors.container.background,
                        type: QuickAlertType.success,
                        text: 'Request deleted');
                  },
                  child: const Text("delete"),
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
        title: const Text(
          'Pending Request',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.container.background,
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: getDocPendingIds(),
            builder: ((context, snapshot) {
              if (docRequestsSentId.isNotEmpty) {
                return ListView.builder(
                  itemCount: docRequestsSentId.length,
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
                              documentId: docRequestsSentId[index].trim()),
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
                                    documentId:
                                        docRequestsSentId[index].trim()),
                                docRequestsSentId[index].trim());
                          },
                        ),
                      ),
                    );
                  }),
                );
              } else {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'There are no pending requests',
                        style: TextStyle(
                            color: AppColors.container.background,
                            fontSize: 20),
                      )
                    ]);
              }
            }),
          ))
        ],
      ),
    );
  }
}
