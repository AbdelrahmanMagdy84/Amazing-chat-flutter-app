import 'package:amazing_chat/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoMessagesWidget extends StatelessWidget {
 const NoMessagesWidget(
      {Key? key,
      required this.friendImageUrl,
      required this.friendUsername,
      required this.roomDocId})
      : super(key: key);

  final String friendUsername;
  final String friendImageUrl;
  final String roomDocId;

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            radius: isPortrait ? 50 : 40,
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
                    fontSize: isPortrait ? 24 : 18,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
          const SizedBox(height: 10, width: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Say Hi 👋",
                style: TextStyle(
                    fontSize: isPortrait ? 18 : 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
              ),
              ElevatedButton(
                  onPressed: () =>
                      Provider.of<CurrentUserProvider>(context, listen: false)
                          .sendMessage("Hi 👋", roomDocId, context),
                  child: Text(
                    "Send",
                    style: TextStyle(fontSize: isPortrait ? 14 : 12),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
