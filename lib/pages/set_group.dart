import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/box.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/components/workoutHeader.dart';
import 'package:lifter_track_app/models/Notifiers/current_workout.dart';
import 'package:lifter_track_app/models/set_group.dart';
import 'package:lifter_track_app/models/set.dart';
import 'package:lifter_track_app/models/Notifiers/workout_timer.dart';
import 'package:provider/provider.dart';

class SetGroupPage extends StatefulWidget {
  final SetGroup setGroup;
  const SetGroupPage({Key key, this.setGroup}) : super(key: key);

  @override
  _SetGroupPageState createState() => _SetGroupPageState();
}

class _SetGroupPageState extends State<SetGroupPage> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> argMap = ModalRoute.of(context).settings.arguments;
    SetGroup setGroup = argMap['setGroup'];
    return background(
      context,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                workoutHeader(context),
                body(setGroup, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded body(SetGroup setGroup, BuildContext context) {
    return Expanded(
      flex: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Consumer<CurrentWorkout>(
                builder: (context, currentWorkout, child) {
              return ListView(
                children: [
                  focusExerciseTitle(setGroup),
                  SizedBox(height: 10),
                  metricsCards(context),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: setGroup.sets.length == 0
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: text('No sets added, add one below',
                                textAlign: TextAlign.center),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: setGroup.sets.length,
                            itemBuilder: (context, index) {
                              return setRow(
                                  setGroup.sets[index].weight,
                                  setGroup.sets[index].reps,
                                  Theme.of(context).primaryColor);
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 10);
                            },
                          ),
                  ),
                ],
              );
            }),
          ),
          button(
            text: 'Add Set',
            height: 75,
            color: Theme.of(context).focusColor,
            onPressed: () => navigateTo('add_set', context, parameters: {
              'onSetCreated': onSetCreated,
              'setGroup': setGroup
            }),
          )
        ],
      ),
    );
  }

  Widget setRow(int weight, int reps, Color color) {
    return box(
      height: 80,
      borderColor: color,
      fillColor: color.withAlpha(50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              text('$weight', fontSize: 24, fontWeight: FontWeight.bold),
              text('Weight', fontSize: 12),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: text('x', fontWeight: FontWeight.bold),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              text('$reps', fontSize: 24, fontWeight: FontWeight.bold),
              text('Reps', fontSize: 12),
            ],
          ),
        ],
      ),
    );
  }

  void onSetCreated(Set set) {}

  Align metricsCards(BuildContext context) {
    return Align(
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Center(child: text('Meta data cards')),
            ),
          ],
        ),
      ),
    );
  }

  Align focusExerciseTitle(SetGroup setGroup) {
    return Align(
      child: text('${setGroup.focusExercise.name}',
          fontSize: 40, textAlign: TextAlign.center),
    );
  }
}
