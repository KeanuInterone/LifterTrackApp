import 'dart:convert';

import 'package:lifter_track_app/models/api.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/set.dart';
import 'package:http/http.dart' as http;


class SetGroup {
  String id;
  String focusExerciseId;
  Exercise focusExercise;
  List<Set> sets;

  SetGroup({this.id, this.sets, this.focusExerciseId, this.focusExercise});

  factory SetGroup.fromJson(Map<String, dynamic> json) {

    Exercise exercise;
    String exerciseId;
    if (json['focus_exercise'] is Map<String, dynamic>) {
      exercise = Exercise.fromJson(json['focus_exercise']);
      exerciseId = exercise.id; 
    } else {
      exerciseId = json['focus_exercise'];
    }

    return SetGroup(
      id: json['_id'],
      focusExerciseId: exerciseId,
      focusExercise: exercise,
      sets: []
    );
  }

  static Future<Response> create() async {
    String url = "${API.baseURL}/setgroups/create";
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
          hasError ? json['error'] : "There was an error creating the set group",
          null);
    }

    Map<String, dynamic> json = jsonDecode(response.body);
    SetGroup setGroup = SetGroup.fromJson(json);
    return Response(true, null, setGroup);
  }  
}
