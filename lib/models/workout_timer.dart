import 'dart:async';

import 'package:flutter/material.dart';

class WorkoutTimer extends ChangeNotifier {
  int timeSeconds = 0;
  String time;
  Timer _timer;
  void start() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      timeSeconds++;
      time = readableTimeFromSeconds(timeSeconds);
      notifyListeners();
    });
  }

  void stop() {
    _timer.cancel();
  } 

  void reset() {
    timeSeconds = 0;
    notifyListeners();
  }

  String readableTimeFromSeconds(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    String hoursString = hours == 0 ? '' : '${hours}h:';
    return '$hoursString${minutes}m:${seconds}s';
  }
  
}