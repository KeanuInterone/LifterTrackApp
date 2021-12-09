import 'package:flutter/material.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/set_group.dart';
import 'package:lifter_track_app/models/workout.dart';
import 'package:lifter_track_app/models/workout_timer.dart';
import 'package:provider/provider.dart';

class CurrentWorkout extends ChangeNotifier {
  Workout workout;  

  Future<Response> startWorkout(BuildContext context) async {
    Response res = await Workout.create();
    if (!res.success) return res;

    workout = res.data;
    Provider.of<WorkoutTimer>(context, listen: false).start();
    return res;
  }

  Future<Response> addSetGroup(Exercise exercise) async {
    Response res = await workout.createSetGroup(exercise);
    notifyListeners();
    return res;
  }

  Future<Response> addSet(SetGroup setGroup, Exercise exercise, int weight, int reps) async {
    Response res = await workout.createSet(setGroup, exercise, weight, reps);
    notifyListeners();
    return res;
  }
}