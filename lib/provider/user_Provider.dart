import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class CurrentUserProvider with ChangeNotifier {
  Map<String, String> _data = {};
  Map<String, String> get getData {
    return _data;
  }

  Future<void> setData() async {
    await Future.delayed(const Duration(seconds: 5), (() async {
      try {
        final userData = await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        _data = {
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "username": userData.data().toString().contains('username')
              ? userData.get('username')
              : '',
          "imageUrl": userData.data().toString().contains('imageUrl')
              ? userData.get('imageUrl')
              : ''
        };
        notifyListeners();
       
      } catch (e) {
        print(e.toString());
      }
    }));
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

  void clear() {
    _data = {};
    notifyListeners();
  }
}
