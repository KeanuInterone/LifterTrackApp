import 'package:flutter/material.dart';
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

  Future<Response> addSetGroup() async {
    Response res = await SetGroup.create();
    if (!res.success) return res;

    SetGroup setGroup = res.data;
    workout.setGroups.add(setGroup);
    notifyListeners();
  }
}