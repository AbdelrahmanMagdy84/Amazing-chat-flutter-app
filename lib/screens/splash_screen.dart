import 'dart:io';

import 'package:amazing_chat/widgets/others/app_bar_title_widget.dart';
import 'package:amazing_chat/screens/Friends_screen.dart';
import 'package:amazing_chat/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/wave_clipper.dart';
import '../provider/user_Provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showSplash = true;

  void displaySplashScreen() {
    Future.delayed(const Duration(seconds: 1), (() {
      setState(() {
        showSplash = false;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(child: const SplashWidget());
        }

        if (streamSnapshot.hasData) {
          return SafeArea(child: FriendsScreen());
        } else {
          return SafeArea(child: AuthScreen());
        }
      },
    );
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
      body: SingleChildScrollView(
        child: Column(
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
      ),
    );
  }
}
