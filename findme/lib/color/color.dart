import 'package:flutter/material.dart';

// usage: Container(color: AppColors.container.background)
class AppColors {
  static _Container container = _Container();
  static _Scaffold scaffold = _Scaffold();
  static _Text text = _Text();
}

class _Container {
  Color background = const Color.fromRGBO(62, 146, 204, 1);
  Color backgroundark = const Color.fromARGB(126, 28, 58, 126);
  Color notify = const Color.fromRGBO(216, 49, 91, 1);
}

class _Scaffold {
  Color background = const Color.fromARGB(255, 250, 251, 255);
}

class _Text {
  Color heading = Colors.white;
  Color subheading = Colors.white38;
  Color textColor = const Color.fromRGBO(62, 146, 204, 1);
}
