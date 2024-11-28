import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar(
      {super.key,
      required this.message,
      required this.type,
      this.duration = 3});

  final String message;
  final int duration;
  final String type;

  @override
  Widget build(BuildContext context) {
    return selectType();
  }

  SnackBar selectType() {
    switch (type) {
      case "error":
        return SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: duration),
        );
      case "success":
        return SnackBar(
          content: Row(children: [
            Icon(Icons.thumb_up, color: Colors.white),
            SizedBox(width: 20),
            Expanded(child: Text(message))
          ]),
          backgroundColor: Colors.green,
          duration: Duration(seconds: duration),
        );
      case "warning":
        return SnackBar(
          content: Text(message),
          backgroundColor: Colors.yellow,
          duration: Duration(seconds: duration),
        );
      default:
        return SnackBar(
          content: Text(message),
          backgroundColor: Colors.grey,
          duration: Duration(seconds: duration),
        );
    }
  }
}
