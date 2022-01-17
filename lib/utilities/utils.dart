import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void navigate(BuildContext context, routeName) {
  Navigator.of(context)?.pushNamed(routeName);
}

void navigateWithState(BuildContext context, routeName, params) {
  Navigator.of(context)?.pushNamed(routeName, arguments: {"phoneNumber": "mk"});
}

void navigateBack(BuildContext context) {
  Navigator.pop(context);
}
