import 'package:flutter/material.dart';

Widget text(String text,
    {double fontSize = 20,
    FontWeight fontWeight = FontWeight.w300,
    Color color = Colors.white,
    TextAlign textAlign = TextAlign.left}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
    textAlign: textAlign,
  );
}
