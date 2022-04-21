import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRoom {
  late String _roomId;
  get roomId => _roomId;

  Future<void> setRoomId(String friendId) async {
    final responseDoc = await FirebaseFirestore.instance
        .collection('chats')
        .where("users", isEqualTo: {
          FirebaseAuth.instance.currentUser!.uid: null,
          friendId: null
        })
        .limit(1)
        .get();
    if (responseDoc.docs.isNotEmpty) {
      _roomId = responseDoc.docs.single.id;
    } else {
      await _createRoomId(friendId);
    }
  }

  Future<void> _createRoomId(String friendId) async {
    final DocumentReference<Map<String, dynamic>> responseDoc =
        await FirebaseFirestore.instance.collection('chats').add({
      "users": {FirebaseAuth.instance.currentUser!.uid: null, friendId: null}
    });
    _roomId = responseDoc.id;
  }
}
