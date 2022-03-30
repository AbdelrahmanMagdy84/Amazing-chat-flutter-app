import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class CurrentUserProvider with ChangeNotifier {
  Map<String, String> _data = {};
  Map<String, String> get getData {
    print("using provider");
    return _data;
  }

  Future<void> setData() async {
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    _data = {
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "username": userData["username"],
      "imageUrl": userData["imageUrl"]
    };
    notifyListeners();
  }

  Future<void> updateImage(File? image) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("users_images")
        .child(_data["uid"]! + '.jpg');
    await ref.putFile(image!).whenComplete(() => null);
    final imageUrl = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_data["uid"]!)
        .update({"imageUrl": imageUrl});
    _data["imageUrl"] = imageUrl;
    notifyListeners();
  }

  Future<void> updateUsername(String username) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_data["uid"]!)
        .update({"username": username});
    _data["username"] = username;
    notifyListeners();
  }
}
