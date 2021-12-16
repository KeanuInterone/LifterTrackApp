import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/ValueField.dart';
import 'package:lifter_track_app/components/scrollableValuePicker.dart';
import 'package:lifter_track_app/components/text.dart';

class BodyweightSetForm extends StatelessWidget {
  final int initialReps;
  final void Function(int) onRepsChanged;
  const BodyweightSetForm({
    Key key,
    this.initialReps,
    this.onRepsChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: Container()),
        reps(),
        Expanded(child: Container()),
      ],
    );
  }

  Widget reps() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: Expanded(
        flex: 1,
        child: Column(
          children: [
            text('Reps', fontSize: 18, fontWeight: FontWeight.bold),
            SizedBox(
              height: 10,
            ),
            ValueField(
              value: initialReps,
              onValueChanged: onRepsChanged,
            ),
          ],
        ),
      ),
    );
  }
}
