import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget formField(
    {String placeholder,
    TextEditingController controller,
    FocusNode focusNode,
    String initialValue,
    FontWeight fontWeight,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction,
    TextAlign textAlign = TextAlign.start,
    String Function(String value) validator,
    Function(String) onSaved,
    Function(String) onChanged,
    bool obscureText = false,
    bool required = false,
    bool autofocus = false,
    bool autoCorrect = false,
    TextCapitalization textCapitalization = TextCapitalization.none}
    ) {
  return TextFormField(
    controller: controller,
    focusNode: focusNode,
    initialValue: initialValue,
    maxLines: 1,
    autofocus: autofocus,
    obscureText: obscureText,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    autocorrect: autoCorrect,
    textAlign: textAlign,
    textCapitalization: textCapitalization,
    style: TextStyle(color: Colors.white, fontWeight: fontWeight),
    cursorColor: Colors.white,
    decoration: InputDecoration(
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.white),
      ),
      hintText: placeholder,
      hintStyle: TextStyle(color: Colors.white),
    ),
    validator: validator ?? (value) {return required && value.isEmpty ? 'value cannot be empty' : null;},
    onSaved: onSaved ?? (value) {},
    onChanged: onChanged ?? (value) {}
  );
}
