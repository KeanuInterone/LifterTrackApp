import 'package:flutter/material.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/workout.dart';

class Workouts extends ChangeNotifier {
  List<Workout> workouts = [];

  Future<Response> getWorkouts() async {
    Response res = await Workout.getLatestWorkouts();
    workouts = res.data;
    return res;
  } 

  void addWorkout(Workout workout) {
    workouts.insert(0, workout);
    notifyListeners();
  } 

  clear() {
    workouts = [];
    notifyListeners();
  }
  
}