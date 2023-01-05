import 'package:flutter/material.dart';


class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
     var size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: size.height,
      width: size.width,
    );
  }
}
