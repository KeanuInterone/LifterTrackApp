import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/BarbellSetForm.dart';
import 'package:lifter_track_app/components/ValueSetForm.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/exercise_search_bar.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/components/keyboardDefocuser.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/scrollableValuePicker.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/components/workoutHeader.dart';
import 'package:lifter_track_app/models/current_workout.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/set.dart';
import 'package:lifter_track_app/models/set_group.dart';
import 'package:provider/provider.dart';

class AddSetPage extends StatefulWidget {
  final SetGroup setGroup;
  const AddSetPage({Key key, this.setGroup})
      : super(key: key);

  @override
  _AddSetPageState createState() => _AddSetPageState(setGroup: setGroup);
}

class _AddSetPageState extends State<AddSetPage> {
  Exercise exercise;
  SetGroup setGroup;
  int weight;
  int reps;
  String errorMessage;
  bool isLoading = false;

  _AddSetPageState({this.setGroup});

  void initializeWeightAndReps() {
    exercise = setGroup.focusExercise;
    if (setGroup.sets.length == 0) {
      reps = 0;
      weight = exercise.type == ExerciseType.barbell ? 45 : 0;
    } else {
      Set lastSet;
      setGroup.sets.reversed;
      for (var set in setGroup.sets.reversed) {
        if (set.exercise.type == exercise.type) {
          lastSet = set;
          break;
        }
      }
      if (lastSet != null) {
        weight = lastSet.weight;
        reps = lastSet.reps;
      } else {
        reps = 0;
        weight = exercise.type == ExerciseType.barbell ? 45 : 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> argMap = ModalRoute.of(context).settings.arguments;
    setGroup = argMap['setGroup'];
    initializeWeightAndReps();
    return keyboardDefocuser(
      context,
      child: background(
        context,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  workoutHeader(context),
                  body(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded body() {
    return Expanded(
      flex: 1,
      child: LayoutBuilder(builder: (context, constraints) {
        return ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            ExerciseSearchBar(
              initialValue: exercise.name,
            ),
            Container(
              height: constraints.maxHeight - 135,
              child: setForm(exercise),
            ),
            errorMessage == null
                ? SizedBox(height: 0)
                : text(errorMessage,
                    textAlign: TextAlign.center, color: Colors.red),
            button(
                text: 'Add Set',
                isLoading: isLoading,
                height: 60,
                color: Theme.of(context).focusColor,
                onPressed: () {
                  addSet(context);
                }),
            SizedBox(
              height: 10,
            )
          ],
        );
      }),
    );
  }

  Widget setForm(Exercise exercise) {
    Widget form;
    switch (exercise.type) {
      case ExerciseType.barbell:
        form = BarbellSetForm(
          initalWeight: weight,
          initialReps: reps,
          onWeightChanged: weightChanged,
          onRepsChanged: repsChanged,
        );
        break;
      case ExerciseType.weight:
        form = ValueSetForm(
          initialWeight: weight,
          initialReps: reps,
          onWeightChanged: weightChanged,
          onRepsChanged: repsChanged,
        );
        break;
      case ExerciseType.bodyweight:
        form = BarbellSetForm();
        break;
    }
    return form;
  }

  void weightChanged(int value) {
    weight = value;
  }

  void repsChanged(int value) {
    reps = value;
  }

  void addSet(BuildContext context) async {
    if (reps == 0) {
      setState(() {
        errorMessage = 'Reps were not set';
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    Response res = await Provider.of<CurrentWorkout>(context, listen: false)
        .addSet(setGroup, exercise, weight, reps);
    if (!res.success) {
      setState(() {
        errorMessage = res.errMessage;
        isLoading = false;
      });
    } else {
      pop(context);
    }
  }
}
