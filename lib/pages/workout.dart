import 'package:flutter/material.dart';

class WorkoutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WorkoutPage();
}

class _WorkoutPage extends State<WorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  var sets = [];
  bool isAddingSet = false;
  String _exerciseName;
  int _weight;
  int _reps;
  bool _isLoading = false;
  String _errorMessage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lifter Tracker'),
        ),
        body: Stack(
          children: [
            Center(
              child: Text("This is the workout"),
            ),
            Positioned(
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: showAddSetModule,
                ),
              ),
              bottom: 40,
              right: 20,
            ),
            Visibility(
              visible: isAddingSet,
              child: Positioned(
                child: Center(child: newSetModule()),
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
              ),
            )
          ],
        ),
      ),
      onTap: () {
        setState(() {
          isAddingSet = false;
          FocusScope.of(context).requestFocus(FocusNode());
        });
      },
    );
  }

  Widget newSetModule() {
    return Card(
      color: Colors.grey,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _exerciseNameWidget(),
            _weightWidget(),
            _repsWidget(),
            MaterialButton(child: Text('Add Set'), onPressed: addSet)
          ],
        ),
      ),
    );
  }

  Widget _exerciseNameWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Exercise Name',
        ),
        validator: (value) =>
            value.isEmpty ? 'Exercise name cannot be empty' : null,
        onSaved: (value) => _exerciseName = value.trim(),
      ),
    );
  }

  Widget _weightWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        autofocus: false,
        keyboardType:
            TextInputType.numberWithOptions(decimal: false, signed: false),
        decoration: InputDecoration(
          hintText: 'Weight',
        ),
        validator: (value) => value.isEmpty ? 'Weight cannot be empty' : null,
        onSaved: (value) => _weight = int.parse(value.trim()),
      ),
    );
  }

  Widget _repsWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        autofocus: false,
        keyboardType:
            TextInputType.numberWithOptions(decimal: false, signed: false),
        decoration: InputDecoration(
          hintText: 'Reps',
        ),
        validator: (value) => value.isEmpty ? 'Reps cannot be empty' : null,
        onSaved: (value) => _reps = int.parse(value.trim()),
      ),
    );
  }

  showAddSetModule() {
    setState(() {
      isAddingSet = true;
    });
  }

  addSet() {
    print('adding set');
    _validateAndSubmit();
    setState(() {
      isAddingSet = false;
    });
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _validateAndSubmit() async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    // if (_validateAndSave()) {
    //   Response res = await User.login(_email, _password);
    //   if (res.success) {
    //     Navigator.push(context, MaterialPageRoute(builder: (context) {
    //       return HomePage();
    //     }));
    //   } else {
    //     _errorMessage = res.errMessage;
    //   }
    //   setState(() {
    //     _isLoading = false;
    //   });
    // } else {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }
}
