import 'package:flutter/material.dart';

Widget background({context: BuildContext, child: Widget}) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment(-0.75, -1.25),
        end: Alignment(0.1, 0.25),
        colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).backgroundColor
        ],
      ),
    ),
    child: child,
  );
}
