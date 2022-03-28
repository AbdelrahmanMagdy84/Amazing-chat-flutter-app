import 'package:amazing_chat/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  final String? roomDocId;
  final String? FriendId;
  
  Messages({required this.roomDocId, required this.FriendId
   
      });
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
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = streamSnapshot.data!.docs;
        if (messages.isNotEmpty) {
          return ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return MessageBubble(
                  messages[index]['text'],
                  messages[index]["userId"],
                  messages[index]["username"],
                  messages[index]["userImage"],
                  ValueKey(messages[index].id));
            },
          );
        }
        return FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(widget.FriendId!)
              .get(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    radius: 50,
                    backgroundImage:
                        NetworkImage(snapshot.data!["imageUrl"] as String),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  FittedBox(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      child: Text(
                        snapshot.data!["username"] as String,
                        style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "Say Hi 👋",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
