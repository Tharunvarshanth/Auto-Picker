import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';

void navigate(BuildContext context, routeName) {
  Navigator.of(context)?.pushNamed(routeName);
}

void navigateWithState(BuildContext context, routeName, params) {
  Navigator.of(context)?.pushNamed(routeName, arguments: {"phoneNumber": "mk"});
}

void navigateBack(BuildContext context) {
  Navigator.pop(context);
}

String utcTo12HourFormat(String bigTime) {
  DateTime tempDate = DateFormat("hh:mm").parse(bigTime);
  var dateFormat = DateFormat("h:mm a"); // you can change the format here
  var utcDate = dateFormat.format(tempDate); // pass the UTC time here
  var localDate = dateFormat.parse(utcDate, true).toLocal().toString();
  String createdDate = dateFormat.format(DateTime.parse(localDate));
  print("------------$createdDate");
  return createdDate;
}

stringToTimeFormat(String bigTime) {
  DateTime tempDate = DateFormat("hh:mm").parse(bigTime);

  return tempDate;
}

findDistanceBetweenLocations(l1, l2) {
  final Distance distance = Distance();

  // km = 423
  final double km = distance.as(LengthUnit.Kilometer, l1, l2);

  return km;
}
