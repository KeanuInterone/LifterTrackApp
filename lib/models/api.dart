import 'dart:convert';

import 'package:lifter_track_app/models/response.dart';
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

  static Future<bool> validateToken() async {
    if (authToken == null) return false;
    String url = '$baseURL/users/me';
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken'
      },
    );
    return response.statusCode == 200;
  }

  


  static Future<Response> makeApiRequest({String path, HttpMethod method = HttpMethod.get,  dynamic body,}) async {
    if (authToken == null) return Response(false, 'No authtoken', null);
    String url = '$baseURL/$path';

    var response;
    switch (method) {
      case HttpMethod.get:
        response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken'
          },
        );
        break;
      case HttpMethod.post:
        response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken'
          },
          body: body
        );
        break;
      case HttpMethod.delete:
        response = await http.get(
          url,
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
