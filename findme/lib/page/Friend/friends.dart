import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findme/color/color.dart';
import 'package:findme/page/Friend/f_request.dart';
import 'package:findme/page/Friend/friends_list.dart';
import 'package:findme/page/Friend/pending_request.dart';
import 'package:findme/service/request_service.dart';
import 'package:findme/service/user.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/quickalert.dart';


class Friends extends StatefulWidget {
  Friends({super.key, required this.myuser});

  MyUser myuser;

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  List<String> docRequestsId = [];
  List<String> docRequestsSentId = [];
  bool isLoading = false;
  Map<String, dynamic> userMap = {};

  final FirebaseFirestore _firePath = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    docRequestsSentId = [];
    getDocId();
    getDocIdRequestSent();
    super.initState();
    docRequestsId;
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
              setState(() {
                docRequestsId.add(document.reference.id);
              });

              debugPrint(document.reference.toString());
            }));
  }

  Future getDocIdRequestSent() async {
    await _firePath
        .collection('friendsrequests')
        .doc(widget.myuser.id)
        .collection('sentrequests')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              setState(() {
                docRequestsSentId.add(document.reference.id);
              });
              debugPrint(document.reference.toString());
            }));
  }

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

  Widget textType(usermap) {
    getDocIdRequestSent();
    if (RequestService()
        .isJustfrineds(widget.myuser.friends!, usermap['uid'])) {
      return const Text('do you really want to remove this friend?');
    } else if (RequestService().isJustSent(docRequestsSentId, usermap['uid'])) {
      return const Text('do you want to delete the request?');
    } else if (RequestService().isMe(widget.myuser.id!, usermap['uid'])) {
      return const Text('This is your profile');
    }
    return const Text('do you want send the request?');
  }

  Widget buttonDialog(usermap) {
    if (RequestService()
        .isJustfrineds(widget.myuser.friends!, usermap['uid'])) {
      return ElevatedButton(
          onPressed: () {
            RequestService().removeFriend(usermap['uid'], widget.myuser.id!);
            Navigator.pop(context);
            QuickAlert.show(
                context: context,
                confirmBtnColor: AppColors.container.background,
                type: QuickAlertType.success,
                text: 'Friend Removed');
            setState(() {
              widget.myuser.friends!.remove(usermap['uid']);
              userMap = {};
            });
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.container.background),
          child: const Text("Remove"));
    } else if (RequestService().isJustSent(docRequestsSentId, usermap['uid'])) {
      return ElevatedButton(
          onPressed: () {
            RequestService().deleteRequest(
                usermap['uid'], widget.myuser.id!, docRequestsId);
            Navigator.pop(context);
            QuickAlert.show(
                context: context,
                confirmBtnColor: AppColors.container.background,
                type: QuickAlertType.success,
                text: 'Request Deleted');
            setState(() {
              userMap = {};
            });
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.container.background),
          child: const Text("Delete"));
    } else if (RequestService().isMe(widget.myuser.id!, usermap['uid'])) {
      return const SizedBox();
    }
    return ElevatedButton(
        onPressed: () {
          RequestService()
              .sendRequest(usermap['uid'], widget.myuser.id!, docRequestsId);
          Navigator.pop(context);
          QuickAlert.show(
              context: context,
              confirmBtnColor: AppColors.container.background,
              type: QuickAlertType.success,
              text: 'Request sent');
          setState(() {
            userMap = {};
          });
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.container.background),
        child: const Text("Send"));
  }

  dialogRequest(userMap) async {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text(userMap['username']),
            content: textType(userMap),
            actions: [buttonDialog(userMap)],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
        }));
  }

  Widget textField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: AppColors.container.background,
          fillColor: const Color.fromRGBO(209, 228, 255, 1),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: AppColors.container.background))),
    );
  }

  Widget cardFriends(Size size, String title, AssetImage image) {
    return Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          // ignore: sized_box_for_whitespace
          child: Container(
            height: size.height * .20,
            width: size.width * .35,
            child: Column(children: [
              Container(
                  height: size.height * .05,
                  width: size.width * .40,
                  decoration: BoxDecoration(
                    color: AppColors.container.background,
                  ),
                  child: Center(
                      child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ))),
              Container(
                  height: size.height * .15,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: image,
                    fit: BoxFit.fitHeight,
                  )))
            ]),
          ),
        ));
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
                  if (snapshot.data?.size != 0 ) {
                    return Badge(
                      position: BadgePosition.topEnd(top: 12, end: 12),
                      badgeColor: AppColors.container.notify,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: FriendRequestReceived2(
                                      myuser: widget.myuser),
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
                                child: FriendRequestReceived2(
                                    myuser: widget.myuser),
                                type: PageTransitionType.rightToLeft));
                      },
                    );
                  }
                })),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: size.height * .02,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              // ignore: sized_box_for_whitespace
              child: Container(
                height: size.height / 14,
                width: size.width / 1.15,
                child: textField(_searchController),
              ),
            ),
            SizedBox(
              height: size.height * .015,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    backgroundColor: AppColors.container.background),
                onPressed: () {
                  setState(() {
                    docRequestsSentId = [];
                    
                  });
                  onSearch();
                  getDocIdRequestSent();
                },
                child: Padding(
                    padding: EdgeInsets.all(size.width * .02),
                    child: const Text('Search'))),
            SizedBox(
              height: size.height * .01,
            ),
            userMap.isEmpty != true
                ? Stack(children: [
                    Container(
                        padding: EdgeInsets.only(
                            top: size.height * 0.13,
                            bottom: size.height * 0.08),
                        height: size.height * .35,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/Search.png"),
                                fit: BoxFit.fitHeight))),
                    Container(
                        height: size.height * .35,
                        color: Color.fromARGB(73, 255, 255, 255),
                        child: Column(children: [
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: Colors.white,
                            // ignore: prefer_const_constructors
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/utente.jfif"),
                                  backgroundColor:
                                      AppColors.container.background,
                                  radius: 25,
                                ),
                                title: Text(userMap['username']),
                                tileColor: Colors.white,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    const Text(
                                      'Click For Manage',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 114, 114, 114)),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  dialogRequest(userMap);
                                },
                              ),
                            ),
                          )
                        ]))
                  ])
                : Container(
                    padding: EdgeInsets.only(
                        top: size.height * 0.13, bottom: size.height * 0.08),
                    height: size.height * .35,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/Search.png"),
                            fit: BoxFit.fitHeight))),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: size.height * .006,
                width: size.width * .98,
                child: Container(
                  color: AppColors.container.background,
                ),
              ),
            ),
            SizedBox(
              height: size.height * .035,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              GestureDetector(
                child: cardFriends(
                    size, 'Frineds', const AssetImage("assets/Friend.png")),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: FriendsList(myuser: widget.myuser),
                          type: PageTransitionType.rightToLeft));
                },
              ),
              GestureDetector(
                child: cardFriends(
                    size, 'Pending', const AssetImage("assets/Recived.png")),
                onTap: () {
                  // ignore: avoid_print
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Pending(myuser: widget.myuser),
                          type: PageTransitionType.rightToLeft));
                },
              )
            ])
          ],
        )));
  }
}
