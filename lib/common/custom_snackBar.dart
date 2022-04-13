import 'package:flutter/material.dart';

class CustomSnackBar {
  static void renderSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).errorColor),
      ),
    ));
  }
}
