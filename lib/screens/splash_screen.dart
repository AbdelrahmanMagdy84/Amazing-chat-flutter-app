import 'package:amazing_chat/app_bar_title_widget.dart';
import 'package:amazing_chat/screens/all_chats_screen.dart';
import 'package:amazing_chat/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  // bool hasData;
  // SplashScreen(this.hasData);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showSplash = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), (() {
      setState(() {
        showSplash = false;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: showSplash
            ? SplashWidget()
            : StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context,
                    AsyncSnapshot<dynamic> streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return SplashWidget();
                  }
                  if (streamSnapshot.hasData) {
                    return AllchatsScreen(FirebaseAuth.instance.currentUser);
                  } else {
                    return AuthScreen();
                  }
                },
              ));
  }
}

class SplashWidget extends StatelessWidget {
  const SplashWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.primary,
                body: Column(
                  children: [
    ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: 200,
        color: Theme.of(context).colorScheme.secondary,
      ),
    ),
    Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AppBarTitle(50),
      ),
    )
                  ],
                ),
              );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height);

    var firstStart = Offset(size.width / 4, size.height);

    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);

    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105);

    var secondEnd = Offset(size.width, size.height - 10);

    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
