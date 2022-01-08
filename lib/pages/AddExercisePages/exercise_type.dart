import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/AppBar.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/keyboardDefocuser.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/Notifiers/exercise_notifier.dart';
import 'package:provider/provider.dart';

class ExerciseTypePage extends StatefulWidget {
  const ExerciseTypePage({Key key}) : super(key: key);

  @override
  _ExerciseTypePageState createState() => _ExerciseTypePageState();
}

class _ExerciseTypePageState extends State<ExerciseTypePage> {
  String errorMessage = '';
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
                  SizedBox(height: 20),
                  text('Great! Now select the exercise type.',
                      textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  Expanded(
                    child: Consumer<ExerciseNotifier>(
                      builder: (context, newExercise, child) {
                        ExerciseType type = newExercise.exercise.type;
                        bool isBarbell = type == ExerciseType.barbell;
                        bool isBodyweight = type == ExerciseType.bodyweight;
                        bool isWeight = type == ExerciseType.weight;
                        return Padding(
                          padding: const EdgeInsets.all(40),
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
                                      ? Theme.of(context)
                                          .focusColor
                                          .withAlpha(50)
                                      : Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      errorMessage = '';
                                    });
                                    newExercise.exercise.weightInput =
                                        WeightInput.plates;
                                    newExercise
                                        .setExerciseType(ExerciseType.barbell);
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              Expanded(
                                child: button(
                                  text: 'Bodyweight',
                                  color: isBodyweight
                                      ? Theme.of(context).focusColor
                                      : Theme.of(context).primaryColor,
                                  fillColor: isBodyweight
                                      ? Theme.of(context)
                                          .focusColor
                                          .withAlpha(50)
                                      : Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      errorMessage = '';
                                    });
                                    newExercise.exercise.weightInput =
                                        WeightInput.value;
                                    newExercise.setExerciseType(
                                        ExerciseType.bodyweight);
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              Expanded(
                                child: button(
                                  text: 'Weight',
                                  color: isWeight
                                      ? Theme.of(context).focusColor
                                      : Theme.of(context).primaryColor,
                                  fillColor: isWeight
                                      ? Theme.of(context)
                                          .focusColor
                                          .withAlpha(50)
                                      : Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      errorMessage = '';
                                    });
                                    newExercise
                                        .setExerciseType(ExerciseType.weight);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: errorMessage.isEmpty
                        ? SizedBox(height: 0)
                        : text(errorMessage,
                            color: Colors.red, textAlign: TextAlign.center),
                  ),
                  button(
                      text: 'Next',
                      color: Theme.of(context).primaryColor,
                      height: 60,
                      onPressed: () {
                        ExerciseType type = Provider.of<ExerciseNotifier>(
                                context,
                                listen: false)
                            .exercise
                            .type;
                        if (type == null) {
                          setState(() {
                            errorMessage = 'Must select exercise type';
                          });
                          return;
                        }
                        if (type == ExerciseType.weight) {
                          navigateTo('exercise_weight_input', context);
                        } else {
                          navigateTo('exercise_tags', context);
                        }
                      }),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
