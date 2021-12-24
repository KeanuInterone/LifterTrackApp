import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lifter_track_app/models/api.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/tag.dart';

class Exercises extends ChangeNotifier {
  List<Exercise> exercises = [];
  Map<String, Exercise> exerciseWithId = {};
  Map<String, List<Exercise>> groupedExercises = {};
 
  Future<Response> addExercise(Exercise exercise) async {
    Response res = await Exercise.create(exercise);
    if (res.success == false) return res; 
    exercises.add(res.data);
    parseExercises();
    notifyListeners();
    return res;
  }

  void removeExercise(Exercise exercise) {
    exercises.removeWhere((e) => e.id == exercise.id);
    parseExercises();
    notifyListeners();
  }

  Future<Response> getExercises() async {
    Response res = await Exercise.getExercises();
    if (res.success == false) return res;
    exercises = res.data;
    parseExercises();
    notifyListeners();
    return res;
  }

  void parseExercises() {
    exerciseWithId = {};
    groupedExercises = {};
    for (Exercise exercise in exercises) {
      exerciseWithId[exercise.id] = exercise;
      for(String tagId in exercise.tagIDs) {
        if (groupedExercises[tagId] == null) {
          groupedExercises[tagId] = [];
        }
        groupedExercises[tagId].add(exercise);
      }
    }
  }  

  Future<Response> getExercises2() async {
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
    exerciseWithId = {};
    groupedExercises = {};
    json.forEach((exerciseJson) { 
      Exercise exercise = Exercise.fromJson(exerciseJson);
      exerciseList.add(exercise);
      exerciseWithId[exercise.id] = exercise;
      for(String tagId in exercise.tagIDs) {
        if (groupedExercises[tagId] == null) {
          groupedExercises[tagId] = [];
        }
        groupedExercises[tagId].add(exercise);
      }
    });
    //setExercises(exerciseList);
    return  Response(true, null, null);
  }  
}