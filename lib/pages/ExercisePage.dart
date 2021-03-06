import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/AppBar.dart';
import 'package:lifter_track_app/components/GroupedExerciseList.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/exercise_search_bar.dart';
import 'package:lifter_track_app/components/keyboardDefocuser.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/Notifiers/exercise_notifier.dart';
import 'package:lifter_track_app/models/Notifiers/tags_notifier.dart';
import 'package:lifter_track_app/models/Notifiers/exercises.dart';
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
                appBar(
                  context,
                  centerChild: text('Exercises', fontSize: 30),
                  rightChild: IconButton(
                    onPressed: () {
                      Provider.of<ExerciseNotifier>(context, listen: false)
                          .clearExercise();
                      navigateTo('exercise_name', context);
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
                body(context),
              ],
            ),
          ),
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
            ExerciseSearchBar(
              onExerciseSelected: (exercise) {
                Provider.of<ExerciseNotifier>(context, listen: false)
                    .setExercise(exercise.clone());
                navigateTo('exercise_edit', context);
              },
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 1,
              child: Consumer2<Exercises, TagsNotifier>(
                builder: (context, exercises, tags, child) {
                  List<String> tagIds =
                      exercises.groupedExercises.keys.toList();
                  return GroupedExerciseList(
                    tagIds: tagIds,
                    tags: tags,
                    exercises: exercises,
                    onExerciseTap: (exercise) {
                      Provider.of<ExerciseNotifier>(context, listen: false)
                          .setExercise(exercise.clone());
                      navigateTo('exercise_edit', context);
                    },
                  );
                },
              ),
            ),
            addExerciseButton(context)
          ],
        ),
      ),
    );
  }

  Widget addExerciseButton(BuildContext context) {
    return button(
      text: 'Add Exercise',
      color: Theme.of(context).focusColor,
      height: 60,
      onPressed: () {
        Provider.of<ExerciseNotifier>(context, listen: false).clearExercise();
        navigateTo('exercise_name', context);
      },
    );
  }
}
