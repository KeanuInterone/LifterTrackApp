import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/workout_timer.dart';
import 'package:provider/provider.dart';

Widget workoutHeader(BuildContext context) {
  return Expanded(
    flex: 1,
    child: Container(
      child: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(width: 24),
            child: IconButton(
              onPressed: () {
                pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Center(
            child: Consumer<WorkoutTimer>(
              builder: (context, timer, child) {
                return text('${timer.time}', fontSize: 20);
              },
            ),
          )
        ],
      ),
    ),
  );
}
