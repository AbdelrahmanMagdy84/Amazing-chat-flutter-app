import 'dart:io';

import 'package:amazing_chat/widgets/auth/image_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
      {required String email,
      required String username,
      required String password,
      required File? image,
      required bool isLogin,
      required BuildContext ctx}) submitFun;
  final bool isLoading;
  AuthForm(this.submitFun, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = false;
  String userEmail = '';
  String userName = '';
  String userPassword = '';
  File? pickedImage;

  void _trySubmit() {
    if (pickedImage == null && !isLogin) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("please choose an image")));
      return;
    }
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFun(
          email: userEmail.trim(),
          username: userName.trim(),
          password: userPassword.trim(),
          image: pickedImage,
          isLogin: isLogin,
          ctx: context);
    }
  }

  Future<File?> chooseImage() async {
    XFile? tempFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    pickedImage = File(tempFile!.path);
    return pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Card(
            elevation: 22,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isLogin) ImageAuth(chooseImage),
                      TextFormField(
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid Email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          label: const Text("Email Address"),
                        ),
                        onSaved: (value) {
                          userEmail = value!;
                        },
                      ),
                      if (!isLogin)
                        TextFormField(
                          key: ValueKey('username'),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 5) {
                              return "Please enter at least 5 characters";
                            }
                            return null;
                          },
                          decoration: InputDecoration(label: Text("Username")),
                          onSaved: (value) {
                            userName = value!;
                          },
                        ),
                      TextFormField(
                        key: ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 8) {
                            return "Password must be greater than 8 characters";
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(label: Text('Password')),
                        onSaved: (value) {
                          userPassword = value!;
                        },
                      ),
                      SizedBox(height: 20),
                      if (widget.isLoading) CircularProgressIndicator(),
                      if (!widget.isLoading)
                        ElevatedButton(
                          
                          onPressed: () {
                            _trySubmit();
                          },
                          child: Text(
                            isLogin ? "Login" : "Signup",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      SizedBox(height: 5),
                      if (!widget.isLoading)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(
                            isLogin
                                ? "Create a new acount"
                                : "I already have an acount",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
