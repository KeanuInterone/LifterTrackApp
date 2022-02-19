import 'package:flutter/material.dart';
import 'package:lifter_track_app/models/user.dart';

class CurrentUserNotifier extends ChangeNotifier {
  User user;

  void setUser(User user) {
    this.user = user;
    notifyListeners();
  }

}