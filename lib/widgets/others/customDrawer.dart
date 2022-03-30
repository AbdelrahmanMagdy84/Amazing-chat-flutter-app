import 'dart:io';

import 'package:amazing_chat/provider/user_Provider.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  String imageUrl;
  String username;
  CustomDrawer(this.imageUrl, this.username);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  bool isLaoding = false;
  final usernameController = TextEditingController();
  String? error;
  late AnimationController _animationController;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;
  bool showInputWidget = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _positionAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOutBack));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutBack));
  }

  Future<void> chooseImage() async {
    XFile? tempFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 70, maxWidth: 200);
    var temp = tempFile;
    if (temp != null) {
      setState(() {
        isLaoding = true;
      });
      await Provider.of<CurrentUserProvider>(context, listen: false)
          .updateImage(File(tempFile!.path));
      setState(() {
        isLaoding = false;
      });
    }
  }

  //validator is missing from save button
  bool validate(TextEditingController amountControlleragru) {
    if (amountControlleragru.text.isEmpty) {
      setState(() {
        error = "can't be empty";
      });
      return false;
    }
    if (amountControlleragru.text.length < 5) {
      setState(() {
        error = "At least 5 characters";
      });
      return false;
    }

    error = null;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          radius: 100,
                          child: isLaoding
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                )
                              : null,
                          backgroundImage:
                              isLaoding ? null : NetworkImage(widget.imageUrl),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 20,
                          child: IconButton(
                            onPressed: chooseImage,
                            icon: const Icon(
                              Icons.image,
                              size: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 20,
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Username",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                          FittedBox(
                                            child: Text(
                                              widget.username,
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                showInputWidget =
                                                    !showInputWidget;
                                                if (showInputWidget == true) {
                                                  _animationController
                                                      .forward();
                                                } else {
                                                  _animationController
                                                      .reverse();
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: SlideTransition(
                                position: _positionAnimation,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: SizedBox(
                                          height: 70,
                                          child: TextField(
                                            controller: usernameController,
                                            textAlign: TextAlign.center,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            keyboardType: TextInputType.text,
                                            maxLength: 18,
                                            decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15),
                                                ),
                                              ),
                                              errorText: error,
                                              label: Container(
                                                alignment: Alignment.center,
                                                child:
                                                    const Text("New Username"),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: ElevatedButton(
                                          child: FittedBox(
                                              child: Text(
                                            "Save",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                          )),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                          ),
                                          onPressed: () async {
                                            FocusScope.of(context).unfocus();
                                            if (validate(usernameController)) {
                                              await Provider.of<
                                                          CurrentUserProvider>(
                                                      context,
                                                      listen: false)
                                                  .updateUsername(
                                                      usernameController.text);
                                              setState(() {
                                                showInputWidget =
                                                    !showInputWidget;
                                                _animationController.reverse();
                                                usernameController.clear();
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
