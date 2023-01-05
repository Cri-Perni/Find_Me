import 'dart:async';
import 'package:findme/color/color.dart';
import 'package:findme/page/error_screen.dart';
import 'package:findme/page/intro_screen.dart';
import 'package:findme/page/tree.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:findme/widget_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: AppColors.container.background,
          primarySwatch: Colors.blueGrey),
      home: const Tree(),
    );
  }
}
