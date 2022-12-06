import 'package:findme/color/color.dart';
import 'package:findme/page/login.dart';
import 'package:findme/page/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:page_transition/page_transition.dart';





class WelcomePage extends StatelessWidget {
  WelcomePage({super.key});


  @override
  Widget build(BuildContext context) {
    

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: size.height,
          padding: EdgeInsets.symmetric(horizontal: size.width*0.10,vertical: size.height*0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.height*.05,
                      color: AppColors.container.background,
                    ),
                  ),
                  SizedBox(
                    height: size.height*.02,
                  ),
                  Text("Welcome to FindMe",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: size.height*.018,
                  ),
                 ),
                ],
              ),
              Container(
                height: size.height*.2,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/welcome.png"),
                    fit: BoxFit.fitHeight
                  )
                ),
              ),
              Column(
                children: [
                  //Login
                  MaterialButton(
                    minWidth: double.infinity,
                    height: size.height*0.072,
                    onPressed: () {
                      //Navigator.push(context, MaterialPageRoute(builder: ((context) => LoginPage())));
                      Navigator.push(context, PageTransition(child: LoginPage(), type: PageTransitionType.rightToLeft));
                    },
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.black
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: size.height*.022,
                        
                      ),
                    ),
                  ),
                  SizedBox(height: size.height*0.02,),
                  MaterialButton(
                    color: AppColors.container.background,
                    minWidth: double.infinity,
                    height: size.height*0.072,
                    onPressed: () {
                      Navigator.push(context, PageTransition(child: RegisterPage(), type: PageTransitionType.rightToLeft));
                    },
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.black
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: size.height*.022,
                        color: Colors.white,
                        
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}