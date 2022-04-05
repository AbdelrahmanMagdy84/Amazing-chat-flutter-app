import 'dart:io';
import 'package:amazing_chat/provider/user_Provider.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../common/wave_clipper.dart';
import 'custom_animated_container.dart';

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

  late AnimationController _animationController;
  String? error;

  bool showInputWidget = false;
  @override
  initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
  }

  Future<void> chooseImage() async {
    XFile? tempFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 70, maxWidth: 500);
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

  Future<void> saveUsername(
      Function validate, TextEditingController usernameController) async {
    FocusScope.of(context).unfocus();
    if (validate(usernameController)) {
      await Provider.of<CurrentUserProvider>(context, listen: false)
          .updateUsername(usernameController.text);
      setState(() {
        showInputWidget = !showInputWidget;
        _animationController.reverse();
        usernameController.clear();
      });
    }
  }

  void showAnimatedContainer() {
    setState(() {
      showInputWidget = !showInputWidget;
      if (showInputWidget == true) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Container(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: 200,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        radius: 101,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 100,
                          child: isLaoding
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                )
                              : null,
                          backgroundImage:
                              isLaoding ? null : NetworkImage(widget.imageUrl),
                          onBackgroundImageError: isLaoding ? null : (_, __) {},
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 20,
                        child: IconButton(
                          onPressed: chooseImage,
                          icon: const Icon(
                            Icons.image_sharp,
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
                                              fontSize: 16, color: Colors.grey),
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
                                          onPressed: showAnimatedContainer,
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
                      AnimatedContainerBuilder(
                          _animationController, saveUsername),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
