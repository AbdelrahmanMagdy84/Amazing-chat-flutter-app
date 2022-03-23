import 'package:amazing_chat/widgets/chat/single_message_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = streamSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            print(messages[index].id);
            return SingleMessageWidget(
                messages[index]['text'],
                messages[index]["userId"],
                messages[index]["username"],
                messages[index]["userImage"],
                ValueKey(messages[index].id));
          },
        );
      },
    );
  }
}
