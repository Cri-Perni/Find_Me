import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findme/color/color.dart';
import 'package:findme/service/user.dart';
import 'package:findme/page/f_request.dart';
import 'package:findme/page/optionrequest.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/quickalert.dart';
import '../service/get_user_name.dart';

class Friends extends StatefulWidget {
  Friends({super.key, required this.myuser});

  MyUser myuser;

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  List<String> docIds = [];
  bool isLoading = false;
  Map<String, dynamic> userMap = {};

  final FirebaseFirestore _firePath = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    getDocId();
    super.initState();
    docIds;
  }

  void onSearch() async {
    var temp;
    setState(() {
      isLoading = true;
    });
    await _firePath
        .collection('friends')
        .doc(widget.myuser.id)
        .collection('myfriends')
        .count()
        .get();
    await _firePath
        .collection('users')
        .where('email', isEqualTo: _searchController.text)
        .get()
        .then((value) => {
              temp = value.docs[0].data(),
            });
    setState(() {
      userMap = {};
      userMap = temp;
      isLoading = false;
    });
    print(userMap);
  }

  Future getDocId() async {
    await _firePath
        .collection('friendsrequests')
        .doc(widget.myuser.id)
        .collection('receivedrequests')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              docIds.add(document.reference.id);
              debugPrint(document.reference.toString());
            }));
  }

  void removeFriend(String friendsId, int index) async {
    _firePath
        .collection('friends')
        .doc(widget.myuser.id)
        .collection('myfriends')
        .doc(friendsId)
        .delete();
    _firePath
        .collection('friends')
        .doc(friendsId)
        .collection('myfriends')
        .doc(widget.myuser.id)
        .delete();
    setState(() {
      widget.myuser.friends!.removeAt(index);
    });
  }

  dialog(Widget namemail, int index) async {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: namemail,
            content: const Text('do you really want to remove this friend?'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    removeFriend(widget.myuser.friends![index].trim(), index);
                    Navigator.pop(context);
                    QuickAlert.show(
                        context: context,
                        confirmBtnColor: AppColors.container.background,
                        type: QuickAlertType.success,
                        text: 'Request Accepted');
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Friends'),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white12,
        titleTextStyle: TextStyle(
            color: AppColors.text.textColor,
            fontSize: 30,
            fontWeight: FontWeight.bold),
        actions: [
          StreamBuilder(
              stream: _firePath
                  .collection('friendsrequests')
                  .doc(widget.myuser.id)
                  .collection('receivedrequests')
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return Badge(
                    position: BadgePosition.topEnd(top: 12, end: 12),
                    badgeColor: AppColors.container.notify,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: FriendRequestReceived2(myuser: widget.myuser),
                                type: PageTransitionType.rightToLeft));
                      },
                      icon: const Icon(Icons.notifications),
                      color: AppColors.container.background,
                      iconSize: 28,
                    ),
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.notifications),
                    color: AppColors.container.background,
                    iconSize: 28,
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child:
                                  FriendRequestReceived2(myuser: widget.myuser),
                              type: PageTransitionType.rightToLeft));
                    },
                  );
                }
              })),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height / 20,
          ),
          Container(
            height: size.height / 14,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height / 14,
              width: size.width / 1.15,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ),
          SizedBox(
            height: size.height * .02,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.container.background),
              onPressed: onSearch,
              child: const Text('Search')),
          // SizedBox(height: size.height/30,),
          userMap.isEmpty != true
              ? ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: OptionRequest(
                              username: userMap['username'],
                              email: userMap['email'],
                              uid: userMap['uid'],
                              docIds: docIds,
                            ),
                            type: PageTransitionType.rightToLeft));
                  },
                  title: Text(userMap['username']),
                  subtitle: Text(userMap['email']),
                )
              : Container(
                  height: size.height * .12,
                ),
          SizedBox(
            height: 2,
            width: size.width - 6,
            child: Container(
              color: AppColors.container.backgroundark,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                'Friends List',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.container.background),
              )),
          Expanded(
              child: Card(
                  color: AppColors.container.background,
                  child: ListView.builder(
                      itemCount: widget.myuser.friends!.length,
                      itemBuilder: ((context, index) {
                        return Card(
                          color: Colors.white,
                          // ignore: prefer_const_constructors
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundImage:
                                      const AssetImage("assets/utente.jfif"),
                                  backgroundColor:
                                      AppColors.container.background,
                                  radius: 25),
                              title: GetUserName(
                                  documentId:
                                      widget.myuser.friends![index].trim()),
                              tileColor: Colors.white,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Text(
                                    'Click For Manage',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 114, 114, 114)),
                                  )
                                ],
                              ),
                              onTap: () {
                                dialog(GetUserName( documentId: widget.myuser.friends![index].trim()),index);
                              },
                            ),
                          ),
                        );
                      }
                 )
              )
           )
          )
        ],
      ),
    );
  }
}
