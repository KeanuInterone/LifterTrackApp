import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/AppBar.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/box.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/keyboardDefocuser.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/Notifiers/exercise_notifier.dart';
import 'package:lifter_track_app/models/Notifiers/tags_notifier.dart';
import 'package:provider/provider.dart';

class ExerciseTagsPage extends StatefulWidget {
  const ExerciseTagsPage({Key key}) : super(key: key);

  @override
  _ExerciseTagsPageState createState() => _ExerciseTagsPageState();
}

class _ExerciseTagsPageState extends State<ExerciseTagsPage> {
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
                  text(
                      'Select some tags to help categorize your exercises! Add a new one if you don\'t see one you like or you can skip this and add later',
                      textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  Expanded(
                    child: Consumer<ExerciseNotifier>(
                        builder: (context, newExercise, child) {
                      return Consumer<TagsNotifier>(
                        builder: (context, tagsNotifier, child) {
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: tagsNotifier.tags.map((tag) {
                                  bool isSelected = newExercise.exercise.tagIDs
                                      .contains(tag.id);
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
                                          newExercise.removeTag(tag);
                                        } else {
                                          newExercise.addTag(tag);
                                        }
                                      },
                                    ),
                                  );
                                }).toList() +
                                [
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: button(
                                        height: 42,
                                        text: 'Add tag',
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () {
                                          navigateTo('add_tag', context);
                                        }),
                                  ),
                                ],
                          );
                        },
                      );
                    }),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  button(
                      text: 'Next',
                      color: Theme.of(context).primaryColor,
                      height: 60,
                      onPressed: () {
                        navigateTo('exercise_review', context);
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
