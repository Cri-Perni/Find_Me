import 'package:flutter/material.dart';



class ErrorScreen extends StatefulWidget {
  ErrorScreen({super.key, Object? error});
  Object? error;

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Si è verificato un errore${widget.error}',style: const TextStyle(color: Colors.white,fontSize: 24),),
          ],
        ),
      ),
    );
  }
}
