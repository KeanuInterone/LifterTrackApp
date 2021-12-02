import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/exercises.dart';
import 'package:provider/provider.dart';

class ExerciseSearchBar extends StatefulWidget {
  const ExerciseSearchBar({Key key}) : super(key: key);

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
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return Text(searchResults[index].name);
          },
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
