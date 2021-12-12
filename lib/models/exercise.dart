import 'dart:convert';

import 'package:lifter_track_app/models/api.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:http/http.dart' as http;
import 'package:lifter_track_app/models/tag.dart';

enum ExerciseType { barbell, weight, bodyweight }
enum WeightInput { plates, value }

class Exercise {
  String id;
  String name;
  List<String> tagIDs;
  List<Tag> tags;
  ExerciseType type;
  bool trackPerSide;
  WeightInput weightInput;
  Exercise({this.id, this.name, this.tagIDs, this.tags, this.type, this.trackPerSide, this.weightInput}) {
    if (this.tagIDs == null) {
      tagIDs = [];
    }
    if (this.tags == null) {
      tags = [];
    }
  }
  factory Exercise.fromJson(Map<String, dynamic> json) {
    
    ExerciseType type;
    switch (json['type']) {
      case 'barbell':
        type = ExerciseType.barbell;
        break;
      case 'weight':
        type = ExerciseType.weight;
        break;
      case 'bodyweight':
        type = ExerciseType.bodyweight;
        break;
    }
    WeightInput weightInput;
    switch (json['weight_input']) {
      case 'plates':
        weightInput = WeightInput.plates;
        break;
      case 'value':
        weightInput = WeightInput.value;
        break;
    }
    return Exercise(id: json['_id'], name: json['name'], tagIDs: json['tags'].cast<String>(), type: type, trackPerSide: json['track_per_side'], weightInput: weightInput);
  }

  static Future<Response> create(Exercise newExercise) async {
    String type;
    switch (newExercise.type) {
      case ExerciseType.barbell:
        type = 'barbell';
        break;
      case ExerciseType.weight:
        type = 'weight';
        break;
      case ExerciseType.bodyweight:
        type = 'bodyweight';
        break;
    }

    String weightInput;
    switch (newExercise.weightInput) {
      case WeightInput.plates:
        weightInput = 'plates';
        break;
      case WeightInput.value:
        weightInput = 'value';
        break;
    }

    String url = "${API.baseURL}/exercises/create";
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${API.authToken}'
      },
      body: jsonEncode({'name': newExercise.name, 'type': type, 'weight_input': weightInput, 'track_per_side':newExercise.trackPerSide ?? false, 'tags': newExercise.tagIDs}),
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
