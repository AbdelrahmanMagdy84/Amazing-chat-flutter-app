import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
        radius: 50,
        backgroundImage:
            pickedImage == null ? null : FileImage(pickedImage!, scale: .1),
        backgroundColor: Colors.grey,
      ),
      const SizedBox(
        height: 5,
      ),
      TextButton.icon(
          onPressed: () async {
            File? x = await widget.pickImage();
            setState(() {
              pickedImage = x;
            });
          },
          icon: const Icon(Icons.image),
          label: const Text("Add your image"))
    ]);
  }
}
