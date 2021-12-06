import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/BarbellSetForm.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/exercise_search_bar.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/components/scrollableValuePicker.dart';
import 'package:lifter_track_app/components/workoutHeader.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/set.dart';

class AddSetPage extends StatefulWidget {
  final void Function(Set) onSetCreated;
  final Exercise exercise;
  const AddSetPage({Key key, this.onSetCreated, this.exercise})
      : super(key: key);

  @override
  _AddSetPageState createState() => _AddSetPageState();
}

class _AddSetPageState extends State<AddSetPage> {
  @override
  Widget build(BuildContext context) {
    return background(
      context,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                workoutHeader(context),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ExerciseSearchBar(
                        initialValue: widget.exercise.name,
                      ),
                      Expanded(
                        flex: 1,
                        child: setForm(widget.exercise),
                      ),
                      button(
                          text: 'Add Set',
                          height: 150,
                          color: Theme.of(context).focusColor)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget setForm(Exercise exercise) {
    Widget form;
    switch (exercise.type) {
      case ExerciseType.barbell:
        form = BarbellSetForm(initalWeight: 135,);
        break;
      case ExerciseType.weight:
        form = BarbellSetForm();
        break;
      case ExerciseType.weights:
        form = BarbellSetForm();
        break;
      case ExerciseType.bodyweight:
        form = BarbellSetForm();
        break;
      case ExerciseType.value:
        form = BarbellSetForm();
        break;
    }
    return form;
  }

  
}
