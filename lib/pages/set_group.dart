import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/set_group.dart';
import 'package:lifter_track_app/models/set.dart';
import 'package:lifter_track_app/models/workout_timer.dart';
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
    SetGroup setGroup = widget.setGroup;
    return background(
      context,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                header(context),
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
      child: ListView(
        children: [
          focusExerciseTitle(setGroup),
          SizedBox(height: 10),
          metrixCards(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: setGroup.sets.length,
              itemBuilder: (context, index) {
                return text(
                    '${setGroup.sets[index].weight} x ${setGroup.sets[index].reps}');
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          button(
            text: 'Add Set',
            height: 75,
            color: Theme.of(context).focusColor,
            onPressed: () => navigateTo('add_set', context, parameters: {'onSetCreated': onSetCreated, 'exercise': setGroup.focusExercise}),
          )
        ],
      ),
    );
  }

  void onSetCreated(Set set) {

  }

  Align metrixCards(BuildContext context) {
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
      child: text(
        '${setGroup.focusExercise.name}',
        fontSize: 40,
        textAlign: TextAlign.center
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
                  pop(context);
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
}
