import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/current_workout.dart';
import 'package:lifter_track_app/models/set_group.dart';
import 'package:lifter_track_app/models/workout_timer.dart';
import 'package:lifter_track_app/pages/select_exercise.dart';
import 'package:provider/provider.dart';
import 'package:lifter_track_app/pages/set_group.dart';

class WorkoutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WorkoutPage();
}

class _WorkoutPage extends State<WorkoutPage> {
  @override
  Widget build(BuildContext context) {
    return background(
      context,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              header(context),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: [
                      setGroups(),
                      SizedBox(height: 10),
                      button(
                        text: 'Add set group',
                        color: Theme.of(context).focusColor,
                        height: 200,
                        onPressed: () {
                          navigateTo('select_exercise', context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded header(context) {
    return Expanded(
      flex: 1,
      child: Container(
        child: Stack(
          children: [
            Container(
              constraints: BoxConstraints.expand(width: 24),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
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

  Widget setGroups() {
    return Consumer<CurrentWorkout>(
      builder: (context, currentWorkout, child) {
        return ListView.separated(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: currentWorkout.workout.setGroups.length,
          itemBuilder: (context, index) {
            SetGroup setGroup = currentWorkout.workout.setGroups[index];
            return setGroupWidget(context, setGroup);
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 10);
          },
        );
      },
    );
  }

  Widget setGroupWidget(BuildContext context, SetGroup setGroup) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              text('${setGroup.focusExercise.name}'),
            ],
          ),
        ),
      ),
      onTap: () {
        navigateTo('set_group', context, parameters: {'setGroup': setGroup});
      },
    );
  }
}
