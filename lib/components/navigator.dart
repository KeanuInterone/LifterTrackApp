import 'package:flutter/material.dart';

void navigateTo(Widget page, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return page;
      },
    ),
  );
}

void pop(BuildContext context) {
  Navigator.pop(context);
}
