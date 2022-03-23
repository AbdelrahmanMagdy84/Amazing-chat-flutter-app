import 'package:amazing_chat/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/auth_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class CustomTextStyle {
  static TextStyle customHeadline6(BuildContext context) {
    return TextStyle(
      color: Colors.white,
      fontSize: 16,
    );
  }
  //   Theme.of(context)
  //       .textTheme
  //       .headline6!
  //       .copyWith(color: Colors.white, fontSize: 16);
  // }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
      title: 'Amazing Chat',
      theme: theme.copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink,
        ),
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom()),
        iconTheme: IconThemeData(color: Colors.pink),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.pink,
          background: Colors.pink,
          secondary: Colors.deepPurple,
          brightness: ThemeData.estimateBrightnessForColor(Colors.deepPurple),
        ),
        // textTheme: TextTheme(
        //   headline6: Theme.of(context)
        //       .textTheme
        //       .headline6!
        //       .copyWith(color: Colors.black, fontSize: 16),
        // ),
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder:
                (BuildContext context, AsyncSnapshot<dynamic> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ChatScreen();
              } else {
                return AuthScreen();
              }
            },
          );
        },
      ),
    );
  }
}
