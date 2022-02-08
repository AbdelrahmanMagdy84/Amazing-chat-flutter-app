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
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Scaffold(
              appBar: AppBar(),
              body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats/GD8wPTo51qh1qVHCrRZC/messeges')
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final docs = streamSnapshot.data!.docs;
                  return ListView.builder(
                    //  scrollDirection: Axis.horizontal,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return Text(docs[index]['text']);
                    },
                  );
                },
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
