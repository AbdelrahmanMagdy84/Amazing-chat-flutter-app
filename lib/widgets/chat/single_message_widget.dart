import 'package:amazing_chat/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SingleMessageWidget extends StatelessWidget {
  final String uid;
  final String username;
  final String message;
  final Key key;
  final String imageUrl;
  SingleMessageWidget(
      this.message, this.uid, this.username, this.imageUrl, this.key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isMe = user!.uid == uid;
    var container = Container(
      // margin:
      //     EdgeInsets.only(right: isMe ? 30 : 0, left: isMe ? 0 : 30, ),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: isMe ? Colors.green : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.only(
          topRight:
              isMe ? const Radius.circular(15) : const Radius.circular(15),
          topLeft: const Radius.circular(15),
          bottomRight:
              isMe ? const Radius.circular(30) : const Radius.circular(15),
          bottomLeft:
              isMe ? const Radius.circular(15) : const Radius.circular(30),
        ),
      ),
      child: Text(
        message,
        maxLines: 10,
        style: CustomTextStyle.customHeadline6(context),
      ),
    );
    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMe) Expanded(child: Container()),
          Flexible(
            flex: 3,
            fit: FlexFit.loose,
            child: Column(children: [
              Container(
                  padding: EdgeInsets.only(right: isMe ? 5 : 0, left: 8),
                  child: Text(
                    username,
                    style: TextStyle(fontSize: 12),
                  )),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isMe)
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                    Flexible( fit: FlexFit.loose, child: container),
                    if (isMe)
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                  ],
                ),
              ),
            ]),
          ),
          if (!isMe) Expanded(child: Container())
        ]);
  }
}
