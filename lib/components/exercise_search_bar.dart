import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/exercises.dart';
import 'package:provider/provider.dart';

class ExerciseSearchBar extends StatefulWidget {
  void Function(Exercise) onExerciseSelected;
  ExerciseSearchBar({Key key, this.onExerciseSelected}) : super(key: key);

  @override
  _ExerciseSearchBarState createState() => _ExerciseSearchBarState();
}

class _ExerciseSearchBarState extends State<ExerciseSearchBar> {
  List<Exercise> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        formField(
            placeholder: 'Search',
            onChanged: (value) {
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
          child: searchResults.length == 0
              ? SizedBox(height: 0)
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
                          child: text(searchResults[index].name, color: Colors.black, fontSize: 20),
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
    List<Exercise> exercises =
        Provider.of<Exercises>(context, listen: false).exercises;
    searchResults = exercises.where((exercise) {
      return exercise.name.toLowerCase().contains(value.toLowerCase());
    }).toList();
    setState(() {});
  }
}
