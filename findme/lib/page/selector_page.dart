import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findme/color/color.dart';
import 'package:findme/page/friends_map.dart';
import 'package:findme/page/friends.dart';
import 'package:findme/service/request_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../service/user.dart';
import 'home.dart';

class SelectorPage extends StatefulWidget {
  const SelectorPage({super.key});

  @override
  State<SelectorPage> createState() => _SelectorPageState();
}

class _SelectorPageState extends State<SelectorPage> {
  List<String> docFriendsID = [];

  int _selectedIndex = 0;
  late MyUser myuser;

  @override
  void initState() {
    super.initState();

    myuser = MyUser(
        FirebaseAuth.instance.currentUser!.uid,
        FirebaseAuth.instance.currentUser!.displayName,
        FirebaseAuth.instance.currentUser!.email,
        docFriendsID);
    // ignore: avoid_print
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    getFrineds();
    // ignore: avoid_print
    myuser.friends = docFriendsID;
    print(myuser.friends);

    return Scaffold(
      body: Center(
          child: IndexedStack(
        index: _selectedIndex,
        children: [
          Home(myuser: myuser,),
          FriendsMap(myuser: myuser),
          Friends(myuser: myuser)
        ],
      )),
      // ignore: prefer_const_constructors
      bottomNavigationBar: GNav(
          backgroundColor: Colors.white,
          color: Colors.grey,
          activeColor: AppColors.container.background,
          gap: 8,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
          selectedIndex: _selectedIndex,
          onTabChange: _navigateBottomBar,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.map_outlined,
              text: 'Map',
            ),
            GButton(
              icon: Icons.person_search,
              text: 'Friends',
            ),
          ]),
    );
  }

  void getFrineds() async {
    docFriendsID = await RequestService().getFriends();
  }
}
