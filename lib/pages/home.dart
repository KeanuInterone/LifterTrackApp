import 'package:flutter/material.dart';
import 'package:lifter_track_app/pages/workout.dart';
import 'package:lifter_track_app/models/user.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/components/button.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  _HomePage() {}

  @override
  Widget build(BuildContext context) {
    return background(
      context: context,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              title(),
              startWorkoutButton(context),
              Expanded(
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
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
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
        child: button(
          text: 'Start Workout',
          color: Theme.of(context).focusColor,
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
}