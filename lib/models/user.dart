import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lifter_track_app/models/Notifiers/CurrentUserNotifier.dart';
import 'dart:convert';
import 'package:lifter_track_app/models/api.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:provider/provider.dart';


enum Role { super_admin, admin, premium_user, free_user, trainer }

class User {

  String id;
  String firstName;
  String lastName;
  Role role;


  User({this.id, this.firstName, this.lastName, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    Role role;
    switch (json['role']) {
      case 'super_admin':
        role = Role.super_admin;
        break;
      case 'admin':
        role = Role.admin;
        break;
      case 'premium_user':
        role = Role.premium_user;
        break;
      case 'free_user':
        role = Role.free_user;
        break;
      case 'trainer':
        role = Role.trainer;
        break;
    }
    return User(
        id: json['_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        role: role);
  }

  static Future<Response> login(
      String email, String password, BuildContext context) async {
    String url = "${API.baseURL}/users/login";
    Uri uri = Uri.parse(url);
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode != 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      bool hasError = json != null && json.containsKey('error');
      return Response(false,
          hasError ? json['error'] : "There was an error logging in", null);
    }

    Map<String, dynamic> json = jsonDecode(response.body);
    Provider.of<CurrentUserNotifier>(context, listen: false)
        .setUser(User.fromJson(json['user']));
    API.authToken = json['jwt'];
    await API.saveAuthToken();
    return Response(true, null, true);
  }

  static Future<Response> authorizeOAuthToken(
      {String token,
      String provider,
      String firstName,
      String lastName,
      BuildContext context}) async {
    String url = "${API.baseURL}/users/authorizeOAuthToken";
    Uri uri = Uri.parse(url);
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'token': token,
        'provider': provider,
        'first_name': firstName,
        'last_name': lastName
      }),
    );
    if (response.statusCode != 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      bool hasError = json != null && json.containsKey('error');
      return Response(
          false,
          hasError ? json['error'] : "There was an error authorizing the token",
          null);
    }

    Map<String, dynamic> json = jsonDecode(response.body);
    Provider.of<CurrentUserNotifier>(context, listen: false)
        .setUser(User.fromJson(json['user']));
    API.authToken = json['jwt'];
    await API.saveAuthToken();
    return Response(true, null, true);
  }

  static Future<Response> signUp(
      String email, String password, String firstName, String lastName, BuildContext context) async {
    String url = "${API.baseURL}/users/create";
    Uri uri = Uri.parse(url);
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName
      }),
    );
    if (response.statusCode != 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      bool hasError = json != null && json.containsKey('error');
      return Response(
          false,
          hasError ? json['error'] : "There was an error creating the user",
          null);
    }

    // Successfully created account, log in
    Response res = await login(email, password, context);
    if (!res.success) {
      return Response(false, res.errMessage, null);
    }

    return Response(true, null, null);
  }
}
