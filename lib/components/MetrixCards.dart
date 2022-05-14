import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/Metrics/Graph.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/set_group.dart';
import 'package:lifter_track_app/models/set.dart';

import '../models/response.dart';

class MetrixCards extends StatefulWidget {
  final Exercise exercise;
  const MetrixCards({Key key, this.exercise}) : super(key: key);

  @override
  _MetrixCardsState createState() => _MetrixCardsState();
}

class _MetrixCardsState extends State<MetrixCards> {
  PageController pageController = PageController();
  int currentPage = 0;
  Map<String, dynamic> progressionData;
  Map<String, dynamic> lastSetData;

  Future<Response> getProgressionData(Exercise exercise) async {
    if (progressionData != null) return Response(true, null, progressionData);
    Response res = await exercise.getProgressionData();
    if (res.success == false) return res;
    progressionData = res.data;
    return res;
  }

  Future<Response> getLastSetData(Exercise exercise) async {
    if (lastSetData != null) return Response(true, null, lastSetData);
    Response res = await exercise.getLastSetData();
    if (res.success == false) return res;
    lastSetData = res.data;
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: 240,
        width: constraints.maxWidth,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [
                  lastSetMetricsCard(widget.exercise),
                  progressMetricCard(widget.exercise),
                ],
              ),
            ),
            DotsIndicator(
              dotsCount: 2,
              position: currentPage.toDouble(),
            )
          ],
        ),
      );
    });
  }

  Widget progressMetricCard(Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
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
                future: getProgressionData(exercise),
                builder: (context, snapshot) {
                  // Loading
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  Response res = snapshot.data;
                  // Error
                  if (res.success == false) {
                    return Center(
                      child: text(res.errMessage,
                          color: Theme.of(context).primaryColorDark),
                    );
                  }
                  // Data
                  Map<String, dynamic> data = res.data;
                  double min = data['min'].toDouble();
                  double max = data['max'].toDouble();
                  List points = data['efforts'];
                  if (min == max) min = 0;
                  if (points.length == 0) {
                    return Center(
                      child: text('No data',
                          color: Theme.of(context).primaryColorDark),
                    );
                  }
                  return Padding(
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
      ),
    );
  }

  Widget lastSetMetricsCard(Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
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
              child: text('Last Set',
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              flex: 1,
              child: FutureBuilder(
                future: getLastSetData(exercise),
                builder: (context, snapshot) {
                  // Loading
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  Response res = snapshot.data;
                  // Error
                  if (res.success == false) {
                    return Center(
                      child: text(res.errMessage,
                          color: Theme.of(context).primaryColorDark),
                    );
                  }
                  // Data
                  Map<String, dynamic> data = res.data;
                  SetGroup setGroup = data['setGroup'] != null ? SetGroup.fromJson(data['setGroup']) : null;
                  int best = data['best'];
                  if (setGroup == null) {
                    return Center(
                      child: text('No data',
                          color: Theme.of(context).primaryColorDark),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                text('Max: '),
                                text(
                                  '$best',
                                  color: Theme.of(context).focusColor,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.white,
                          width: 2,
                          thickness: 1,
                        ),
                        Expanded(
                          child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: setGroup.sets.length,
                              itemBuilder: (context, index) {
                                Set set = setGroup.sets[index];
                                return Align(
                                    child: text('${set.weight} x ${set.reps}',
                                        fontWeight: FontWeight.bold));
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
