import "package:flutter/material.dart";

class NewMessage extends StatefulWidget {
  String? roomDocId;
  void Function(String message, String? roomDocId,BuildContext ctx) sendMessage;
  NewMessage(this.sendMessage, this.roomDocId);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              minLines: 1,
              maxLines: 5,
              controller: _enterdMessageController,
              decoration: const InputDecoration(
                label: Text("Send message..."),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: _enterdMessageController.text.isEmpty
                ? null
                : () {
                  final room=
                    widget.sendMessage(
                        _enterdMessageController.text, widget.roomDocId,context);
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
