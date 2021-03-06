import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/ValueField.dart';
import 'package:lifter_track_app/components/hide_if.dart';
import 'package:lifter_track_app/components/scrollableValuePicker.dart';
import 'package:lifter_track_app/components/text.dart';

class ValueSetForm extends StatelessWidget {
  final int initialWeight;
  final int initialReps;
  final void Function(int) onWeightChanged;
  final void Function(int) onRepsChanged;
  final bool trackPerSide;
  const ValueSetForm(
      {Key key,
      this.initialWeight,
      this.initialReps,
      this.onRepsChanged,
      this.onWeightChanged,
      this.trackPerSide = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: Container()),
        weightAndReps(),
        Expanded(child: Container()),
      ],
    );
  }

  Widget weightAndReps() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                text('Weight', fontSize: 18, fontWeight: FontWeight.bold),
                hideIf(condition: !trackPerSide, child: text('per side', fontSize: 12, fontWeight: FontWeight.normal)),
                SizedBox(
                  height: 10,
                ),
                ValueField(
                  value: initialWeight,
                  onValueChanged: onWeightChanged,
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            child: text('x', textAlign: TextAlign.center),
          ),
          Expanded(
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
          )
        ],
      ),
    );
  }
}
