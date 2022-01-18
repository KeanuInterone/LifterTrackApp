import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:lifter_track_app/models/Notifiers/exercises.dart';
import 'package:lifter_track_app/models/Notifiers/tags_notifier.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/tag.dart';


class GroupedExerciseList extends StatelessWidget {
  final List<String> tagIds;
  final TagsNotifier tags;
  final Exercises exercises;
  final Function(Exercise exercise) onExerciseTap;
  const GroupedExerciseList({Key key, this.tagIds, this.tags, this.exercises, this.onExerciseTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // OTHER TAG
    bool hasOtherTag = exercises.groupedExercises['other'] != null;
    Widget otherTagWidget = SizedBox(height: 0);
    if (hasOtherTag) {
      otherTagWidget = _tagExerciseGroup(context, 'Other', exercises, 'other');
    }

    // TAGS
    List<Widget> tagGroups = [];
    for (var tagId in tagIds) {
      if (tagId == 'other') {
        // SKIP
        tagGroups.add(SizedBox(
          height: 0,
        ));
      } else {
        Tag tag = tags.tagWithId[tagId];
        tagGroups.add(Column(
          children: [
            _tagExerciseGroup(context, tag.name, exercises, tagId),
            SizedBox(
              height: 30,
            )
          ],
        ));
      }
    }

    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: tagGroups + [otherTagWidget],
    );
  }

  ListView _tagExerciseGroup(
      BuildContext context, String tagName, Exercises exercises, String tagId) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        text(tagName, fontSize: 30, fontWeight: FontWeight.bold),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: exercises.groupedExercises[tagId]
              .map(
                (exercise) => GestureDetector(
                  child: Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: text(exercise.name, fontSize: 28),
                  ),
                  onTap: () {
                    onExerciseTap(exercise);
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
