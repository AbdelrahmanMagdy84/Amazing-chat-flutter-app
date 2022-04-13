import 'package:amazing_chat/provider/user_Provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../widgets/chat widgets/messages.dart';
import '../widgets/chat widgets/new_message.dart';
import '../widgets/chat widgets/title_column_widget.dart';
import 'package:sizer/sizer.dart';

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
    FocusScope.of(ctx).unfocus();
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
        toolbarHeight: 
       SizerUtil.orientation == Orientation.portrait ? 80 : 40,
      ),
      body: roomDocId == null
          ? const Center(child: Text("Loading"))
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
