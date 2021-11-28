import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lifter_track_app/models/api.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/set.dart';

class Workout {
  String id;
  List<Set> sets;

  Workout({this.id, this.sets});

  factory Workout.fromJson(Map<String, dynamic> json) {
    
    return Workout(
      id: json['_id'],
    );
  }

  static Future<Response> create() async {
    String url = "${API.baseURL}/workouts/create";
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      bool hasError = json != null && json.containsKey('error');
      return Response(
          false,
          hasError ? json['error'] : "There was an error creating the workout",
          null);
    }

    Map<String, dynamic> json = jsonDecode(response.body);
    API.authToken = json['jwt'];
    return Response(true, null, true);
  }
}
