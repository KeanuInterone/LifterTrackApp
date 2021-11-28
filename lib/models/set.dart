import 'package:lifter_track_app/models/exercise.dart';

class Set {
  String id;
  String exerciseId;
  Exercise exercise;
  int weight;
  int reps;
  Set({this.id, this.exerciseId, this.exercise, this.weight, this.reps});
  factory Set.fromJson(Map<String, dynamic> json) {
    
    Exercise exercise;
    String exerciseId;
    if (json['exercise'] is Map<String, dynamic>) {
      exercise = Exercise.fromJson(json['exercise']);
      exerciseId = exercise.id; 
    } else {
      exerciseId = json['exercise'];
    }
    
    return Set(
      id: json['_id'],
      exerciseId: exerciseId,
      exercise: exercise,
      weight: json['weight'],
      reps: json['reps'],
    );
  }
}
