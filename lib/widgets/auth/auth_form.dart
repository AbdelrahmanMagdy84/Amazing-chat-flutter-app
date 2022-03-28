import 'dart:io';

import 'package:amazing_chat/widgets/others/app_bar_title_widget.dart';
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
  bool isValid = false;
  bool validUsername = true;
  bool validEmail = true;
  bool validPassword = true;

  void _trySubmit() {
    if (pickedImage == null && !isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "please choose an image",
          ),
        ),
      );
      return;
    }
    setState(() {
      isValid = _formKey.currentState!.validate();
    });

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
        source: ImageSource.gallery, imageQuality: 100, maxWidth: 150);
    pickedImage = File(tempFile!.path);
    return pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Card(
            elevation: 22,
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        !isLogin
                            ? ImageAuth(chooseImage)
                            : Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  height: 50,
                                  child: Text(
                                    "WELCOME BACK",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                  ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            height: validEmail ? 40 : 60,
                            child: TextFormField(
                              key: const ValueKey('email'),
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  setState(() {
                                    validEmail = false;
                                  });
                                  return 'Please enter a valid Email';
                                }
                                setState(() {
                                  validEmail = true;
                                });
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                label: Text("Email Address"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                              ),
                              onSaved: (value) {
                                userEmail = value!;
                              },
                            ),
                          ),
                        ),
                        if (!isLogin)
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              height: validUsername ? 40 : 60,
                              child: TextFormField(
                                key: ValueKey('username'),
                                textCapitalization: TextCapitalization .words,
                                keyboardType: TextInputType.text,
                                keyboardAppearance: Brightness.light,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 5) {
                                    setState(() {
                                      validUsername = false;
                                    });
                                    return "Please enter at least 5 characters";
                                  }
                                  setState(() {
                                    validUsername = true;
                                  });
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  label: Text("Username"),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                ),
                                onSaved: (value) {
                                  userName = value!;
                                },
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            height: validPassword ? 40 : 60,
                            child: TextFormField(
                              key: ValueKey('password'),
                              validator: (value) {
                                if (value!.isEmpty || value.length < 8) {
                                  setState(() {
                                    validPassword = false;
                                  });
                                  return "Password must be greater than 8 characters";
                                }
                                setState(() {
                                  validPassword = true;
                                });
                                return null;
                              },
                              decoration: const InputDecoration(
                                constraints: BoxConstraints(
                                    minWidth: 100,
                                    maxHeight: 50,
                                    minHeight: 40),
                                label: Text("Password"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                              ),
                              onSaved: (value) {
                                userPassword = value!;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        if (widget.isLoading) CircularProgressIndicator(),
                        if (!widget.isLoading)
                          ElevatedButton(
                            onPressed: () {
                              _trySubmit();
                            },
                            child: Text(
                              isLogin ? "Login" : "Sign up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
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
      ),
    );
  }
}
