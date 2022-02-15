import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/Metrics/Graph.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/box.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/hide_if.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/components/workoutHeader.dart';
import 'package:lifter_track_app/models/Notifiers/current_workout.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/set_group.dart';
import 'package:lifter_track_app/models/set.dart';
import 'package:lifter_track_app/models/Notifiers/workout_timer.dart';
import 'package:lifter_track_app/pages/AddExercisePages/ExerciseTypeSelectPage.dart';
import 'package:provider/provider.dart';

class SetGroupPage extends StatefulWidget {
  const SetGroupPage({Key key}) : super(key: key);

  @override
  _SetGroupPageState createState() => _SetGroupPageState();
}

class _SetGroupPageState extends State<SetGroupPage> {
  Future<Response> getSetGroup() async {
    Map<String, dynamic> argMap = ModalRoute.of(context).settings.arguments;
    SetGroup setGroup = argMap['setGroup'];
    if (setGroup != null) return Response(true, null, setGroup);
    Exercise exercise = argMap['exercise'];
    return await createSetGroup(context, exercise);
  }

  Future<Response> createSetGroup(
      BuildContext context, Exercise exercise) async {
    Response res = await Provider.of<CurrentWorkout>(context, listen: false)
        .addSetGroup(exercise);
    if (!res.success) {
      return res;
    }
    SetGroup setGroup = res.data;
    setGroup.focusExercise = exercise;
    return Response(true, null, setGroup);
  }

  SetGroup setGroup;
  @override
  Widget build(BuildContext context) {
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
                FutureBuilder(
                  future: getSetGroup(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    Response res = snapshot.data;
                    if (!res.success) {
                      return Center(
                        child: text(res.errMessage, color: Colors.red),
                      );
                    }
                    SetGroup setGroup = res.data;
                    return body(setGroup, context);
                  },
                ),
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
                  metricsCards(context, setGroup.focusExercise),
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
                              return setRow(setGroup.sets[index],
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
            onPressed: () => navigateTo(
              'add_set',
              context,
              parameters: {'setGroup': setGroup},
            ),
          )
        ],
      ),
    );
  }

  Widget setRow(Set set, Color color) {
    return GestureDetector(
      child: box(
        height: 80,
        borderColor: color,
        fillColor: color.withAlpha(50),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hideIf(
              condition: set.exercise.type == ExerciseType.bodyweight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text('${set.weight}',
                      fontSize: 24, fontWeight: FontWeight.bold),
                  text('Weight', fontSize: 12),
                  hideIf(
                      condition: !set.exercise.trackPerSide,
                      child: text('per side', fontSize: 8))
                ],
              ),
            ),
            hideIf(
              condition: set.exercise.type == ExerciseType.bodyweight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: text('x', fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                text('${set.reps}', fontSize: 24, fontWeight: FontWeight.bold),
                text('Reps', fontSize: 12),
              ],
            ),
          ],
        ),
      ),
      onTap: () => navigateTo(
        'add_set',
        context,
        parameters: {'setGroup': setGroup, 'setToEdit': set},
      ),
    );
  }

  Widget metricsCards(BuildContext context, Exercise exercise) {
    return LayoutBuilder(builder: (context, constraints) {
      return Align(
        child: Container(
          height: 220,
          width: constraints.maxWidth,
          child: progressMetricCard(exercise),
        ),
      );
    });
  }

  Widget progressMetricCard(Exercise exercise) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: text('Progression',
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            flex: 1,
            child: FutureBuilder(
              future: exercise.getProgressionData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                Response res = snapshot.data;
                Map<String, dynamic> data = res.data;
                double min = data['min'].toDouble();
                double max = data['max'].toDouble();
                List points = data['efforts'];
                if (min == max) min = 0;
                return points.length == 0
                    ? Center(
                        child: text('No data',
                            color: Theme.of(context).primaryColorDark))
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 16, 20),
                        child: Graph(
                          minY: min,
                          maxY: max,
                          data: points,
                        ),
                      );
              },
            ),
          ),
        ],
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
