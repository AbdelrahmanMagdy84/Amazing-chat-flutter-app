import 'package:flutter/material.dart';

import '../models/Acount.dart';

class FriendDataProvider with ChangeNotifier {
  var _data = Acount("", "", "");
  Acount get getData {
    return _data;
  }

  void setAcountData(Map<String, dynamic> countData) {
    _data.uid = countData["friendId"]!;
    _data.imageUrl = countData["friendImage"]!;
    _data.username = countData["friendUsername"]!;
  }

  
}
