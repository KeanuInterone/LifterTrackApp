import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:lifter_track_app/components/text.dart';
import 'package:flutter/services.dart';

class ScrollableValuePicker extends StatefulWidget {
  final int initialValue;
  final int increment;
  final void Function(int value) onValueChanged;

  const ScrollableValuePicker(
      {Key key, this.initialValue, this.onValueChanged, this.increment})
      : super(key: key);

  @override
  _ScrollableValuePickerState createState() => _ScrollableValuePickerState();
}

class _ScrollableValuePickerState extends State<ScrollableValuePicker> {
  int sensitivity = 30;
  int currentValue;
  int displayedValue;
  int currentScrollOffset = 0;
  TextEditingController textController;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
    displayedValue = currentValue;
    textController = TextEditingController(text: '$displayedValue');
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        textController.selection =
            TextSelection(baseOffset: 0, extentOffset: textController.text.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // child: Container(
      //     height: 50,
      //     decoration: BoxDecoration(
      //       border: Border.all(color: Colors.white),
      //       borderRadius: BorderRadius.all(Radius.circular(20)),
      //     ),
      //     child: Center(
      //       child: text('$displayedValue'),
      //     )),
      child: Column(children: [
        IconButton(
          onPressed: () {
            HapticFeedback.heavyImpact();
            displayedValue = currentValue + widget.increment;
            currentValue = displayedValue;
            textController.text = '$displayedValue';
            widget.onValueChanged(displayedValue);
          },
          icon: Icon(
            Icons.arrow_drop_up,
            color: Colors.white,
            size: 50,
          ),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        ),
        formField(
            controller: textController,
            focusNode: focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onChanged: (text) {
              int value = int.tryParse(text) ?? 0;
              currentValue = value;
              widget.onValueChanged(value);
            }),
        IconButton(
          onPressed: () {
            HapticFeedback.heavyImpact();
            displayedValue = currentValue - widget.increment;
            currentValue = displayedValue;
            textController.text = '$displayedValue';
            widget.onValueChanged(displayedValue);
          },
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
            size: 50,
          ),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        ),
      ]),
      onVerticalDragUpdate: (details) {
        int ticks = details.localPosition.dy ~/ sensitivity;
        if (currentScrollOffset != ticks) {
          HapticFeedback.heavyImpact();
          currentScrollOffset = ticks;
          displayedValue = currentValue - widget.increment * ticks;
          textController.text = '$displayedValue';
          widget.onValueChanged(displayedValue);
        }
      },
      onVerticalDragEnd: (details) {
        currentValue = displayedValue;
      },
    );
  }
}
