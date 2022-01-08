import 'package:flutter/material.dart';
import 'package:lifter_track_app/models/Notifiers/current_workout.dart';
import 'package:lifter_track_app/models/Notifiers/tags_notifier.dart';
import 'package:lifter_track_app/models/Notifiers/workouts.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/Notifiers/exercises.dart';
import 'package:lifter_track_app/models/Notifiers/exercise_notifier.dart';
import 'package:lifter_track_app/models/set_group.dart';
import 'package:lifter_track_app/models/set.dart';
import 'package:lifter_track_app/models/Notifiers/workout_timer.dart';
import 'package:lifter_track_app/pages/AddExercisePages/exercise_name.dart';
import 'package:lifter_track_app/pages/AddExercisePages/exercise_review.dart';
import 'package:lifter_track_app/pages/AddExercisePages/exercise_tags.dart';
import 'package:lifter_track_app/pages/AddExercisePages/exercise_type.dart';
import 'package:lifter_track_app/pages/AddExercisePages/exercise_weight_input.dart';
import 'package:lifter_track_app/pages/AddTag/add_tag.dart';
import 'package:lifter_track_app/pages/add_set.dart';
import 'package:lifter_track_app/pages/exercise_edit.dart';
import 'package:lifter_track_app/pages/exercises.dart';
import 'package:lifter_track_app/pages/login.dart';
import 'package:lifter_track_app/pages/select_exercise.dart';
import 'package:lifter_track_app/pages/set_group.dart';
import 'package:lifter_track_app/pages/sign_up.dart';
import 'package:lifter_track_app/pages/workout.dart';
import 'package:lifter_track_app/pages/workouts.dart';
import 'package:provider/provider.dart';
import 'pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Exercises()),
        ChangeNotifierProvider(create: (context) => WorkoutTimer()),
        ChangeNotifierProvider(create: (context) => CurrentWorkout()),
        ChangeNotifierProvider(create: (context) => ExerciseNotifier()),
        ChangeNotifierProvider(create: (context) => TagsNotifier()),
        ChangeNotifierProvider(create: (context) => Workouts())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color(0xff4cd0fa), //Colors.white, //
          backgroundColor: Color(0xff313342), //Colors.black, //
          focusColor: Color(0xff15f410) //Colors.white, //

        ),
        home: LoginPage(),
        routes: {
          'login': (context) => LoginPage(),
          'sign_up': (context) => SignUpPage(),
          'home': (context) => HomePage(),
          'workout': (context) => WorkoutPage(),
          'select_exercise': (context) => SelectExercisePage(),
          'set_group': (context) => SetGroupPage(),
          'add_set': (context) => AddSetPage(),
          'exercises': (context) => ExercisesPage(),
          'exercise_edit': (context) => ExerciseEditPage(),
          'exercise_name': (context) => ExerciseNamePage(),
          'exercise_type': (context) => ExerciseTypePage(),
          'exercise_weight_input': (context) => ExerciseWeightInputPage(),
          'exercise_tags': (context) => ExerciseTagsPage(),
          'exercise_review': (context) => ExerciseReviewPage(),
          'add_tag': (context) => AddTagPage(),
          'workouts': (context) => WorkoutsPage()
        },
      ),
    );
  }
}
