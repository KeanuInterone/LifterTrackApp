import 'package:flutter/material.dart';

Widget text(String text,
    {double fontSize = 20,
    FontWeight fontWeight = FontWeight.w300,
    Color color = Colors.white}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}
