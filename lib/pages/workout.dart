import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/box.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/hide_if.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/Notifiers/current_workout.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/set_group.dart';
import 'package:lifter_track_app/models/set.dart';
import 'package:lifter_track_app/models/Notifiers/workout_timer.dart';
import 'package:lifter_track_app/pages/select_exercise.dart';
import 'package:provider/provider.dart';
import 'package:lifter_track_app/pages/set_group.dart';
import 'package:lifter_track_app/components/workoutHeader.dart';

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
              workoutHeader(context),
              body(context),
            ],
          ),
        ),
      ),
    );
  }

  Expanded body(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: setGroups(),
            ),
            button(
              text: 'Add Exercise',
              color: Theme.of(context).focusColor,
              height: 80,
              onPressed: () {
                navigateTo('select_exercise', context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget setGroups() {
    return Consumer<CurrentWorkout>(
      builder: (context, currentWorkout, child) {
        return currentWorkout.workout.setGroups.length == 0
            ? Padding(
                padding: const EdgeInsets.fromLTRB(20, 200, 20, 0),
                child: text('No exercises added, add one below',
                    textAlign: TextAlign.center),
              )
            : ListView.separated(
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
          color: Theme.of(context).backgroundColor
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              text('${setGroup.focusExercise.name}', textAlign: TextAlign.center, fontSize:28, fontWeight: FontWeight.bold),
              SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: setGroup.sets.length,
                itemBuilder: (context, index) => setRow(setGroup.sets[index], Theme.of(context).primaryColor),
                separatorBuilder: (context, index) => SizedBox(height: 10),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        navigateTo('set_group', context, parameters: {'setGroup': setGroup});
      },
    );
  }

  Widget setRow(Set set, Color color) {
    return box(
      height: 80,
      borderColor: color,
      fillColor: color.withAlpha(50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          hideIf(
            condition: set.exercise.type == ExerciseType.bodyweight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                text('${set.weight}', fontSize: 24, fontWeight: FontWeight.bold),
                text('Weight', fontSize: 12),
              ],
            ),
          ),
          hideIf(
            condition: set.exercise.type == ExerciseType.bodyweight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: text('x', fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              text('${set.reps}', fontSize: 24, fontWeight: FontWeight.bold),
              text('Reps', fontSize: 12),
            ],
          ),
        ],
      ),
    );
  }
}
