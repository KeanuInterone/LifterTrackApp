import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/exercise_search_bar.dart';
import 'package:lifter_track_app/components/workoutHeader.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/set.dart';

class AddSetPage extends StatefulWidget {
  final void Function(Set) onSetCreated;
  final Exercise exercise;
  const AddSetPage({Key key, this.onSetCreated, this.exercise}) : super(key: key);

  @override
  _AddSetPageState createState() => _AddSetPageState();
}

class _AddSetPageState extends State<AddSetPage> {
  @override
  Widget build(BuildContext context) {
    return background(
      context,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              workoutHeader(context),
              Expanded(
                flex: 7,
                child: Column(
                  children: [ExerciseSearchBar(initialValue: widget.exercise.name,),],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
