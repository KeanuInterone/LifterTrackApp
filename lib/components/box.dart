import 'package:flutter/material.dart';
Widget box({double height = 40, Color borderColor = Colors.white, Color fillColor = Colors.transparent, Widget child}) {
  return Container(
    height: height,
    decoration: BoxDecoration(
      color: fillColor,
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.all(Radius.circular(20))
    ),
    child: child
  );
}