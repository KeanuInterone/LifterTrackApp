import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/AppBar.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/Notifiers/CurrentUserNotifier.dart';
import 'package:lifter_track_app/models/Notifiers/current_workout.dart';
import 'package:lifter_track_app/models/Notifiers/exercise_notifier.dart';
import 'package:lifter_track_app/models/Notifiers/exercises.dart';
import 'package:lifter_track_app/models/Notifiers/tags_notifier.dart';
import 'package:lifter_track_app/models/api.dart';
import 'package:lifter_track_app/models/user.dart';
import 'package:provider/provider.dart';

import '../components/box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<CurrentUserNotifier>(context).user;
    bool hasUser = user != null;
    return background(
      context,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            appBar(
              context,
              centerChild: text('Profile', fontSize: 30),
            ),
            !hasUser
                ? text('Logging out')
                : Expanded(
                    child: ListView(
                      children: [
                        Align(
                          child: box(
                            height: 100,
                            width: 100,
                            cornerRadius: 50,
                            child: Center(
                              child: text(
                                '${user.firstName[0]}${user.lastName[0]}',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                              child:
                                  text('${user.firstName} ${user.lastName}')),
                        ),
                        Align(
                          child: Container(
                            width: 100,
                            child: button(
                                text: 'Logout',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                borderWidth: 1,
                                color: Colors.white,
                                height: 24,
                                onPressed: () {
                                  logout();
                                }),
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        )),
      ),
    );
  }

  void logout() {
    Provider.of<CurrentUserNotifier>(context, listen: false).clear();
    Provider.of<CurrentWorkout>(context, listen: false).clear(context);
    Provider.of<ExerciseNotifier>(context, listen: false).clearExercise();
    Provider.of<Exercises>(context, listen: false).clear();
    Provider.of<TagsNotifier>(context, listen: false).clear();
    API.authToken = '';
    API.saveAuthToken();
    Navigator.pushNamedAndRemoveUntil(context, "login", (r) => false);
    //Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
