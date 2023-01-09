import 'dart:async';

import 'package:findme/color/color.dart';
import 'package:findme/page/Auth/login.dart';
import 'package:findme/page/home2.dart';
import 'package:findme/page/selector_page.dart';
import 'package:findme/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? timer;
  bool isEmailVerified = false;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const SelectorPage()
      : Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.container.background,
            title: const Text('Verify Email'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text(
                  'A verification email has been sent to your email',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.container.background
                    ),
                    onPressed: () {
                      if (canResendEmail) {
                        sendVerificationEmail();
                      }
                    },
                    icon: const Icon(Icons.email),
                    label: const Text(
                      'Resent Email',
                      style: TextStyle(fontSize: 24),
                    )),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                  onPressed: () {
                    Auth().signOut();
                  },
                  style: ElevatedButton.styleFrom(
                      maximumSize: const Size.fromHeight(50)),
                  child: Text('Cancel',style: TextStyle(fontSize: 24,color: AppColors.container.background),),
                )
              ],
            ),
          ),
        );
}
