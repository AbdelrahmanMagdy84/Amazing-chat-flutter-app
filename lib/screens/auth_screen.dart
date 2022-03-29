import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;
  void toggleIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> _submitFn({
    required String email,
    required String username,
    required String password,
    required File? image,
    required bool isLogin,
    required BuildContext ctx,
  }) async {
    UserCredential userCredential;
    final auth = FirebaseAuth.instance;
    try {
      toggleIsLoading();
      if (isLogin) {
        userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child("users_images")
            .child(userCredential.user!.uid + '.jpg');
        await ref.putFile(image!).whenComplete(() => null);
        final imageUrl = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({'username': username, "email": email, "imageUrl": imageUrl});
      }
    } on FirebaseAuthException catch (err) {
      toggleIsLoading();
      String message = "an error accured, please chech your credentials";
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      )));
    } catch (error) {
      toggleIsLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthForm(_submitFn, isLoading);
  }
}
