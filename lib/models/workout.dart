import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lifter_track_app/models/api.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/set.dart';
import 'package:lifter_track_app/models/set_group.dart';

class Workout {
  String id;
  List<SetGroup> setGroups;


  Workout({this.id, this.setGroups});

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['_id'],
      setGroups: []
    );
  }

  static Future<Response> create() async {
    String url = "${API.baseURL}/workouts/create";
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${API.authToken}'
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
    Workout workout = Workout.fromJson(json);
    return Response(true, null, workout);
  }
}
