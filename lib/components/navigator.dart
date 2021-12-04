import 'package:flutter/material.dart';

void navigateTo(String pageName, BuildContext context, {dynamic parameters,}) {
  Navigator.pushNamed(context, pageName, arguments: parameters ?? null);
}

void replaceScreenWith(String pageName, BuildContext context, {dynamic parameters}) {
  Navigator.of(context).pushReplacementNamed(pageName, arguments: parameters ?? null);
}

void pop(BuildContext context) {
  Navigator.pop(context);
}
