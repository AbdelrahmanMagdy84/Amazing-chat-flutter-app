import 'package:amazing_chat/widgets/others/app_bar_title_widget.dart';
import 'package:amazing_chat/screens/friends_screen.dart';
import 'package:amazing_chat/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../common/wave_clipper.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const SafeArea(child: SplashWidget());
        }

        if (streamSnapshot.hasData) {
          
          return const SafeArea(child: FriendsScreen());
        } else {
          return const  SafeArea(child: AuthScreen());
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
                height: 25.h,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          const  Center(
              child: Padding(
                padding:  EdgeInsets.all(20),
                child: AppBarTitle(50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
