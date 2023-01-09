import 'package:findme/page/Auth/verify_email_page.dart';
import 'package:findme/page/intro_screen.dart';
import 'package:findme/page/selector_page.dart';
import 'package:findme/page/splash.dart';
import 'package:findme/page/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/auth.dart';
import 'error_screen.dart';

class Tree extends StatefulWidget {
  const Tree({super.key});

  @override
  State<Tree> createState() => _TreeState();
}

class _TreeState extends State<Tree> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: ((context, authSnapshot) => FutureBuilder(
              future: isFirstLaunch(),
              builder: (context, launchSnapshot) {
                switch (launchSnapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Splash();
                  default:
                    if (!launchSnapshot.hasError) {
                      // ignore: avoid_print
                      if (launchSnapshot.data!) {
                        updateLaunch();
                        return const IntroScreen();
                      } else {
                        if (authSnapshot.hasData) {
                          return const VerifyEmailPage();
                        } else {
                          return WelcomePage();
                        }
                      }
                    } else {
                      return ErrorScreen(error: launchSnapshot.error);
                    }
                }
              },
            )));
  }

  Future<bool> isFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('firstLaunch') ?? true;
  }
}

void updateLaunch() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('firstLaunch', false);
}
