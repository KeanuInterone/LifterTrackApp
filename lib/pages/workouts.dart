import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/box.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/Notifiers/workouts.dart';
import 'package:lifter_track_app/models/workout.dart';
import 'package:provider/provider.dart';

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
                child: Consumer<Workouts>(
                    builder: (context, workoutsNotifier, child) {
                  return ListView.builder(
                      itemCount: workoutsNotifier.workouts.length,
                      itemBuilder: (context, index) {
                        Workout workout = workoutsNotifier.workouts[index];
                        return workoutWidget(workout);
                      });
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

  Widget workoutWidget(Workout workout) {
    return box(
      borderColor: Theme.of(context).primaryColor,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: workout.setGroups.length > 3 ? 3 : workout.setGroups.length,
        itemBuilder: (context, index) {
          return box(fillColor: Theme.of(context).primaryColor, child: text('I am an exercise'));
        })
    );
  }
}
