import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/models/Notifiers/current_workout.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/Notifiers/workout_timer.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with WidgetsBindingObserver {
  BuildContext context;
  DateTime appInactiveTimeStamp;
  bool startWorkoutLoading = false;
  bool finishWorkoutLoading = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        WorkoutTimer workoutTimer =
            Provider.of<WorkoutTimer>(context, listen: false);
        if (workoutTimer.timer != null) {
          workoutTimer.resyncTime();
        }
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return background(
      context,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  title(),
                  startWorkoutButton(context),
                  workoutAndExerciseButtons(context)
                ],
              ),
              Positioned(top: 20, right: 20, child: IconButton(iconSize: 52, icon: Icon(Icons.portrait_rounded, color: Colors.white60,), ))
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

  Widget startWorkoutButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Consumer2<CurrentWorkout, WorkoutTimer>(
        builder: (context, currentWorkout, workoutTimer, child) {
          if (currentWorkout.workout != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                button(
                    text: 'Return to workout: ${workoutTimer.time}',
                    color: Theme.of(context).focusColor,
                    onPressed: () {
                      navigateTo('workout', context);
                    },
                    height: 100),
                SizedBox(height: 10),
                button(
                  text: 'Finish workout',
                  color: Colors.red,
                  isLoading: finishWorkoutLoading,
                  height: 48,
                  onPressed: () async {
                    setState(() {
                      finishWorkoutLoading = true;
                    });
                    await currentWorkout.finish(context);
                    setState(() {
                      finishWorkoutLoading = false;
                    });
                  },
                )
              ],
            );
          } else {
            return button(
              text: 'Start Workout',
              color: Theme.of(context).focusColor,
              isLoading: startWorkoutLoading,
              height: 100,
              onPressed: () async {
                setState(() {
                  startWorkoutLoading = true;
                });
                Response res = await currentWorkout.startWorkout(context);
                if (res.success) navigateTo('workout', context);
                setState(() {
                  startWorkoutLoading = false;
                });
              },
            );
          }
        },
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
                onPressed: () {
                  navigateTo('workouts', context);
                }
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
            ),
          ],
        ),
      ),
    );
  }
}
