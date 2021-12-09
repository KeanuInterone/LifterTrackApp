import 'package:flutter/material.dart';

Widget button(
    {String text, Color color = Colors.white, double height, bool isLoading = false, Function onPressed}) {
  return Container(
    height: height,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color, width: 2),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      child: isLoading ? CircularProgressIndicator(color: color) : Text(
        text,
        style: new TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.w400, color: color),
      ),
      onPressed: onPressed ?? () {},
    ),
  );
}
