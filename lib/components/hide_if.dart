import 'package:flutter/material.dart';

Widget hideIf({bool condition = false, Widget child}) {
  return condition ? SizedBox(height: 0) : child;
}