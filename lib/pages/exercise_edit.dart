import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/AppBar.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/components/hide_if.dart';
import 'package:lifter_track_app/components/keyboardDefocuser.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/Notifiers/tags_notifier.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/Notifiers/exercises.dart';
import 'package:lifter_track_app/models/Notifiers/exercise_notifier.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/tag.dart';
import 'package:provider/provider.dart';

class ExerciseEditPage extends StatefulWidget {
  const ExerciseEditPage({Key key}) : super(key: key);

  @override
  _ExerciseEditPageState createState() => _ExerciseEditPageState();
}

class _ExerciseEditPageState extends State<ExerciseEditPage> {
  String name = '';
  String errorMessageForName = '';
  String errorMessage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                  appBar(
                    context,
                    centerChild: Consumer<ExerciseNotifier>(
                        builder: (context, newExercise, child) {
                      return Center(
                        child:
                            text(newExercise.exercise.name ?? '', fontSize: 20),
                      );
                    }),
                  ),
                  Expanded(
                    child: Consumer<ExerciseNotifier>(
                        builder: (context, exercise, child) {
                      name = exercise.exercise.name;
                      ExerciseType type = exercise.exercise.type;
                      bool isBarbell = type == ExerciseType.barbell;
                      bool isBodyweight = type == ExerciseType.bodyweight;
                      bool isWeight = type == ExerciseType.weight;
                      WeightInput weightInput = exercise.exercise.weightInput;
                      bool isPlates = weightInput == WeightInput.plates;
                      bool isValue = weightInput == WeightInput.value;
                      bool isPerSide = exercise.exercise.trackPerSide ?? false;
                      return ListView(
                        children: [
                          text('Name', textAlign: TextAlign.center),
                          SizedBox(height: 10),
                          exerciseNameField(context, exercise),
                          nameErrorMessage(),
                          SizedBox(height: 30),
                          text('Type', textAlign: TextAlign.center),
                          SizedBox(height: 10),
                          typePicker(isBarbell, context, exercise, isBodyweight,
                              isWeight),
                          hideIf(
                            condition: !isWeight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                text('Weight Input',
                                    textAlign: TextAlign.center),
                                SizedBox(height: 10),
                                weightInputPicker(
                                    isPlates, context, exercise, isValue),
                                SizedBox(
                                  height: 50,
                                ),
                                text('Track per side',
                                    textAlign: TextAlign.center),
                                SizedBox(height: 10),
                                perSidePicker(isPerSide, context, exercise)
                              ],
                            ),
                          ),
                          SizedBox(height: 50),
                          text('Tags', textAlign: TextAlign.center),
                          SizedBox(height: 10),
                          tags(exercise, context),
                          SizedBox(height: 50),
                          errorMessageForResponse(),
                          button(
                              text: 'Update Exercise',
                              color: Theme.of(context).focusColor,
                              isLoading: isLoading,
                              fillColor:
                                  Theme.of(context).focusColor.withAlpha(50),
                              height: 60,
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                Response res = await Provider.of<Exercises>(
                                        context,
                                        listen: false)
                                    .editExercise(exercise.exercise);
                                if (res.success) {
                                  exercise.clearExercise();
                                  Navigator.popUntil(context, (route) {
                                    return route.settings.name == 'exercises' ||
                                        route.settings.name ==
                                            'select_exercise';
                                  });
                                } else {
                                  setState(() {
                                    isLoading = false;
                                    errorMessage = res.errMessage;
                                  });
                                }
                              }),
                          SizedBox(height: 10),
                        ],
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container tags(ExerciseNotifier exercise, BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Consumer<TagsNotifier>(
          builder: (context, allTags, child) {
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: allTags.tags.map((tag) {
                    bool isSelected =
                        exercise.exercise.tagIDs.contains(tag.id);
                    return Container(
                      child: GestureDetector(
                        child: Chip(
                          backgroundColor: isSelected
                              ? Theme.of(context).focusColor
                              : Theme.of(context).primaryColor,
                          label: text(tag.name, fontSize: 28),
                        ),
                        onTap: () {
                          if (isSelected) {
                            exercise.removeTag(tag);
                          } else {
                            exercise.addTag(tag);
                          }
                        },
                      ),
                    );
                  }).toList() +
                  [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: button(
                          height: 40,
                          text: 'Add tag',
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            navigateTo('add_tag', context);
                          }),
                    ),
                  ],
            );
          },
        ),
      ),
    );
  }

  Container perSidePicker(
      bool isPerSide, BuildContext context, ExerciseNotifier newExercise) {
    return Container(
      height: 125,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: button(
                text: 'Per Side',
                color: isPerSide
                    ? Theme.of(context).focusColor
                    : Theme.of(context).primaryColor,
                fillColor: isPerSide
                    ? Theme.of(context).focusColor.withAlpha(50)
                    : Colors.transparent,
                onPressed: () {
                  setState(() {
                    errorMessageForName = '';
                  });
                  newExercise.setTrackPerSide(true);
                },
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: button(
                text: 'Total',
                color: !isPerSide
                    ? Theme.of(context).focusColor
                    : Theme.of(context).primaryColor,
                fillColor: !isPerSide
                    ? Theme.of(context).focusColor.withAlpha(50)
                    : Colors.transparent,
                onPressed: () {
                  setState(() {
                    errorMessageForName = '';
                  });
                  newExercise.setTrackPerSide(false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container weightInputPicker(bool isPlates, BuildContext context,
      ExerciseNotifier newExercise, bool isValue) {
    return Container(
      height: 125,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: button(
                text: 'Plates',
                color: isPlates
                    ? Theme.of(context).focusColor
                    : Theme.of(context).primaryColor,
                fillColor: isPlates
                    ? Theme.of(context).focusColor.withAlpha(50)
                    : Colors.transparent,
                onPressed: () {
                  setState(() {
                    errorMessageForName = '';
                  });
                  newExercise.setWeightInputType(WeightInput.plates);
                },
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: button(
                text: 'Number Value',
                color: isValue
                    ? Theme.of(context).focusColor
                    : Theme.of(context).primaryColor,
                fillColor: isValue
                    ? Theme.of(context).focusColor.withAlpha(50)
                    : Colors.transparent,
                onPressed: () {
                  setState(() {
                    errorMessageForName = '';
                  });
                  newExercise.setWeightInputType(WeightInput.value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container typePicker(bool isBarbell, BuildContext context,
      ExerciseNotifier newExercise, bool isBodyweight, bool isWeight) {
    return Container(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: button(
                text: 'Barbell',
                color: isBarbell
                    ? Theme.of(context).focusColor
                    : Theme.of(context).primaryColor,
                fillColor: isBarbell
                    ? Theme.of(context).focusColor.withAlpha(50)
                    : Colors.transparent,
                onPressed: () {
                  setState(() {
                    errorMessageForName = '';
                  });
                  newExercise.setExerciseType(ExerciseType.barbell);
                },
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: button(
                text: 'Bodyweight',
                color: isBodyweight
                    ? Theme.of(context).focusColor
                    : Theme.of(context).primaryColor,
                fillColor: isBodyweight
                    ? Theme.of(context).focusColor.withAlpha(50)
                    : Colors.transparent,
                onPressed: () {
                  setState(() {
                    errorMessageForName = '';
                  });
                  newExercise.setExerciseType(ExerciseType.bodyweight);
                },
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: button(
                text: 'Weight',
                color: isWeight
                    ? Theme.of(context).focusColor
                    : Theme.of(context).primaryColor,
                fillColor: isWeight
                    ? Theme.of(context).focusColor.withAlpha(50)
                    : Colors.transparent,
                onPressed: () {
                  setState(() {
                    errorMessageForName = '';
                  });
                  newExercise.setExerciseType(ExerciseType.weight);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding nameErrorMessage() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: hideIf(
        condition: errorMessageForName.isEmpty,
        child: text(errorMessageForName,
            color: Colors.red, textAlign: TextAlign.center),
      ),
    );
  }

  Padding errorMessageForResponse() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: hideIf(
        condition: errorMessage.isEmpty,
        child:
            text(errorMessage, color: Colors.red, textAlign: TextAlign.center),
      ),
    );
  }

  Widget exerciseNameField(BuildContext context, ExerciseNotifier newExercise) {
    return formField(
      placeholder: 'Exercise Name',
      initialValue: name,
      textCapitalization: TextCapitalization.words,
      onChanged: (value) {
        List<Exercise> exercises =
            Provider.of<Exercises>(context, listen: false).exercises;
        var searchResults = exercises.where((exercise) {
          return exercise.name.toLowerCase() == value.toLowerCase();
        }).toList();
        if (searchResults.length > 0) {
          setState(() {
            errorMessageForName = 'Exercise with that name already exists';
          });
          return;
        }
        newExercise.setName(value);
        setState(
          () {
            errorMessageForName = '';
          },
        );
      },
    );
  }
}
