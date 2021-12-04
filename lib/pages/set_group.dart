import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/set_group.dart';
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
    return background(
      context,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              header(context),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [],
                ),
              ),
            ],
          ),
        ),
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
