import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/box.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/keyboardDefocuser.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/Notifiers/new_exercise_notifier.dart';
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
                  header(context),
                  SizedBox(height: 20),
                  text(
                      'Select some tags to help categorize your exercises! Add a new one if you don\'t see one you like or you can skip this and add later',
                      textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  Expanded(
                    child: Consumer<NewExerciseNotifier>(
                      builder: (context, newExercise, child) {
                        return Consumer<TagsNotifier>(
                          builder: (context, tagsNotifier, child) {
                            return ListView(
                              children: tagsNotifier.tags.map((tag) {
                                bool isSelected = newExercise.exercise.tagIDs.contains(tag.id);
                                return Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: button(
                                    height: 60,
                                    text: tag.name,
                                    color: isSelected ? Theme.of(context).focusColor : Colors.white,
                                    onPressed: () {
                                      if (isSelected) {
                                        newExercise.removeTag(tag);
                                      } else {
                                        newExercise.addTag(tag);
                                      }
                                    }
                                  ),
                                );
                              }).toList() + [
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: button(
                                      height: 60,
                                      text: 'Add tag',
                                      color: Theme.of(context).primaryColor,
                                      onPressed: () {
                                        navigateTo('add_tag', context);
                                      }
                                    ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    ),
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
          Consumer<NewExerciseNotifier>(
            builder: (context, newExercise, child) {
              return Center(
                child: text(newExercise.exercise.name ?? '', fontSize: 20),
              );
            }
          )
        ],
      ),
    );
  }
}
