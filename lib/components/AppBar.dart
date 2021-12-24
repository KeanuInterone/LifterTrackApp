import 'package:flutter/material.dart';
import 'package:lifter_track_app/components/navigator.dart';

Widget appBar(BuildContext context, {Widget centerChild, Widget rightChild}) {
  return Container(
    height: 80,
    child: Stack(
      children: [
        Container(
          constraints: BoxConstraints.expand(width: 60),
          child: IconButton(
            iconSize: 40,
            onPressed: () {
              pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        Center(
          child: centerChild ?? Container(),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: rightChild ?? Container(),
        ),
      ],
    ),
  );
}
