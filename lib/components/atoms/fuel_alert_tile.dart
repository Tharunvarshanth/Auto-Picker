import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';

class FuelAlertTile extends StatelessWidget {
  String timeStamp;
  String message;
  String senderId;
  String fillingStationLat;
  String fillingStationLon;
  String city;
  bool diesel;
  bool petrol;
  void Function() onView;

  FuelAlertTile(
      {Key key,
      this.timeStamp = 'no time',
      this.message,
      this.senderId,
      this.fillingStationLat = '',
      this.fillingStationLon = '',
      this.city = '',
      this.diesel,
      this.petrol,
      this.onView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                maxLines: 2,
                style: TextStyle(fontSize: 12, color: AppColors.black),
                textAlign: TextAlign.start,
              ),
              Text(
                DateTime.parse(timeStamp).toLocal().toString(),
                maxLines: 2,
                style: TextStyle(fontSize: 12, color: AppColors.black),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: <Widget>[
                  ListTile(
                      title: const Text('Petrol'),
                      leading: Checkbox(
                        checkColor: AppColors.Blue,
                        value: diesel,
                      )),
                  ListTile(
                    title: const Text('Petrol'),
                    leading: Checkbox(
                      checkColor: AppColors.Blue,
                      value: petrol,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Text(
          'City : ${city}',
          style: TextStyle(
              fontSize: 14,
              color: AppColors.green,
              fontWeight: FontWeight.w600),
          textAlign: TextAlign.start,
        ),
        fillingStationLat != ""
            ? IconButton(
                icon: Icon(Icons.map_sharp),
                color: AppColors.black,
                onPressed: onView,
              )
            : Text(''),
      ],
    ));
  }
}
