import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lifter_track_app/models/api.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/response.dart';

class Exercises extends ChangeNotifier {
  List<Exercise> _exercises = [];
  List<Exercise> get exercises => _exercises;
  void setExercises(List<Exercise> exercises) {
    _exercises = exercises;
    notifyListeners();
  } 
  Future<Response> addExercise(Exercise exercise) async {
    Response res = await Exercise.create(exercise);
    if (res.success) {
      _exercises.add(res.data);
      notifyListeners();
    }
    return res;
  }
  void removeExercise(Exercise exercise) {
    _exercises.removeWhere((e) => e.id == exercise.id);
    notifyListeners();
  }

  Future<Response> getExercises() async {
    String url = "${API.baseURL}/exercises";
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${API.authToken}'
      },
    );
    if (response.statusCode != 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      bool hasError = json != null && json.containsKey('error');
      return Response(false, hasError ? json['error'] : "There was an error creating the user", null);
    }

    List<dynamic> json = jsonDecode(response.body);
    List<Exercise> exerciseList = [];
    json.forEach((exerciseJson) { 
      exerciseList.add(Exercise.fromJson(exerciseJson));
    });
    setExercises(exerciseList);
    return  Response(true, null, null);
  }  
}