import 'package:amazing_chat/provider/user_Provider.dart';
import 'package:amazing_chat/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  final String? roomDocId;
  final Map<String, String> friendData;

  Messages({
    required this.roomDocId,
    required this.friendData,
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
          return ListViewBuilder(
            messages: messages,
            friendUsername: widget.friendData["username"]!,
            friendImageUrl: widget.friendData["imageUrl"]!,
          );
        }

        return NoMessagesWidget(
          friendUsername: widget.friendData["username"]!,
          friendImageUrl: widget.friendData["imageUrl"]!,
        );
      },
    );
  }
}

class NoMessagesWidget extends StatelessWidget {
  const NoMessagesWidget({
    Key? key,
    required this.friendImageUrl,
    required this.friendUsername,
  }) : super(key: key);

  final String friendUsername;
  final String friendImageUrl;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            radius: 50,
            backgroundImage: NetworkImage(friendImageUrl),
          ),
          const SizedBox(
            height: 8,
          ),
          FittedBox(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: Text(
                friendUsername,
                style: TextStyle(
                    fontSize: 24, color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
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
  }
}

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({
    Key? key,
    required this.messages,
    required this.friendUsername,
    required this.friendImageUrl,
  }) : super(key: key);

  final List<QueryDocumentSnapshot<Object?>> messages;
  final String friendUsername;
  final String friendImageUrl;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        if (FirebaseAuth.instance.currentUser!.uid ==
            messages[index]["userId"]) {
          return Consumer<CurrentUserProvider>(
            builder: ((context, currentUser, _) {
              return MessageBubble(
                  messages[index]['text'],
                  true,
                  currentUser.getData["username"]!,
                  currentUser.getData["imageUrl"]!,
                  key: ValueKey(messages[index].id));
            }),
          );
        }
        return MessageBubble(
            messages[index]['text'], false, friendUsername, friendImageUrl,
            key: ValueKey(messages[index].id));
      },
    );
  }
}
