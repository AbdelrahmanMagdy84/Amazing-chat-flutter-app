import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../screens/chat_screen.dart';

class FriendGridItem extends StatelessWidget {
  const FriendGridItem({Key? key, required this.users, required this.index})
      : super(key: key);

  final List<QueryDocumentSnapshot<Object?>> users;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(100),
          topRight: Radius.circular(100),
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      child: InkWell(
        key: ValueKey(users[index].id),
        onTap: () {
          Navigator.of(context).pushNamed(ChatScreen.routeName, arguments: {
            "friendId": users[index].id,
            "friendImage": users[index]["imageUrl"],
            "friendUsername": users[index]["username"]
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              radius: 30,
              backgroundImage: NetworkImage(users[index]["imageUrl"]),
            ),
            Container(
              width: 10,
              height: 3,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(),
              ),
            ),
            FittedBox(
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
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
  }
}
