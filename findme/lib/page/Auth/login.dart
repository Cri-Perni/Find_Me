// ignore_for_file: prefer_const_constructors

import 'package:findme/color/color.dart';
import 'package:findme/page/selector_page.dart';
import 'package:findme/page/tree.dart';
import 'package:findme/page/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findme/service/auth.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> singInWithEmailAndPassword() async {
    try {
      await Auth().singInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: ((context) {
        return const Tree();
      })), (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  // ignore: non_constant_identifier_names
  Widget InputField(
      String title, TextEditingController controller, IconData iconData,
      {obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
              prefixIcon: Icon(iconData),
              prefixIconColor: Colors.grey[700],
              labelText: title,
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              )),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton() {
    return MaterialButton(
      minWidth: double.infinity,
      height: 60,
      color: AppColors.container.background,
      elevation: 0,
      onPressed: () {
        singInWithEmailAndPassword();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        "Login",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: Tree(), type: PageTransitionType.leftToRight));
            },
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 20,
            color: Colors.black,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        // ignore: sized_box_for_whitespace
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        // ignore: prefer_const_literals_to_create_immutables, duplicate_ignore
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                              color: AppColors.container.background,
                              fontSize: size.width * .1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Text(
                            "Login to your account",
                            style: TextStyle(
                              fontSize: size.width * 0.035,
                              color: Colors.grey[700],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.05),
                        child: Column(
                          children: [
                            InputField("Email", _controllerEmail,
                                Icons.mail_lock_outlined),
                            InputField("Password", _controllerPassword,
                                Icons.lock_outline,
                                obscureText: true),
                            _errorMessage(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.06),
                        child: Container(
                            padding: EdgeInsets.only(top: 30, left: 3),
                            child: _submitButton()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text("Don't have an account?"),
                          Text(
                            "Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: size.height * 0.13,
                            bottom: size.height * 0.08),
                        height: size.height * .25,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/login.png"),
                              fit: BoxFit.fitHeight),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
