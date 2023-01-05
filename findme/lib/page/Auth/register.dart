import 'dart:math';
import 'package:findme/page/home.dart';
import 'package:findme/page/Auth/login.dart';
import 'package:findme/page/selector_page.dart';
import 'package:findme/page/tree.dart';
import 'package:findme/page/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findme/service/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/quickalert.dart';

import '../../color/color.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? errorMessage='';
  String nome='';

  final TextEditingController _controllerCheckPassword = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerUserName = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  

  Future<void> createUserWithEmailAndPassword() async{
    
    if(_controllerPassword.text== _controllerCheckPassword.text){
    try {
      await Auth().createUserwithEmailAndPassword(
        email: _controllerEmail.text, 
        password: _controllerPassword.text);
        await FirebaseAuth.instance.currentUser?.updateDisplayName(_controllerUserName.text);
        //await FirebaseAuth.instance.currentUser?.updatePhotoURL(photoURL);
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).set({
          'email': _controllerEmail.text.trim(),
          'username': _controllerUserName.text.trim(),
          'name': _controllerName.text.trim(),
          'uid': FirebaseAuth.instance.currentUser!.uid 
        },SetOptions(merge: true)
        );
        // ignore: prefer_const_constructors, use_build_context_synchronously
        Navigator.pushReplacement(context, PageTransition(child: Tree(), type: PageTransitionType.rightToLeft));
    } on FirebaseAuthException catch(e) {
      setState(() {
        errorMessage = e.message;
      });
    }}else{
      QuickAlert.show(context: context,confirmBtnColor: AppColors.container.background, type: QuickAlertType.error,text: 'something went wrong');
    }
  }
  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerUserName.dispose();
    _controllerCheckPassword.dispose();
    super.dispose();
  }

// ignore: non_constant_identifier_names
Widget InputField(
    String title,
    TextEditingController controller,
     IconData iconData,
    {obscureText = false}){
      Size size = MediaQuery.of(context).size;
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
            //labelStyle: TextStyle(color: Color.fromRGBO(53, 112, 166, 1)),
            floatingLabelStyle: TextStyle(color: AppColors.container.background),
            contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
            enabledBorder: const OutlineInputBorder(
              borderSide: 
              BorderSide(color: Colors.grey),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.container.background)
            ),
          ),
        ),
        SizedBox(height: size.height*.01,)
      ],
    );
  }

  Widget _errorMessage(){
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton(){
    Size size = MediaQuery.of(context).size;
    return MaterialButton(
                        minWidth: double.infinity,
                        height: size.height*0.07,
                        color:  AppColors.container.background,
                        elevation: 0,
                        onPressed: () {
                          createUserWithEmailAndPassword();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Text(
                          "Register",
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
            Navigator.pushReplacement(context, PageTransition(child: Tree(), type: PageTransitionType.leftToRight));
          },
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 20,
          color: Colors.black ,
      ), systemOverlayStyle: SystemUiOverlayStyle.dark,
      ), 
      // ignore: sized_box_for_whitespace
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  // ignore: prefer_const_literals_to_create_immutables, duplicate_ignore
                  children: [
                    Text("Registration",
                    style: TextStyle(
                      fontSize: size.width*.1,
                      fontWeight: FontWeight.bold,
                      color: AppColors.container.background
                    ),
                    ),
                    SizedBox(
                      height: size.height*.01,),
                      Text("Create your account",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),)
                  ],
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    InputField("Username",_controllerUserName,Icons.person_outlined),
                    InputField("Name & LastName", _controllerName, Icons.lock_outlined),
                    InputField("Email",_controllerEmail,Icons.mail_lock_outlined),
                    InputField("Password",_controllerPassword,Icons.lock_outlined,obscureText: true),
                    InputField("Confirm Password",_controllerCheckPassword,Icons.lock_outlined,obscureText: true),
                    _errorMessage(),
                  ],
                ),
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                  padding: const EdgeInsets.only(top: 0,left: 3),
                      child: _submitButton()
                ),
              ),
              
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text("Do you have an account?"),
                    TextButton(onPressed:() {
                      Navigator.pushReplacement(context, PageTransition(child: const LoginPage(), type: PageTransitionType.leftToRight));
                    } , 
                    child:const Text("Sign in",style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),)
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: size.height*.13),
                  height: size.height*.25,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/register.png"),
                      fit: BoxFit.fitHeight
                  ),
                ),
              ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}