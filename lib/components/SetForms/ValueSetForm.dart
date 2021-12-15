import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/scrollableValuePicker.dart';
import 'package:lifter_track_app/components/text.dart';

class ValueSetForm extends StatelessWidget {
  final int initialWeight;
  final int initialReps;
  final void Function(int) onWeightChanged;
  final void Function(int) onRepsChanged;
  const ValueSetForm(
      {Key key,
      this.initialWeight,
      this.initialReps,
      this.onRepsChanged,
      this.onWeightChanged})
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
            child: ScrollableValuePicker(
              value: initialWeight,
              increment: 1,
              onValueChanged: onWeightChanged,
            ),
          ),
          Container(
            width: 40,
            child: text('x', textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 1,
            child: ScrollableValuePicker(
              value: initialReps,
              increment: 1,
              onValueChanged: onRepsChanged,
            ),
          ),
        ],
      ),
    );
  }
}
