import 'dart:io';
import 'package:flutter/material.dart';

class ImageAuth extends StatefulWidget {
  final Future<File?> Function() pickImage;
  ImageAuth(this.pickImage);
  @override
  _ImageAuthState createState() => _ImageAuthState();
}

class _ImageAuthState extends State<ImageAuth> {
  File? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CircleAvatar(
        radius: 52,
        backgroundColor:Theme.of(context).colorScheme.primary,
        child: CircleAvatar(
          radius: 50,
          
          backgroundImage:
              pickedImage == null ? null : FileImage(pickedImage!, scale: .1),
          backgroundColor: Colors.grey,
        ),
      ),
      TextButton.icon(
          onPressed: () async {
            File? x = await widget.pickImage();
            setState(() {
              pickedImage = x;
            });
          },
          icon: const Icon(Icons.image),
          label: const Text("Choose your image"))
    ]);
  }
}
