import 'package:findme/color/color.dart';
import 'package:findme/color/ellisse.dart';
import 'package:findme/page/selector_page.dart';
import 'package:findme/page/tree.dart';
import 'package:findme/page/welcome.dart';
import 'package:findme/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:location/location.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final controller = PageController();
  bool isLastPage = false;
  String title1 = 'WE WELCOME YOU';
  String subtitle1 = 'Hello! This application will help you to keep in touch with your friends';
  String title2 = 'Find Me';
  String subtitle2 = 'Share location with your friends';
  String title3 = "Let's Start";
  String subtitle3 = 'Now register or login in our app ';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buidPage(
      {required Color color,
      required String urlimage,
      required String title,
      required String subtitle,
      required Size size}) {
    return Container(
        color: const Color(0xff7ab4dc),
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: size.height * .2,
                    ),
                    Container(
                      color: Colors.white,
                      height: size.height * .5,
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: size.height * .05,
                    ),
                    Container(
                      height: size.height * .5,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(urlimage),
                              fit: BoxFit.fitHeight)),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text.textColor),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: size.height * .02,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                        subtitle,
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text.heading),
                      ),
            ),
          ],
        ));
  }

  reqestPermission() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: PageView(
          controller: controller,
          onPageChanged: (value) {
            if (value == 1) {
              reqestPermission();
            }
            setState(() {
              isLastPage = value == 2;
            });
          },
          children: [
            buidPage(
                color: Color(0xff7ab4dc),
                urlimage: 'assets/introPage1.png',
                title: title1,
                subtitle: subtitle1,
                size: size),
            buidPage(
                color: Color(0xff7ab4dc),
                urlimage: 'assets/introPage2.png',
                title: title2,
                subtitle: subtitle2,
                size: size),
            buidPage(
                color: Color(0xff7ab4dc),
                urlimage: 'assets/introPage3.png',
                title: title3,
                subtitle: subtitle3,
                size: size),
          ],
        ),
      ),
      bottomSheet: !isLastPage
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        controller.jumpToPage(3);
                      },
                      child: const Text('SKIP')),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                          spacing: 8,
                          dotColor: Colors.black26,
                          activeDotColor: AppColors.container.background),
                      onDotClicked: (index) {
                        controller.animateToPage(index,
                            duration: const Duration(microseconds: 500),
                            curve: Curves.easeIn);
                      },
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: const Text('NEXT')),
                ],
              ),
            )
          : Container(
              color: AppColors.container.background,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              width: size.width,
              child: TextButton(
                  style: TextButton.styleFrom(
                      minimumSize: Size.fromHeight(80),
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.container.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      )),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: WelcomePage(),
                            type: PageTransitionType.rightToLeft));
                  },
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 24),
                  ))),
    );
  }
}
