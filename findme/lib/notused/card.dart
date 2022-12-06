import 'package:flutter/material.dart';

class Cards extends StatefulWidget {
  String username;
  Cards({super.key,required this.username});

  @override
  State<Cards> createState() => _CardState();
}

class _CardState extends State<Cards> {
  
  @override
  Widget build(BuildContext context) {
     return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: Colors.amber,),
            Text(widget.username),
            Text('Click For Manage')
          ],
        ),
      ),
    );
  }
}