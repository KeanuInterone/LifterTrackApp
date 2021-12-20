import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/box.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/Notifiers/exercises.dart';
import 'package:lifter_track_app/models/Notifiers/workouts.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/set_group.dart';
import 'package:lifter_track_app/models/workout.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({Key key}) : super(key: key);

  @override
  _WorkoutsPageState createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  @override
  Widget build(BuildContext context) {
    return background(
      context,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header(context),
              Expanded(
                child: Consumer2<Workouts, Exercises>(
                    builder: (context, workoutsNotifier, exercises, child) {
                  return ListView.separated(
                      itemCount: workoutsNotifier.workouts.length,
                      itemBuilder: (context, index) {
                        Workout workout = workoutsNotifier.workouts[index];
                        return workoutWidget(context, workout);
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 30));
                }),
              )
            ],
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
          Center(
            child: text('Workouts', fontSize: 30),
          ),
        ],
      ),
    );
  }

  Widget workoutWidget(BuildContext context, Workout workout) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Theme.of(context).backgroundColor
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              text('${DateFormat('EEEE, MMM d').format(workout.startTime.toLocal())}', fontSize:20, fontWeight: FontWeight.bold),
              SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: workout.setGroups.length > 3 ? 3 : workout.setGroups.length,
                itemBuilder: (context, index) => setGroupRow(context, workout.setGroups[index], Theme.of(context).primaryColor),
                separatorBuilder: (context, index) => SizedBox(height: 10),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        //navigateTo('set_group', context, parameters: {'setGroup': setGroup});
      },
    );
  }

  Widget setGroupRow(BuildContext context, SetGroup setGroup, Color color) {
    Exercise exercise = Provider.of<Exercises>(context, listen: false).exerciseWithId[setGroup.focusExerciseId];
    return box(
      height: 80,
      borderColor: color,
      fillColor: color.withAlpha(50),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: text(exercise.name),
      )
    );
  }
}
