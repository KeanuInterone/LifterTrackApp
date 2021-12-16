import 'package:flutter/material.dart';

Widget button(
    {String text,
    double borderWidth = 2,
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w400,
    Color color = Colors.white,
    Color fillColor = Colors.transparent,
    double height,
    bool isLoading = false,
    Function onPressed}) {
  return Container(
    height: height,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: fillColor,
        side: BorderSide(color: color, width: borderWidth),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      child: isLoading
          ? CircularProgressIndicator(color: color)
          : Text(
              text,
              style: new TextStyle(
                  fontSize: fontSize, fontWeight: fontWeight, color: color),
            ),
      onPressed: onPressed ?? () {},
    ),
  );
}
