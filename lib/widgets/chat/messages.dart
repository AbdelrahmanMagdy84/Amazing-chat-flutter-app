import 'package:amazing_chat/widgets/chat/single_message_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  final String? roomDocId;
  Messages(this.roomDocId);
  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
  
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chats")
          .doc(widget.roomDocId)
          .collection("room")
          .orderBy("createdAt",descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const  Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = streamSnapshot.data!.docs;
        if (messages.isNotEmpty) {
          return ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return SingleMessageWidget(
                  messages[index]['text'],
                  messages[index]["userId"],
                  messages[index]["username"],
                  messages[index]["userImage"],
                  ValueKey(messages[index].id));
            },
          );
        }
        return Center(
          child: Text("Say Hi"),
        );
      },
    );
  }
}
