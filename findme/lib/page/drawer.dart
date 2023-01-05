import 'package:findme/color/color.dart';
import 'package:findme/page/selector_page.dart';
import 'package:findme/page/tree.dart';
import 'package:findme/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:page_transition/page_transition.dart';

import '../service/user.dart';

class SideDrawer extends StatefulWidget {
  SideDrawer({super.key, required this.myuser});
  MyUser myuser;

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            // ignore: sort_child_properties_last
            child: const Text(
              'Find Me',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
                color: AppColors.container.background,
                image: const DecorationImage(
                    fit: BoxFit.fill, image: AssetImage('assets/splash.png'))),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () {
              Navigator.pushReplacement(context, PageTransition(child: Tree(), type: PageTransitionType.rightToLeft));
              FirebaseAuth.instance.signOut();
             
            },
          ),
        ],
      ),
    );
  }
}
