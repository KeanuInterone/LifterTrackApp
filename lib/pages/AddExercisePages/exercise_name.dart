import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/components/keyboardDefocuser.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/Notifiers/exercises.dart';
import 'package:lifter_track_app/models/Notifiers/new_exercise_notifier.dart';
import 'package:provider/provider.dart';

class ExerciseNamePage extends StatefulWidget {
  const ExerciseNamePage({Key key}) : super(key: key);

  @override
  _ExerciseNamePageState createState() => _ExerciseNamePageState();
}

class _ExerciseNamePageState extends State<ExerciseNamePage> {
  String name = '';
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
                  header(context),
                  SizedBox(height: 20),
                  text(
                      'Enter the exercise name! This can be what ever you want!',
                      textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  Consumer<NewExerciseNotifier>(
                      builder: (context, newExercise, child) {
                    name = newExercise.exercise.name;
                    return formField(
                        placeholder: 'Exercise Name',
                        initialValue: name,
                        textCapitalization: TextCapitalization.words,
                        autofocus: true,
                        onChanged: (value) {
                          List<Exercise> exercises = Provider.of<Exercises>(context, listen: false).exercises;
                          var searchResults = exercises.where((exercise) {
                            return exercise.name.toLowerCase() == value.toLowerCase();
                          }).toList();
                          if (searchResults.length > 0) {
                            setState(() {
                              errorMessage =
                                  'Exercise with that name already exists';
                            });
                            return;
                          }
                          newExercise.setName(value);
                          setState(() {
                            errorMessage = '';
                          });
                        });
                  }),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: errorMessage.isEmpty
                        ? SizedBox(height: 0)
                        : text(errorMessage,
                            color: Colors.red, textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  button(
                      text: 'Next',
                      color: Theme.of(context).primaryColor,
                      height: 60,
                      onPressed: () {
                        if (name == null || name.isEmpty) {
                          setState(() {
                            errorMessage = 'Name cannot be empty';
                          });
                          return;
                        }
                        navigateTo('exercise_type', context);
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

  Widget header(context) {
    return Container(
      height: 80,
      child: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(width: 24),
            child: IconButton(
              onPressed: () {
                pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Center(
            child: text('New Exercise', fontSize: 20),
          )
        ],
      ),
    );
  }
}
