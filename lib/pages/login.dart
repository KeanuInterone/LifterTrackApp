import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/hide_if.dart';
import 'package:lifter_track_app/components/navigator.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/Notifiers/exercises.dart';
import 'package:lifter_track_app/models/Notifiers/tags_notifier.dart';
import 'package:lifter_track_app/models/Notifiers/workouts.dart';
import 'package:lifter_track_app/models/user.dart';
import 'package:lifter_track_app/pages/home.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:lifter_track_app/components/background.dart';
import 'package:lifter_track_app/components/button.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/models/api.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
);

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    validateAuthToken(context);
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      if (account == null) return;
      account.authentication.then((googleKey) async {
        Response res = await User.authorizeOAuthToken(token: googleKey.idToken, provider: 'google');
        if (!res.success) {
          setState(() {
            _errorMessage = res.errMessage;
          });
          return;
        }
        initializeData();
        navigateTo('home', context);
      });
    });
  }

  void validateAuthToken(BuildContext context) async {
    await API.loadAuthtoken();
    bool validAuthToken = await API.validateToken();
    if (validAuthToken) {
      initializeData();
      navigateTo('home', context);
    }
  }

  void initializeData() {
    Provider.of<Exercises>(context, listen: false).getExercises();
    Provider.of<TagsNotifier>(context, listen: false).getTags();
    Provider.of<Workouts>(context, listen: false).getWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: background(
        context,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                titleWidget(),
                loginFormWidget(),
                orWidget(),
                signUpWidget(context)
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  Widget titleWidget() {
    return Expanded(
      flex: 3,
      child: Container(
        child: Center(
          child: Text(
            'Lifter Track',
            style: TextStyle(
                color: Colors.white, fontSize: 60, fontWeight: FontWeight.w100),
          ),
        ),
      ),
    );
  }

  Widget loginFormWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _emailWidget(),
            _passwordWidget(),
            hideIf(
                condition: _errorMessage == '',
                child: text(_errorMessage,
                    color: Colors.red, textAlign: TextAlign.center)),
            _loginButtonWidget()
          ],
        ),
      ),
    );
  }

  Widget _emailWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: formField(
        placeholder: "Email",
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
        autoCorrect: false,
        textCapitalization: TextCapitalization.none,
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password cannot be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _loginButtonWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: button(
        text: "Login",
        isLoading: _isLoading,
        color: Theme.of(context).primaryColor,
        height: 48.0,
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

  Widget orWidget() {
    return Expanded(
      flex: 1,
      child: Container(
        child: Center(
          child: Text(
            'or',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget signUpWidget(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SignInButton(
              Buttons.Google,
              onPressed: handleGoogleSignIn,
            ),
            SignInButton(
              Buttons.Apple,
              onPressed: handleAppleSignIn,
            ),
            TextButton(
              onPressed: () {
                navigateTo('sign_up', context);
              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> handleGoogleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> handleAppleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      Response res = await User.authorizeOAuthToken(token: credential.identityToken, provider: 'apple', firstName: credential.givenName, lastName: credential.familyName);
        if (!res.success) {
          setState(() {
            _errorMessage = res.errMessage;
          });
          return;
        }
        initializeData();
        navigateTo('home', context);
    } catch (e) {}
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
      Response res = await User.login(_email, _password);
      if (res.success) {
        initializeData();
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

  // Widget background({child: Widget}) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment(-0.75, -1.25),
  //         end: Alignment(0.1, 0.25),
  //         colors: [
  //           Theme.of(context).primaryColor,
  //           //Colors.pink,
  //           Theme.of(context).backgroundColor
  //         ],
  //       ),
  //     ),
  //     child: child,
  //   );
  // }
}
