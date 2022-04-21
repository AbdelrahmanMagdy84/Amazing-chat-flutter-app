import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final double? size;
  // ignore: use_key_in_widget_constructors
  const AppBarTitle(this.size);
  Widget textBuilder(String text, BuildContext ctx) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(ctx).colorScheme.secondary,
      ).copyWith(fontSize: size),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: [
          textBuilder("Amazing", context),
          Icon(
            Icons.handshake_outlined,
            color: Theme.of(context).colorScheme.secondary,
            size: size,
          ),
          textBuilder("Chat", context)
        ],
      ),
    );
  }
}
