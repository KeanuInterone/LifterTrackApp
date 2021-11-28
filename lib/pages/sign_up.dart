import 'package:flutter/material.dart';
import 'package:lifter_track_app/models/user.dart';
import 'package:lifter_track_app/pages/home.dart';
import 'package:lifter_track_app/models/response.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _first_name;
  String _last_name;
  String _errorMessage = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign up!'),
        ),
        body: ListView(
          children: <Widget>[
            signUpFormWidget(),
            signUpButtonWidget(),
            errorWidget(),
          ],
          physics: ClampingScrollPhysics(),
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  Widget signUpFormWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          _emailWidget(),
          _passwordWidget(),
          _firstNameWidget(),
          _lastNameWidget()
        ],
      ),
    );
  }

  Widget _emailWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Enter Email',
          icon: Icon(Icons.mail, color: Colors.grey),
        ),
        validator: (value) => value.isEmpty ? 'Email cannot be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _passwordWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Password',
          icon: Icon(Icons.lock, color: Colors.grey),
        ),
        validator: (value) => value.isEmpty ? 'Password cannot be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _firstNameWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: InputDecoration(hintText: 'First Name'),
        validator: (value) =>
            value.isEmpty ? 'First name cannot be empty' : null,
        onSaved: (value) => _first_name = value.trim(),
      ),
    );
  }

  Widget _lastNameWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: InputDecoration(hintText: 'Last Name'),
        validator: (value) =>
            value.isEmpty ? 'Last name cannot be empty' : null,
        onSaved: (value) => _last_name = value.trim(),
      ),
    );
  }

  Widget signUpButtonWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 35.0, 10, 0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5.0,
        minWidth: 200.0,
        height: 42.0,
        color: Colors.blue,
        child: Text('Sign Up',
            style: new TextStyle(fontSize: 20.0, color: Colors.white)),
        onPressed: _validateAndSubmit,
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

    if (_validateAndSave()) {
      Response res =
          await User.signUp(_email, _password, _first_name, _last_name);
      if (res.success) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      } else {
        _errorMessage = res.errMessage;
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
