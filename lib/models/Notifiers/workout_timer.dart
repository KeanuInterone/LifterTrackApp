import 'dart:async';

import 'package:flutter/material.dart';

class WorkoutTimer extends ChangeNotifier {
  int timeSeconds = 0;
  String time = '0m:0s';
  Timer timer;
  DateTime startTimeStamp;
  void start() {
    timeSeconds = 0;
    startTimeStamp = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      timeSeconds++;
      time = readableTimeFromSeconds(timeSeconds);
      notifyListeners();
    });
  }

  void resyncTime() {
    timeSeconds = DateTime.now().difference(startTimeStamp).inSeconds;
    notifyListeners();
  }

  void stop() {
    timer.cancel();
  } 

  void reset() {
    timeSeconds = 0;
    notifyListeners();
  }

  String readableTimeFromSeconds(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds - hours * 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String hoursString = hours == 0 ? '' : '${hours}h:';
    return '$hoursString${minutes}m:${seconds}s';
  }

  clear() {
    timeSeconds = 0;
    time = '0m:0s';
    timer = null;
    startTimeStamp = null;
    notifyListeners();
  }
  
}