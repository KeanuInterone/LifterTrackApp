import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/formField.dart';
import 'package:flutter/services.dart';

class ValueField extends StatefulWidget {
  final int value;
  final TextEditingController textController;
  final void Function(int value) onValueChanged;

  const ValueField(
      {Key key, this.value, this.textController, this.onValueChanged})
      : super(key: key);

  @override
  _ValueFieldState createState() => _ValueFieldState();
}

class _ValueFieldState extends State<ValueField> {
  int displayedValue;
  int currentScrollOffset = 0;
  TextEditingController textController;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    displayedValue = widget.value;
    textController = widget.textController;
    if (textController == null) {
      textController = TextEditingController();
    }
    textController.text = '$displayedValue';
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        textController.selection = TextSelection(
            baseOffset: 0, extentOffset: textController.text.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return formField(
      controller: textController,
      fontWeight: FontWeight.bold,
      focusNode: focusNode,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onChanged: (text) {
        int value = int.tryParse(text) ?? 0;
        displayedValue = value;
        widget.onValueChanged(value);
      },
    );
  }
}
