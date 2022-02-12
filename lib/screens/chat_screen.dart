import 'package:amazing_chat/widgets/chat/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatScreen extends StatelessWidget {
  Future<void> inialize() async {
    // FirebaseFirestore.instance
    //     .collection('chats/GD8wPTo51qh1qVHCrRZC/messeges')
    //     .snapshots()
    //     .listen((event) {
    //   print('--------------------------------------------------');
    //   event.docs.forEach((element) {
    //     print(element['text']);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Amazing Chat",
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  DropdownButton(
                      icon: Icon(Icons.more_vert),
                      items: [
                        DropdownMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.exit_to_app,
                                  color: Theme.of(context).colorScheme.primary),
                              Text(
                                'Logout',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ],
                          ),
                          value: "logout value",
                        ),
                      ],
                      onChanged: (value) {
                        if (value == "logout value") {
                          FirebaseAuth.instance.signOut();
                        }
                      })
                ],
              ),
              body: Container(
                child: Column(
                  children: [Expanded(child: Messages())],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('chats/GD8wPTo51qh1qVHCrRZC/messeges')
                      .add({'text': "add from app"});
                },
              ),
            );
          }),
    );
  }
}
