import 'package:amazing_chat/helpers/chat_room.dart';
import 'package:amazing_chat/models/acount.dart';
import 'package:amazing_chat/provider/friend_data_provider.dart';
import 'package:amazing_chat/provider/user_provider.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../widgets/chat widgets/messages.dart';
import '../widgets/chat widgets/new_message.dart';
import '../widgets/chat widgets/title_column_widget.dart';
import 'package:sizer/sizer.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = "/chat_screen";

  late Acount friendAcountData;
  late ChatRoom chatRoom;

   ChatScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    friendAcountData =
        Provider.of<FriendDataProvider>(context, listen: false).getData;
    chatRoom = ChatRoom();
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 40,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: TitleColumnWidget(
                    imageUrl: friendAcountData.imageUrl,
                    username: friendAcountData.username),
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
                          imageUrl: currentUser.getData.imageUrl,
                          username: currentUser.getData.username);
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
        body: FutureBuilder(
          future: chatRoom.setRoomId(friendAcountData.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Column(
                children:const [
                   Expanded(child: Center(child: Text("Loading"))),
                  NewMessage(""),
                ],
              );
            }

            return Column(
              children: [
                Expanded(
                  child: Messages(chatRoom.roomId),
                ),
                NewMessage(chatRoom.roomId),
              ],
            );
          },
        ));
  }
}
