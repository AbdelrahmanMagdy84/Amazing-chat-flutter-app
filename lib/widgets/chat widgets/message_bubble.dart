import 'package:amazing_chat/main.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String username;
  final String message;
  final String imageUrl;
  const MessageBubble(this.message, this.isMe, this.username, this.imageUrl,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var container = Container(
      padding: const EdgeInsets.only(
        right: 10,
        left: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: isMe
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(15),
          topLeft: const Radius.circular(15),
          bottomRight:
              isMe ? const Radius.circular(30) : const Radius.circular(15),
          bottomLeft:
              isMe ? const Radius.circular(15) : const Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: Text(
              username == "" ? "      " : username,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isMe
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              message,
              maxLines: 10,
              style: CustomTextStyle.customHeadline6(context)
                  .copyWith(color: isMe ? null : Colors.black),
            ),
          ),
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (isMe) Expanded(child: Container()),
            Flexible(
              flex: 3,
              fit: FlexFit.loose,
              child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isMe)
                      circleAvatar(
                          context, Theme.of(context).colorScheme.secondary),
                    Flexible(fit: FlexFit.loose, child: container),
                    if (isMe)
                      circleAvatar(
                          context, Theme.of(context).colorScheme.primary),
                  ],
                ),
              ]),
            ),
            if (!isMe) Expanded(child: Container())
          ]),
    );
  }

  CircleAvatar circleAvatar(BuildContext context, Color color) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 15,
      backgroundImage: imageUrl != "" ? NetworkImage(imageUrl) : null,
    );
  }
}
