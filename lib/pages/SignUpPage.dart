import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/components/keyboardDefocuser.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/user.dart';
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
    return keyboardDefocuser(
      context,
      child: background(
        context,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            title: text('Sign up!'),
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
      ),
    );
  }

  Widget signUpFormWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Form(
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
      ),
    );
  }

  Widget _emailWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: formField(
        placeholder: 'Email',
        autofocus: true,
        autoCorrect: false,
        textCapitalization: TextCapitalization.none,
        keyboardType: TextInputType.emailAddress,
        validator: (value) => value.isEmpty ? 'Email cannot be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _passwordWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: formField(
        placeholder: 'Password',
        obscureText: true,
        autofocus: false,
        validator: (value) => value.isEmpty ? 'Password cannot be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _firstNameWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: formField(
        placeholder: 'First Name',
        autofocus: false,
        textCapitalization: TextCapitalization.words,
        validator: (value) =>
            value.isEmpty ? 'First name cannot be empty' : null,
        onSaved: (value) => _first_name = value.trim(),
      ),
    );
  }

  Widget _lastNameWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: formField(
        placeholder: 'Last Name',
        textCapitalization: TextCapitalization.words,
        autofocus: false,
        validator: (value) =>
            value.isEmpty ? 'Last name cannot be empty' : null,
        onSaved: (value) => _last_name = value.trim(),
      ),
    );
  }

  Widget signUpButtonWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 35.0, 10, 0),
      child: button(
        text: 'Sign Up',
        height: 60.0,
        color: Theme.of(context).focusColor,
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
          await User.signUp(_email, _password, _first_name, _last_name, context);
      if (res.success) {
        navigateTo('home', context);
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
