import 'package:flutter/material.dart';

class NotificationCounter extends StatelessWidget {
  // Variables
  final Widget icon;
  final int counter;

  NotificationCounter({required this.icon, required this.counter});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        icon,
        new Positioned(
          right: 0,
          child: new Container(
            padding: EdgeInsets.all(3),
            decoration: new BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: new Text(
              counter > 9 ? "9+" : "$counter",
              style: new TextStyle(color: Colors.white, fontSize: counter > 9 ? 12 : 15),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
