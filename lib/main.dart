import 'package:amazing_chat/app_bar_title_widget.dart';
import 'package:amazing_chat/screens/all_chats_screen.dart';
import 'package:amazing_chat/screens/chat_screen.dart';
import 'package:amazing_chat/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/auth_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class CustomTextStyle {
  static TextStyle customHeadline6(BuildContext context) {
    return const TextStyle(
      color: Color(0xFFF5F5F5),
      fontSize: 16,
    );
  }
}

Color secondery = Color(0xFFE2D784);
Color primary = Color(0xFF05595B);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazing Chat',
      theme: theme.copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: primary,
        ),
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom()),
        iconTheme: IconThemeData(color: primary),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        colorScheme: theme.colorScheme.copyWith(
          primary: primary,
          background: secondery,
          secondary: secondery,
        ),
      ),
      routes: {ChatScreen.routeName: (ctx) => ChatScreen()},
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Scaffold(backgroundColor: Theme.of(context).colorScheme.primary,
            
            );
          }

          return SplashScreen();
        },
      ),
    );
  }
}
