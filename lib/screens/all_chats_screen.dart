import 'package:amazing_chat/app_bar_title_widget.dart';
import 'package:amazing_chat/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllchatsScreen extends StatelessWidget {
  User? user;
  AllchatsScreen(this.user);

  @override
  Widget build(BuildContext context) {
    String? email = user!.email;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppBarTitle(null),
        actions: [
          DropdownButton(
              underline: Container(),
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).colorScheme.secondary,
              ),
              items: [
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app,
                          color: Theme.of(context).colorScheme.primary),
                      Text(
                        'Logout',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
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
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .where("email", isNotEqualTo: email)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final users = snapshots.data!.docs;
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: GridView.builder(
              itemCount: users.length,
              itemBuilder: ((context, index) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius:const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                  ),
                  child: InkWell(
                    key: ValueKey(users[index].id),
                    onTap: () {
                      Navigator.of(context).pushNamed(ChatScreen.routeName,
                          arguments: users[index].id);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(users[index]["imageUrl"]),
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
                              users[index]["username"],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20),
            ),
          );
        },
      ),
    );
  }
}
