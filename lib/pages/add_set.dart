import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/SetForms/BarbellPlateSelectorSetForm.dart';
import 'package:lifter_track_app/components/SetForms/BarbellSetForm.dart';
import 'package:lifter_track_app/components/SetForms/BodyweightSetForm.dart';
import 'package:lifter_track_app/components/SetForms/ValueSetForm.dart';
import 'package:lifter_track_app/components/SetForms/WeightPlateSelectorSetForm.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/exercise_search_bar.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/components/keyboardDefocuser.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/scrollableValuePicker.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/components/workoutHeader.dart';
import 'package:lifter_track_app/models/Notifiers/current_workout.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/set.dart';
import 'package:lifter_track_app/models/set_group.dart';
import 'package:provider/provider.dart';

class AddSetPage extends StatefulWidget {
  const AddSetPage({
    Key key,
  }) : super(key: key);

  @override
  _AddSetPageState createState() => _AddSetPageState();
}

class _AddSetPageState extends State<AddSetPage> {
  Exercise exercise;
  SetGroup setGroup;
  Set setToEdit;
  int weight;
  int reps;
  String errorMessage;
  bool isLoading = false;
  bool isDeleteLoading = false;

  void initializeWeightAndReps() {
    if (setToEdit != null) {
      exercise = setToEdit.exercise;
      reps = setToEdit.reps;
      weight = setToEdit.weight;
      return;
    }
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
    setToEdit = argMap['setToEdit'];
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
                  workoutHeader(context,
                      rightChild: setToEdit != null
                          ? isDeleteLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                  ),
                                )
                              : GestureDetector(
                                  child: Center(
                                    child: text(
                                      'Delete',
                                      color: Colors.red,
                                    ),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      isDeleteLoading = true;
                                    });
                                    Response res =
                                        await Provider.of<CurrentWorkout>(
                                                context,
                                                listen: false)
                                            .deleteSet(setGroup, setToEdit);
                                    if (!res.success) {
                                      setState(() {
                                        errorMessage = res.errMessage;
                                        isDeleteLoading = false;
                                      });
                                    } else {
                                      pop(context);
                                    }
                                  },
                                )
                          : null),
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            text('${exercise.name}', fontSize: 30, textAlign: TextAlign.center),
            SizedBox(height: 10),
            Expanded(
              child: setForm(exercise),
            ),
            errorMessage == null
                ? SizedBox(height: 0)
                : text(errorMessage,
                    textAlign: TextAlign.center, color: Colors.red),
            button(
                text: setToEdit == null ? 'Add Set' : 'Update Set',
                isLoading: isLoading,
                height: 60,
                color: Theme.of(context).focusColor,
                onPressed: () {
                  addOrUpdateSet(context);
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
        form = BarbellPlateSelectorSetForm(
          initalWeight: weight,
          initialReps: reps,
          onWeightChanged: weightChanged,
          onRepsChanged: repsChanged,
        );
        break;
      case ExerciseType.dumbbell:
        form = ValueSetForm(
          initialWeight: weight,
          initialReps: reps,
          onWeightChanged: weightChanged,
          onRepsChanged: repsChanged,
          trackPerSide: exercise.trackPerSide,
        );
        break;
      case ExerciseType.weight:
        if (exercise.weightInput == WeightInput.plates) {
          form = WeightPlateSelectorSetForm(
            initalWeight: weight,
            initialReps: reps,
            perSide: exercise.trackPerSide,
            onWeightChanged: weightChanged,
            onRepsChanged: repsChanged,
          );
        } else {
          form = ValueSetForm(
            initialWeight: weight,
            initialReps: reps,
            onWeightChanged: weightChanged,
            onRepsChanged: repsChanged,
            trackPerSide: exercise.trackPerSide,
          );
        }
        break;
      case ExerciseType.bodyweight:
        weight = 0;
        form = BodyweightSetForm(
          initialReps: reps,
          onRepsChanged: repsChanged,
        );
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

  void addOrUpdateSet(BuildContext context) async {
    if (reps == 0) {
      setState(() {
        errorMessage = 'Reps were not set';
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    // Edit Set
    if (setToEdit != null) {
      Response res = await setToEdit.update(weight, reps);
      if (!res.success) {
        setState(() {
          errorMessage = res.errMessage;
          isLoading = false;
        });
      } else {
        Provider.of<CurrentWorkout>(context, listen: false).updateViews();
        pop(context);
      }
      return;
    }
    // Update Widget
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
