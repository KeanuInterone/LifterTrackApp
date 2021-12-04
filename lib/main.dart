import 'package:flutter/material.dart';
import 'package:lifter_track_app/models/current_workout.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/exercises.dart';
import 'package:lifter_track_app/models/set_group.dart';
import 'package:lifter_track_app/models/set.dart';
import 'package:lifter_track_app/models/workout_timer.dart';
import 'package:lifter_track_app/pages/add_exercise.dart';
import 'package:lifter_track_app/pages/add_set.dart';
import 'package:lifter_track_app/pages/exercises.dart';
import 'package:lifter_track_app/pages/login.dart';
import 'package:lifter_track_app/pages/select_exercise.dart';
import 'package:lifter_track_app/pages/set_group.dart';
import 'package:lifter_track_app/pages/sign_up.dart';
import 'package:lifter_track_app/pages/workout.dart';
import 'package:provider/provider.dart';
import 'models/api.dart';
import 'pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Exercises()),
        ChangeNotifierProvider(create: (context) => WorkoutTimer()),
        ChangeNotifierProvider(create: (context) => CurrentWorkout())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primaryColor: Color(0xff4cd0fa),
            backgroundColor: Color(0xff313342),
            focusColor: Color(0xff15f410)),
        home: LoginPage(),
        onGenerateRoute: (settings) {
          Widget page;
          switch (settings.name) {
            case 'login':
              page = LoginPage();
              break;
            case 'sign_up':
              page = SignUpPage();
              break;
            case 'home':
              page = HomePage();
              break;
            case 'workout':
              page = WorkoutPage();
              break;
            case 'select_exercise':
              page = SelectExercisePage();
              break;
            case 'set_group':
              Map<String, dynamic> argMap = settings.arguments;
              SetGroup setGroup = argMap['setGroup'];
              page = SetGroupPage(
                setGroup: setGroup,
              );
              break;
            case 'add_set':
              Map<String, dynamic> argMap = settings.arguments;
              void Function(Set) onSetCreated = argMap['onSetCreated'];
              Exercise exercise = argMap['exercise'];
              page = AddSetPage(onSetCreated: onSetCreated, exercise: exercise,);
              break;
            case 'exercises':
              page = ExercisesPage();
              break;
            case 'add_exercise':
              page = AddExercisePage();
              break;
          }
          return MaterialPageRoute(builder: (context) {
            return page;
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
