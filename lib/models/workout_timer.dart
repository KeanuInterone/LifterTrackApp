import 'dart:async';

import 'package:flutter/material.dart';

class WorkoutTimer extends ChangeNotifier {
  int time = 0;
  Timer _timer;
  void start() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      time++;
      notifyListeners();
    });
  }

  void stop() {
    _timer.cancel();
  } 

  void reset() {
    time = 0;
    notifyListeners();
  }
  
}