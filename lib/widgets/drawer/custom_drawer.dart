import 'dart:io';
import 'package:amazing_chat/provider/user_Provider.dart';
import 'package:amazing_chat/widgets/drawer/profile_image_widget.dart';
import 'package:amazing_chat/widgets/drawer/username_card_widget.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
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
  bool isLoading = false;
  late AnimationController _animationController;
  String? error;
  bool showInputWidget = false;

  @override
  initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
  }

  Future<void> chooseImage(BuildContext context) async {
    XFile? tempFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 70, maxWidth: 500);
    var temp = tempFile;
    if (temp != null) {
      setState(() {
        isLoading = true;
      });
      await Provider.of<CurrentUserProvider>(context, listen: false)
          .updateImage(File(tempFile!.path));
      setState(() {
        isLoading = false;
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
        FocusScope.of(context).unfocus();
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizerUtil.orientation == Orientation.portrait
                      ? ClipPath(
                          clipper: WaveClipper(),
                          child: Container(
                            height: constraints.maxHeight * 0.3,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      : SizedBox(
                          height: constraints.maxHeight * 0.05,
                        ),
                  ProfileImageWidget(
                      constraints: constraints,
                      isLoading: isLoading,
                      imageUrl: widget.imageUrl,
                      chooseImage: chooseImage),
                  SizedBox(
                    height: constraints.maxHeight * 0.03,
                  ),
                  Column(
                    children: [
                      UsernameCardWidget(
                          widget.username, showAnimatedContainer),
                      AnimatedContainerBuilder(
                          _animationController, saveUsername),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}
