import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/components/keyboardDefocuser.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/exercises.dart';
import 'package:lifter_track_app/pages/add_exercise.dart';
import 'package:provider/provider.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({Key key}) : super(key: key);

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  @override
  Widget build(BuildContext context) {
    return keyboardDefocuser(
      context,
      child: background(
        context,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header(context),
                body(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header(context) {
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
              child: text('Exercises', fontSize: 30),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: IconButton(
                onPressed: () {
                  navigateTo('exercise_name', context);
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded body(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            formField(placeholder: 'Search'),
            SizedBox(
              height: 30,
            ),
            Expanded(
              flex: 1,
              child: Consumer<Exercises>(
                builder: (context, exercises, child) {
                  return exerciseList(exercises.exercises);
                },
              ),
            ),
            button(
              text: 'Add Exercise',
              color: Theme.of(context).focusColor,
              height: 60,
              onPressed: () {
                navigateTo('exercise_name', context);
              },
            )
          ],
        ),
      ),
    );
  }

  ListView exerciseList(List<Exercise> exercises) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: exerciseWidget(exercises[index]),
        );
      },
    );
  }

  Widget exerciseWidget(Exercise exercise) {
    return button(
      text: exercise.name,
      height: 50,
      color: Theme.of(context).primaryColor,
    );
  }

  Column section(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text('Push'),
        SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, index) {
            return button(
              text: 'Exercise name',
              height: 50,
              color: Theme.of(context).primaryColor,
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 10);
          },
        )
      ],
    );
  }
}
