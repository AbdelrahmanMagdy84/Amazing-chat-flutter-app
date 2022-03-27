import 'package:amazing_chat/app_bar_title_widget.dart';
import 'package:amazing_chat/widgets/chat/messages.dart';
import 'package:amazing_chat/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  static String routeName = "/chat_screen";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? roomDocId;
  String? friendId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    friendId = ModalRoute.of(context)!.settings.arguments as String;
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
      centerTitle: true,
        title: AppBarTitle(null)
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Messages(roomDocId)),
            NewMessage(roomDocId),
         
          ],
        ),
      ),
    );

    // return SafeArea(
    //   child: FutureBuilder(
    //       future: Firebase.initializeApp(),
    //       builder: (context, snapshot) {
    //         if (snapshot.connectionState == ConnectionState.waiting) {
    //           return const Center(
    //             child: CircularProgressIndicator(),
    //           );
    //         }
    //         return Scaffold(
    //           appBar: AppBar(
    //             centerTitle: true,
    //             title: Text(
    //               "Amazing Chat",
    //               style: TextStyle(
    //                 color: Theme.of(context).colorScheme.secondary,
    //               ),
    //             ),
    //           ),
    //           body: Container(
    //             child: Column(
    //               children: [
    //                 Expanded(child: Messages(roomDocId)),
    //                 NewMessage(roomDocId),
    //               ],
    //             ),
    //           ),
    //         );
    //       }),
    // );
  }
}
