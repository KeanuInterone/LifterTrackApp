import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/box.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/components/keyboardDefocuser.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/components/workoutHeader.dart';
import 'package:lifter_track_app/models/Notifiers/current_workout.dart';
import 'package:lifter_track_app/models/Notifiers/exercises.dart';
import 'package:lifter_track_app/models/Notifiers/tags_notifier.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/set_group.dart';
import 'package:lifter_track_app/models/Notifiers/workout_timer.dart';
import 'package:lifter_track_app/pages/set_group.dart';
import 'package:provider/provider.dart';
import 'package:lifter_track_app/components/exercise_search_bar.dart';

class SelectExercisePage extends StatefulWidget {
  const SelectExercisePage({Key key}) : super(key: key);

  @override
  _SelectExercisePageState createState() => _SelectExercisePageState();
}

class _SelectExercisePageState extends State<SelectExercisePage> {
  @override
  Widget build(BuildContext context) {
    return keyboardDefocuser(
      context,
      child: background(
        context,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          //resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  workoutHeader(context),
                  Expanded(
                    flex: 7,
                    child: ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: [
                        ExerciseSearchBar(
                          onExerciseSelected: (exercise) {
                            createSetGroup(context, exercise);
                          },
                        ),
                        Consumer2<Exercises, TagsNotifier>(
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
                                    text(tags.tagWithId[tagIds[index]].name, fontSize: 30, fontWeight: FontWeight.bold),
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: exercises
                                          .groupedExercises[tagIds[index]]
                                          .map(
                                            (exercise) => GestureDetector(
                                              child: Chip(
                                                backgroundColor: Theme.of(context)
                                                    .primaryColor,
                                                label: text(exercise.name, fontSize: 28),
                                              ),
                                              onTap: () {
                                                createSetGroup(context, exercise);
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded header(context) {
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
              child: Consumer<WorkoutTimer>(
                builder: (context, timer, child) {
                  return text('${timer.time}', fontSize: 20);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void createSetGroup(BuildContext context, Exercise exercise) async {
    Response res = await Provider.of<CurrentWorkout>(context, listen: false)
        .addSetGroup(exercise);
    if (!res.success) {
      print(res.errMessage);
      return;
    }
    SetGroup setGroup = res.data;
    setGroup.focusExercise = exercise;
    replaceScreenWith('set_group', context, parameters: {'setGroup': setGroup});
  }
}
