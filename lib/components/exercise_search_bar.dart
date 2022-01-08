import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/Notifiers/exercise_notifier.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/Notifiers/exercises.dart';
import 'package:provider/provider.dart';

class ExerciseSearchBar extends StatefulWidget {
  final void Function(Exercise) onExerciseSelected;
  final String initialValue;
  final bool autoFocus;
  ExerciseSearchBar(
      {Key key,
      this.onExerciseSelected,
      this.initialValue,
      this.autoFocus = false})
      : super(key: key);

  @override
  _ExerciseSearchBarState createState() => _ExerciseSearchBarState();
}

class _ExerciseSearchBarState extends State<ExerciseSearchBar> {
  List<Exercise> searchResults = [];
  String value = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        formField(
            initialValue: widget.initialValue,
            placeholder: 'Search',
            autofocus: widget.autoFocus,
            onChanged: (value) {
              this.value = value;
              searchExercises(context, value);
            }),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: (searchResults.length == 0)
              ? (value.isEmpty
                  ? SizedBox(height: 0)
                  : GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: text('Add Exercise "$value"',
                            color: Colors.black, fontSize: 20),
                      ),
                      onTap: () {
                        Provider.of<ExerciseNotifier>(context, listen: false).clearExercise();
                        Provider.of<ExerciseNotifier>(context, listen: false).setName(value);
                        navigateTo('exercise_name', context);
                        setState(() {
                          value = "";
                        });
                      },
                    ))
              : Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: text(searchResults[index].name,
                              color: Colors.black, fontSize: 20),
                        ),
                        onTap: () {
                          widget.onExerciseSelected(searchResults[index]);
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ),
        )
      ],
    );
  }

  void searchExercises(BuildContext context, String value) {
    if (value.isEmpty) {
      searchResults = [];
    } else {
      List<Exercise> exercises =
          Provider.of<Exercises>(context, listen: false).exercises;
      searchResults = exercises.where((exercise) {
        return exercise.name.toLowerCase().contains(value.toLowerCase());
      }).toList();
    }
    setState(() {});
  }
}
