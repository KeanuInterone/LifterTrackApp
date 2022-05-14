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

  Future<Response> editExercise(Exercise exercise) async {
    Response res =
        await exercises.firstWhere((e) => e.id == exercise.id).update(exercise);
    if (res.success) {
      parseExercises();
      notifyListeners();
    }
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

    // LOOP THROUGH EXERCISES
    for (Exercise exercise in exercises) {

      // ADD INDEX
      exerciseWithId[exercise.id] = exercise;
      
      // SORT INTO TAG GROUPS
      if (exercise.tagIDs.isEmpty) {
        if (groupedExercises['other'] == null) {
          groupedExercises['other'] = [];
        }
        groupedExercises['other'].add(exercise);
      } else {
        for (String tagId in exercise.tagIDs) {
          if (groupedExercises[tagId] == null) {
            groupedExercises[tagId] = [];
          }
          groupedExercises[tagId].add(exercise);
        }
      }
    }
  }

  clear() {
    exercises = [];
    exerciseWithId = {};
    groupedExercises = {};
    notifyListeners();
  }
}