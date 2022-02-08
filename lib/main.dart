import './screens/auth_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
      title: 'Amazing Chat',
      theme: theme.copyWith(
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom()),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                primary: Colors.pink,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)))),
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.pink,
          background: Colors.pink,
          secondary: Colors.deepPurple,
          brightness: ThemeData.estimateBrightnessForColor(Colors.deepPurple),
        ),
      ),
      home: AuthScreen(),
    );
  }
}
