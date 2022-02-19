import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lifter_track_app/models/Notifiers/CurrentUserNotifier.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum HttpMethod { get, post, delete }

class API {
  static String baseURL = "https://staging.api.liftertrack.com";
  static String authToken = "";

  static saveAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('authToken', authToken);
  }

  static loadAuthtoken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('authToken');
  }

  static Future<bool> validateToken(BuildContext context) async {
    if (authToken == null) return false;
    Response res = await API.makeApiRequest(path: 'users/me',);
    if (res.success) {
       Provider.of<CurrentUserNotifier>(context, listen: false)
        .setUser(User.fromJson(res.data));
    }
    return res.success;
  }

  


  static Future<Response> makeApiRequest({String path, HttpMethod method = HttpMethod.get,  dynamic body,}) async {
    if (authToken == null) return Response(false, 'No authtoken', null);
    String url = '$baseURL/$path';
    Uri uri = Uri.parse(url);
    var response;
    switch (method) {
      case HttpMethod.get:
        response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken'
          },
        );
        break;
      case HttpMethod.post:
        response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken'
          },
          body: body
        );
        break;
      case HttpMethod.delete:
        response = await http.delete(
          uri,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken'
          },
        );
        break;
    }
    if (response.statusCode != 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      bool hasError = json != null && json.containsKey('error');
      return Response(
        false,
        hasError ? json['error'] : "There was an error",
        null,
      );
    }
    try {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Response(true, null, json);
    } on TypeError catch(e) {
      List<dynamic> listJson = jsonDecode(response.body);
      return Response(true, null, listJson);
    } catch (e) {
      return Response(false, e, null);
    }
  }
}
