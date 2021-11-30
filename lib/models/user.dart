import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lifter_track_app/models/api.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/exercise.dart';

class User {
  static User currentUser;

  String id;
  String firstName;
  String lastName;

  User({this.id, this.firstName, this.lastName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      firstName: json['first_name'],
      lastName: json['last_name']
    );
  }

  static Future<Response> login(
      String email, String password) async {
    String url = "${API.baseURL}/users/login";
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode != 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      bool hasError = json != null && json.containsKey('error');
      return Response(false, hasError ? json['error'] : "There was an error creating the user", null);
    }

    Map<String, dynamic> json = jsonDecode(response.body);
    currentUser = User();
    API.authToken = json['jwt'];
    await API.saveAuthToken();
    return Response(true, null, true);
  }

  static Future<Response> signUp(
      String email, String password, String firstName, String lastName) async {
    String url = "${API.baseURL}/users/create";
    var response = await http.post(
      url,
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
      return Response(false, hasError ? json['error'] : "There was an error creating the user", null);
    }

    // Successfully created account, log in
    Response res = await login(email, password);
    if (!res.success) {
      return Response(false, res.errMessage, null);
    }

    Map<String, dynamic> json = jsonDecode(response.body);
    currentUser = User.fromJson(json);
    return  Response(true, null, currentUser);
  }
}


