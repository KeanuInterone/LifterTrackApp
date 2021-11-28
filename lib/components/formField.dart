import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget formField(
    {String placeholder,
    TextInputType keyboardType = TextInputType.text,
    String Function(String value) validator,
    Function(String) onSaved,
    bool obscureText = false,
    bool required = false}
    ) {
  return TextFormField(
    maxLines: 1,
    autofocus: false,
    obscureText: obscureText,
    keyboardType: keyboardType,
    style: TextStyle(color: Colors.white),
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
  );
}
