import 'package:findme/page/intro_screen.dart';
import 'package:findme/service/auth.dart';
import 'package:findme/notused/home.dart';
import 'package:findme/page/selector_page.dart';
import 'package:findme/page/welcome.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const SelectorPage();
        } else {
          return WelcomePage();
        }
      },
    );
  }
}
