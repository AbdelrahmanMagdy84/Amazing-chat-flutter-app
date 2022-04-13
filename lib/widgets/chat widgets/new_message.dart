import "package:flutter/material.dart";
import 'package:sizer/sizer.dart';

class NewMessage extends StatefulWidget {
  String? roomDocId;
  void Function(String message, String? roomDocId, BuildContext ctx)
      sendMessage;

  NewMessage(this.sendMessage, this.roomDocId);
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  late final _enterdMessageController;
  final key = const ValueKey("value");
  @override
  void initState() {
    // TODO: implement initState
    _enterdMessageController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isProtrait = SizerUtil.orientation == Orientation.portrait;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: key,
              style: TextStyle(fontSize: 14, height: 1),
              minLines: 1,
              maxLines: isProtrait ? 5 : 1,
              controller: _enterdMessageController,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                label: Text("Send message..."),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: _enterdMessageController.text.isEmpty
                ? null
                : () {
                    final room = widget.sendMessage(
                        _enterdMessageController.text,
                        widget.roomDocId,
                        context);
                    _enterdMessageController.clear();
                  },
            icon: const Icon(
              Icons.send,
            ),
          )
        ],
      ),
    );
  }
}
