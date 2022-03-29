import 'package:amazing_chat/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String uid;
  final String username;
  final String message;

  final String imageUrl;
 const MessageBubble(this.message, this.uid, this.username, this.imageUrl,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isMe = user!.uid == uid;
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
              username,
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
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        radius: 15,
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                    Flexible(fit: FlexFit.loose, child: container),
                    if (isMe)
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        radius: 15,
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                  ],
                ),
              ]),
            ),
            if (!isMe) Expanded(child: Container())
          ]),
    );
  }
}
