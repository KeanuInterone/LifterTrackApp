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

class ExerciseWeightInputPage extends StatefulWidget {
  const ExerciseWeightInputPage({ Key key }) : super(key: key);

  @override
  _ExerciseWeightInputPageState createState() => _ExerciseWeightInputPageState();
}

class _ExerciseWeightInputPageState extends State<ExerciseWeightInputPage> {
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
                  text('Almost there! Now select how you want to enter your weight. If your exercise uses plates, track it with plates and the app will do the adding for you! Otherwise use the simple number value.',
                      textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  Expanded(
                    child: Consumer<ExerciseNotifier>(
                      builder: (context, newExercise, child) {
                        WeightInput type = newExercise.exercise.weightInput;
                        bool isPlates = type == WeightInput.plates;
                        bool isValue = type == WeightInput.value;
                        return Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: button(
                                  text: 'Use Plates',
                                  color: isPlates
                                      ? Theme.of(context).focusColor
                                      : Theme.of(context).primaryColor,
                                  fillColor: isPlates
                                      ? Theme.of(context).focusColor.withAlpha(50)
                                      : Colors.transparent,
                                  onPressed: () {
                                    setState(() {errorMessage = '';});
                                    newExercise
                                        .setWeightInputType(WeightInput.plates);
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              Expanded(
                                child: button(
                                  text: 'Use Number Value',
                                  color: isValue
                                      ? Theme.of(context).focusColor
                                      : Theme.of(context).primaryColor,
                                  fillColor: isValue
                                      ? Theme.of(context).focusColor.withAlpha(50)
                                      : Colors.transparent,
                                  onPressed: () {
                                    setState(() {errorMessage = '';});
                                    newExercise
                                        .setWeightInputType(WeightInput.value);
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
                        WeightInput type = Provider.of<ExerciseNotifier>(context, listen: false).exercise.weightInput;
                        if (type == null) {
                          setState(() {
                            errorMessage = 'Must select a type';
                          });
                          return;
                        }
                        navigateTo('exercise_tags', context);
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