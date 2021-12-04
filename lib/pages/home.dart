import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/models/current_workout.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/workout_timer.dart';
import 'package:lifter_track_app/pages/workout.dart';
import 'package:lifter_track_app/models/user.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/pages/exercises.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  _HomePage() {}

  @override
  Widget build(BuildContext context) {
    return background(
      context,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              title(),
              startWorkoutButton(context),
              workoutAndExerciseButtons(context)
            ],
          ),
        ),
      ),
    );
  }

  Expanded title() {
    return Expanded(
      flex: 3,
      child: Container(
        child: Center(
          child: text(
            "Lifter Track",
            fontSize: 48,
          ),
        ),
      ),
    );
  }

  Expanded startWorkoutButton(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Consumer2<CurrentWorkout, WorkoutTimer>(
          builder: (context, currentWorkout, workoutTimer, child) {
            if (currentWorkout.workout != null) {
              return button(
                text: 'Return to workout: ${workoutTimer.time}',
                color: Theme.of(context).focusColor,
                onPressed: () {
                  navigateTo('workout', context);
                },
              );
            } else {
              return button(
                text: 'Start Workout',
                color: Theme.of(context).focusColor,
                onPressed: () async {
                  Response res = await currentWorkout.startWorkout(context);
                  if (res.success) navigateTo('workout', context);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Expanded workoutAndExerciseButtons(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: button(
                text: 'Workouts',
                color: Theme.of(context).primaryColor,
                height: 56,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: button(
                text: 'My Exercises',
                color: Theme.of(context).primaryColor,
                height: 56,
                onPressed: () {
                  navigateTo('exercises', context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
