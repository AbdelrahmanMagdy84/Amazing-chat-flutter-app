import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class NewMessage extends StatefulWidget {
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  late final _enterdMessageController;
  @override
  void initState() {
    // TODO: implement initState
    _enterdMessageController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  void sendMessage() async {
    String message = _enterdMessageController.text;
    message = message.trim();
    FocusScope.of(context).unfocus();
    var user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection("chat").add(
      {
        "text": message,
        "createdAt": Timestamp.now(),
        "userId": user.uid,
        "username": userData["username"],
        "userImage":userData["imageUrl"]
      },
    );

    _enterdMessageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _enterdMessageController,
              decoration: InputDecoration(
                label: Text("Send message..."),
              ),
            ),
          ),
          IconButton(
            onPressed:
                _enterdMessageController.text.isEmpty ? null : sendMessage,
            icon: Icon(
              Icons.send,
            ),
          )
        ],
      ),
    );
  }
}
