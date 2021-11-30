import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/components/keyboardDefocuser.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/exercises.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:provider/provider.dart';

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({Key key}) : super(key: key);

  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  final _formKey = GlobalKey<FormState>();
  List<String> exerciseTypes = [
    'Barbell',
    'Weight',
    'Weights',
    'Bodyweight',
    'Value'
  ];
  String _exerciseName;
  String _selectedExerciseType = null;
  String _exerciseType = null;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return keyboardDefocuser(
      context,
      child: background(
        context,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
              child: Column(
            children: [
              header(context),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ListView(
                    children: [
                      Form(
                        key: _formKey,
                        child: formField(
                          placeholder: 'Name',
                          validator: (value) =>
                              value.isEmpty ? 'Name cannot be empty' : null,
                          onSaved: (value) => _exerciseName = value.trim(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      exerciseTypeGrid(context),
                      SizedBox(
                        height: 10,
                      ),
                      errorWidget(),
                      button(
                          text: 'Add Exercise',
                          color: Theme.of(context).focusColor,
                          height: 60,
                          onPressed: _validateAndSubmit)
                    ],
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate() && _selectedExerciseType != null) {
      _exerciseType = _selectedExerciseType.toLowerCase();
      form.save();
      return true;
    }
    return false;
  }

  _validateAndSubmit() async {
    setState(() {
      _errorMessage = '';
    });

    if (_validateAndSave()) {
      Response res = await Exercise.create(_exerciseName, _exerciseType);
      if (res.success) {
        Provider.of<Exercises>(context, listen: false).addExercise(res.data);
        pop(context);
      } else {
        setState(() {
          _errorMessage = res.errMessage;
        });
      }
    }
  }

  GridView exerciseTypeGrid(BuildContext context) {
    return GridView.count(
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      children: exerciseTypes
          .map((type) =>
              exerciseType(type, _selectedExerciseType == type, context))
          .toList(),
    );
  }

  Widget exerciseType(String type, bool selected, BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              width: 2,
              color: selected
                  ? Theme.of(context).focusColor
                  : Theme.of(context).primaryColor),
        ),
        child: Center(child: text(type)),
      ),
      onTap: () {
        setState(() {
          _selectedExerciseType = type;
        });
      },
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
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: text('New Exercise', fontSize: 20),
            )
          ],
        ),
      ),
    );
  }

  Widget errorWidget() {
    if (_errorMessage.length == 0 || _errorMessage == null) {
      return Container(
        height: 0.0,
      );
    } else {
      return Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300,
        ),
      );
    }
  }

  Widget dropDownMenue() {
    return DropdownButton<String>(
      items: exerciseTypes.map<DropdownMenuItem<String>>((type) {
        return DropdownMenuItem(
          child: text(type),
          value: type,
        );
      }).toList(),
      icon: const Icon(Icons.arrow_drop_down),
      onChanged: (String newValue) {},
    );
  }
}
