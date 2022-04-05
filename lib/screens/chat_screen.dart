import 'package:amazing_chat/provider/user_Provider.dart';
import 'package:amazing_chat/widgets/chat/messages.dart';
import 'package:amazing_chat/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

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
            }).then((newDoc) {
              setState(() {
                roomDocId = newDoc.id;
              });
            });
          }
        });
  }

  void sendMessage(String message, String? roomDoc, BuildContext ctx) {
    FocusScope.of(ctx).unfocus();
    FirebaseFirestore.instance
        .collection("chats")
        .doc(roomDoc)
        .collection("room")
        .add(
      {
        "text": message,
        "createdAt": Timestamp.now(),
        "userId": FirebaseAuth.instance.currentUser!.uid,
      },
    );
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
            Expanded(
                flex: 4,
                child: Consumer<CurrentUserProvider>(
                  builder: (context, currentUser, _) {
                    return TitleColumnWidget(
                        friendImageUrl: currentUser.getData["imageUrl"],
                        friendUsername: currentUser.getData["username"]);
                  },
                ))
          ],
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondary,
        ),
        toolbarHeight: 80,
      ),
      body: roomDocId == null
          ? Center(child: Text("Loading"))
          : Container(
              child: Column(
                children: [
                  Expanded(
                    child: Messages(
                        roomDocId: roomDocId,
                        friendData: {
                          "username": friendUsername!,
                          "uid": friendId!,
                          "imageUrl": friendImageUrl!
                        },
                        sendMessage: sendMessage),
                  ),
                  NewMessage(sendMessage, roomDocId),
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
  //  FutureBuilder(
      //   future: FirebaseFirestore.instance.collection('chats').add({
      //     "users": {
      //       FirebaseAuth.instance.currentUser!.uid: null,
      //       friendId: null
      //     }
      //   }),
      //   builder: (context, AsyncSnapshot<DocumentReference> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Container();
      //     }
      //     return Container(
      //       child: Column(
      //         children: [
      //           Expanded(
      //             child: Messages(
      //                 roomDocId: snapshot.data!.id,
      //                 friendData: {
      //                   "username": friendUsername!,
      //                   "uid": friendId!,
      //                   "imageUrl": friendImageUrl!
      //                 },
      //                 sendMessage: sendMessage),
      //           ),
      //           NewMessage(sendMessage, snapshot.data!.id),
      //         ],
      //       ),
      //     );
      //   },
      // ):