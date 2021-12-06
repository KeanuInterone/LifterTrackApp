import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:flutter/services.dart';

class ScrollableValuePicker extends StatefulWidget {
  final int initialValue;
  final int increment;
  final void Function(int value) onValueChanged;

  const ScrollableValuePicker({Key key, this.initialValue, this.onValueChanged, this.increment}) : super(key: key);

  @override
  _ScrollableValuePickerState createState() => _ScrollableValuePickerState();
}

class _ScrollableValuePickerState extends State<ScrollableValuePicker> {
  int sensitivity = 30;
  int currentValue;
  int displayedValue;
  int currentScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
    displayedValue = currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: text('$displayedValue'),
          )),
      onVerticalDragUpdate: (details) {
        int ticks = details.localPosition.dy ~/ sensitivity;
        if (currentScrollOffset != ticks) {
          HapticFeedback.heavyImpact();
          currentScrollOffset = ticks;
          setState(() {
            displayedValue = currentValue + widget.increment * ticks;
            widget.onValueChanged(displayedValue);
          });
        }
      },
      onVerticalDragEnd: (details) {
        currentValue = displayedValue;
      },
    );
  }
}
