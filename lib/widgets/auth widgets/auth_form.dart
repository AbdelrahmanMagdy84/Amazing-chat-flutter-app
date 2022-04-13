import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/custom_snackBar.dart';
import 'image_auth.dart';
import 'password_checker.dart';
import '../../helpers/auth_helpers';

class AuthForm extends StatefulWidget {
  final bool isLoading;
   Function({
    required String email,
    required String username,
    required String password,
    required File? image,
    required bool isLogin,
    required BuildContext ctx,
  }) submitFun;
  AuthForm(this.submitFun,this.isLoading);
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
  bool upperCase = false;
  bool lowerCase = false;
  bool hasNumber = false;
  bool validPasswordLength = false;
  int passwordLenght = 0;
  double? fieldHeight(bool valid) {
    return valid ? 40 : 55;
  }

  void _trySubmit() {
    if (pickedImage == null && !isLogin) {
      CustomSnackBar.renderSnackBar(("Please choose an image"), context);
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
        source: ImageSource.gallery, imageQuality: 70, maxWidth: 500);
    pickedImage = File(tempFile!.path);
    return pickedImage;
  }

  void checkPassword(String value) {
    if (!isLogin) {
      if (passwordLenght > value.length) {
        setState(() {
          upperCase = false;
          lowerCase = false;
          hasNumber = false;
          validPasswordLength = false;
          passwordLenght = value.length;
        });
      }
      setState(() {
        passwordLenght = value.length;
      });

      if (RegExp(r'^(?=.*?[A-Z])').hasMatch(value)) {
        setState(() {
          upperCase = true;
        });
      }
      if (RegExp(r'^(?=.*[a-z])').hasMatch(value)) {
        setState(() {
          lowerCase = true;
        });
      }
      if (RegExp("(?=.*?[0-9])").hasMatch(value)) {
        setState(() {
          hasNumber = true;
        });
      }
      if (RegExp('^.{8,15}').hasMatch(value)) {
        setState(() {
          validPasswordLength = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const fieldPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Card(
            color: Theme.of(context).colorScheme.primary,
            elevation: 22,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(70),
                    topRight: Radius.circular(70)),
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          padding: fieldPadding.copyWith(
                              bottom: validEmail ? 15 : 5),
                          child: SizedBox(
                            height: fieldHeight(validEmail),
                            child: TextFormField(
                              key: const ValueKey('email'),
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                final regExp = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                                if (!regExp.hasMatch(value!)) {
                                  setState(() {
                                    validEmail = false;
                                  });

                                  return 'Please enter a valid email';
                                }

                                setState(() {
                                  validEmail = true;
                                });
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                errorStyle: TextStyle(height: 0.5),
                                label: Text("Email Address"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                              ),
                              onSaved: (value) {
                                userEmail = value!.toLowerCase();
                              },
                            ),
                          ),
                        ),
                        if (!isLogin)
                          Container(
                            margin: fieldPadding,
                            height: 55,
                            child: TextFormField(
                              key: const ValueKey('username'),
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              maxLength: 18,
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
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                errorStyle: TextStyle(height: 0),
                                counterStyle: TextStyle(height: 0.5),
                                label: Text("Username"),
                                hintText: "should be at least 5 chars",
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
                        Padding(
                          padding: fieldPadding,
                          child: SizedBox(
                            height: fieldHeight(validPassword),
                            child: TextFormField(
                              key: const ValueKey('password'),
                              onChanged: (value) {
                                checkPassword(value);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  setState(() {
                                    validPassword = false;
                                  });
                                  return "Please enter password";
                                }
                                final regExp = RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,15}$');
                                if (!regExp.hasMatch(value)) {
                                  setState(() {
                                    validPassword = false;
                                  });
                                  return "Enter valid password";
                                }
                                setState(() {
                                  validPassword = true;
                                });
                                return null;
                              },
                              decoration: const InputDecoration(
                                errorStyle: TextStyle(height: 0.5),
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
                        if (!isLogin)
                          FittedBox(
                            child: PasswordChecker(
                                upperCase: upperCase,
                                lowerCase: lowerCase,
                                hasNumber: hasNumber,
                                validPasswordLength: validPasswordLength),
                          ),
                        const SizedBox(height: 20),
                        if (widget.isLoading) const CircularProgressIndicator(),
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
                        const SizedBox(height: 5),
                        if (!widget.isLoading)
                          TextButton(
                            onPressed: () {
                              _formKey.currentState!.reset();
                              setState(() {
                                upperCase = false;
                                lowerCase = false;
                                hasNumber = false;
                                validPasswordLength = false;
                                passwordLenght = 0;
                                validEmail = true;
                                validUsername = true;
                                validPassword = true;
                                isLogin = !isLogin;
                              });
                            },
                            child: Text(
                              isLogin
                                  ? "Create a new acount"
                                  : "I already have an acount",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
