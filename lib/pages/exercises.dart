import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/AppBar.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/exercise_search_bar.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/components/keyboardDefocuser.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/Notifiers/exercise_notifier.dart';
import 'package:lifter_track_app/models/Notifiers/tags_notifier.dart';
import 'package:lifter_track_app/models/exercise.dart';
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
                      Provider.of<ExerciseNotifier>(context, listen: false).clearExercise();
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
              onExerciseSelected: (exercise) {},
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
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: tagIds.length,
                    itemBuilder: (context, index) {
                      return ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: [
                          text(tags.tagWithId[tagIds[index]].name,
                              fontSize: 30, fontWeight: FontWeight.bold),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: exercises.groupedExercises[tagIds[index]]
                                .map(
                                  (exercise) => GestureDetector(
                                    child: Chip(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      label: text(exercise.name, fontSize: 28),
                                    ),
                                    onTap: () {
                                      Provider.of<ExerciseNotifier>(context, listen: false).setExercise(exercise.clone());
                                      navigateTo('exercise_edit', context);
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 30),
                  );
                },
              ),
            ),
            button(
              text: 'Add Exercise',
              color: Theme.of(context).focusColor,
              height: 60,
              onPressed: () {
                Provider.of<ExerciseNotifier>(context, listen: false).clearExercise();
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
