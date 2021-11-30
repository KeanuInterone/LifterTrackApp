import 'package:flutter/material.dart';

Widget keyboardDefocuser(BuildContext context, {Widget child}) {
  return GestureDetector(
    child: child,
    onTap: () {
      FocusScope.of(context).requestFocus(FocusNode());
    },
  );
}
