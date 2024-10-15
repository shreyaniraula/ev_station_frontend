import 'package:ev_charge/models/user.model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    accessToken: '',
    id: '',
    username: '',
    fullName: '',
    password: '',
    phoneNumber: '',
    image: '',
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
