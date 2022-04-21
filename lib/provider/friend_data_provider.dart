import 'package:flutter/material.dart';

import '../models/acount.dart';

class FriendDataProvider with ChangeNotifier {
  final _data = Acount("", "", "");
  Acount get getData {
    return _data;
  }

  void setAcountData(Map<String, dynamic> countData) {
    _data.uid = countData["friendId"]!;
    _data.imageUrl = countData["friendImage"]!;
    _data.username = countData["friendUsername"]!;
  }

  
}
