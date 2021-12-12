import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lifter_track_app/models/api.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/tag.dart';

class NewExerciseNotifier extends ChangeNotifier {
  Exercise exercise = Exercise();
  
  void setName(String name) {
    exercise.name = name;
    notifyListeners();
  } 

  void setExerciseType(ExerciseType type) {
    exercise.type = type;
    notifyListeners();
  }

  void setWeightInputType(WeightInput type) {
    exercise.weightInput = type;
    notifyListeners();
  }

  void setTrackPerSide(bool trackPerSide) {
    exercise.trackPerSide = trackPerSide;
    notifyListeners();
  }

  void addTag(Tag tag) {
    exercise.tagIDs.add(tag.id);
    exercise.tags.add(tag);
    notifyListeners();
  }

  void removeTag(Tag tag) {
    exercise.tagIDs.remove(tag.id);
    exercise.tags.remove(tag);
    notifyListeners();
  }

  void clearExercise() {
    exercise = Exercise();
    notifyListeners();
  }
}