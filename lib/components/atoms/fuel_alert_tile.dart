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

  FuelAlertTile(
      {Key key,
      this.timeStamp = 'no time',
      this.message,
      this.senderId,
      this.fillingStationLat = '',
      this.fillingStationLon = '',
      this.city = '',
      this.diesel,
      this.petrol})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        Expanded(
            child: Padding(
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
                ],
              ),
            ),
            flex: 4),
        Expanded(
            child: Padding(
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
                        leading: Radio<bool>(
                          value: petrol,
                        ),
                      ),
                      ListTile(
                        title: const Text('Diesel'),
                        leading: Radio<bool>(
                          value: diesel,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            flex: 4),
        Expanded(
            child: Text(
              'City : ${city}',
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.green,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            flex: 2),
        Expanded(
            child: IconButton(
              icon: Icon(Icons.map_sharp),
              color: AppColors.black,
              onPressed: () {},
            ),
            flex: 2),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
