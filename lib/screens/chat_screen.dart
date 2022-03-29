import 'package:amazing_chat/widgets/chat/messages.dart';
import 'package:amazing_chat/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class ChatScreen extends StatefulWidget {
  static String routeName = "/chat_screen";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? roomDocId;
  String? friendId;
  String? friendUsername;
  String? friendImageUrl;
  String? currentUserImageUrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    friendId = data["friendId"];
    friendImageUrl = data["friendImage"];
    friendUsername = data["friendUsername"];
    FirebaseFirestore.instance
        .collection('chats')
        .where("users", isEqualTo: {
          FirebaseAuth.instance.currentUser!.uid: null,
          friendId: null
        })
        .limit(1)
        .get()
        .then((value) {
          if (value.docs.isNotEmpty) {
            setState(() {
              roomDocId = value.docs.single.id;
            });
          } else {
            FirebaseFirestore.instance.collection('chats').add({
              "users": {
                FirebaseAuth.instance.currentUser!.uid: null,
                friendId: null
              }
            }).then((value) {
              setState(() {
                roomDocId = value.id;
              });
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: TitleColumnWidget(
                  friendImageUrl: friendImageUrl,
                  friendUsername: friendUsername),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.handshake_outlined,
                color: Theme.of(context).colorScheme.secondary,
                size: 35,
              ),
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    flex: 4,
                    child: TitleColumnWidget(
                        friendImageUrl: null, friendUsername: null),
                  );
                }
                return Expanded(
                  flex: 4,
                  child: TitleColumnWidget(
                      friendImageUrl: snap.data!["imageUrl"],
                      friendUsername: snap.data!["username"]),
                );
              },
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondary,
        ),
        toolbarHeight: 80,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Messages(
              roomDocId: roomDocId,
              friendId: friendId,
            )),
            NewMessage(roomDocId),
          ],
        ),
      ),
    );
  }
}

class TitleColumnWidget extends StatelessWidget {
  const TitleColumnWidget({
    Key? key,
    required this.friendImageUrl,
    required this.friendUsername,
  }) : super(key: key);

  final String? friendImageUrl;
  final String? friendUsername;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          radius: 20,
          backgroundImage:
              friendImageUrl == null ? null : NetworkImage(friendImageUrl!),
        ),
        Container(
          width: 120,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5),
          child: Text(
            friendUsername == null ? "" : friendUsername!,
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      ],
    );
  }
}
