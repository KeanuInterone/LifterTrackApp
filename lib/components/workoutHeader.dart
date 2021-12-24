import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/Notifiers/workout_timer.dart';
import 'package:provider/provider.dart';
import 'package:lifter_track_app/components/AppBar.dart';

Widget workoutHeader(BuildContext context) {
  return appBar(
    context,
    centerChild: Consumer<WorkoutTimer>(
      builder: (context, timer, child) {
        return text('${timer.time}', fontSize: 20);
      },
    ),
  );

  // return Container(
  //   height: 80,
  //   child: Stack(
  //     children: [
  //       Container(
  //         constraints: BoxConstraints.expand(width: 60),
  //         child: IconButton(
  //           iconSize: 40,
  //           onPressed: () {
  //             pop(context);
  //           },
  //           icon: Icon(
  //             Icons.arrow_back,
  //             color: Colors.white,
  //             size: 40,
  //           ),
  //         ),
  //       ),
  //       Center(
  //         child: Consumer<WorkoutTimer>(
  //           builder: (context, timer, child) {
  //             return text('${timer.time}', fontSize: 20);
  //           },
  //         ),
  //       )
  //     ],
  //   ),
  // );
}
