import 'dart:convert';

import 'package:lifter_track_app/models/api.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:http/http.dart' as http;

enum ExerciseType { barbell, weight, weights, bodyweight, value }

class Exercise {
  String id;
  String name;
  ExerciseType type;
  Exercise({this.id, this.name, this.type});
  factory Exercise.fromJson(Map<String, dynamic> json) {
    ExerciseType type;
    switch (json['type']) {
      case 'barbell':
        type = ExerciseType.barbell;
        break;
      case 'weight':
        type = ExerciseType.weight;
        break;
      case 'weights':
        type = ExerciseType.weights;
        break;
      case 'bodyweight':
        type = ExerciseType.bodyweight;
        break;
      default:
        type = ExerciseType.value;
    }
    return Exercise(id: json['_id'], name: json['name'], type: type);
  }

  static Future<Response> create(String name, String type) async {
    String url = "${API.baseURL}/exercises/create";
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${API.authToken}'
      },
      body: jsonEncode({'name': name, 'type': type}),
    );
    if (response.statusCode != 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      bool hasError = json != null && json.containsKey('error');
      return Response(
          false,
          hasError ? json['error'] : "There was an error creating the Exercise",
          null);
    }

    Map<String, dynamic> json = jsonDecode(response.body);
    Exercise exercise = Exercise.fromJson(json);
    return Response(true, null, exercise);
  }
}
