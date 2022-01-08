import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/Notifiers/workout_timer.dart';
import 'package:provider/provider.dart';
import 'package:lifter_track_app/components/AppBar.dart';

Widget workoutHeader(BuildContext context, {Widget rightChild}) {
  return appBar(
    context,
    centerChild: Consumer<WorkoutTimer>(
      builder: (context, timer, child) {
        return text('${timer.time}', fontSize: 20);
      },
    ),
    rightChild: rightChild
  );
}
