import 'package:flutter/material.dart';
Widget box({double height = 40, double width, Color borderColor = Colors.white, Color fillColor = Colors.transparent, double cornerRadius = 20, Widget child}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: fillColor,
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.all(Radius.circular(cornerRadius))
    ),
    child: child
  );
}